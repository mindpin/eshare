module FileEntityStorage
  module Filesystem
    class EncodeStatus
      ENCODEING = "ENCODING"
      SUCCESS  = "SUCCESS"
      FAILURE  = "FAILURE"
    end


    def self.included(base)
      base.has_attached_file :attach,
                        :styles => lambda {|attach|
                          attach.instance.is_image? ? {:large => '460x340#', :small => '220x140#'}  : {}
                        },
                        :path => FILE_ENTITY_ATTACHED_PATH,
                        :url  => FILE_ENTITY_ATTACHED_URL

      base.send(:include, InstanceMethods)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def create_by_params(file_name,file_size)
        self.create(
          :attach_file_name => get_randstr_filename(file_name),
          :attach_content_type => file_content_type(file_name),
          :attach_file_size => file_size,
          :merged => false
        )
      end
    end


    module InstanceMethods

      def save_first_blob(blob)
        FileUtils.mkdir_p(File.dirname(self.attach.path))
        FileUtils.mv(blob.path,self.attach.path)

        self.update_attributes(
          :saved_size => blob.size,
          :attach_updated_at => self.created_at
        )
        self.check_completion_status
      end

      def save_new_blob(file_blob)
        file_blob_size = file_blob.size
        # `cat '#{file_blob.path}' >> '#{file_path}'`
        File.open(self.attach.path,"a") do |src_f|
          File.open(file_blob.path,'r') do |f|
            src_f << f.read
          end
        end

        self.saved_size += file_blob_size
        self.save
        self.check_completion_status
      end

      def sync_save(blob)
        FileUtils.mkdir_p(File.dirname(self.attach.path))
        FileUtils.mv(blob.path,self.attach.path)

        self.update_attributes(
          :saved_size => blob.size,
          :attach_updated_at => self.created_at,
          :merged => true
        )
        # 如果 文件是图片，生成 all styles 图片
        self.attach.reprocess!
        if self.is_video?
          self.into_video_encode_queue
        end
      end

      def check_completion_status
        return if self.saved_size != self.attach_file_size

        self.update_attributes( :merged => true )
        # 如果 文件是图片，生成 all styles 图片
        self.attach.reprocess!
        if self.is_video?
          self.into_video_encode_queue
        end
      end

      def attach_flv_path
        "#{self.attach.path}.flv"
      end

      def attach_flv_url
        self.attach.url.gsub(/\?.*/,".flv")
      end

      def video_encoding?
        is_video? && video_encode_status == FileEntity::EncodeStatus::ENCODEING
      end

      def video_encode_success?
        is_video? && video_encode_status == FileEntity::EncodeStatus::SUCCESS
      end

      def video_encode_failure?
        is_video? && video_encode_status == FileEntity::EncodeStatus::FAILURE
      end

      def into_video_encode_queue
        return if !self.is_video?
        return if self.video_encode_success?

        self.video_encode_status = FileEntity::EncodeStatus::ENCODEING
        self.save
        FileEntityVideoEncodeResqueQueue.enqueue(self.id)
      end

      def http_url(style = :original)
        self.attach.url(style)
      end

      def screenshot_urls
        httpurl = self.http_url
        urls = []
        1.upto(10) do |i|
          arr = httpurl.split('original')
          arr.pop
          urls << arr.push("/screenshot_#{i}.jpg").join('original')
        end

        urls
      rescue
        []
      end

    end

  end
end