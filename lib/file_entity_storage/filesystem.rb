module FileEntityStorage
  module Filesystem
    class EncodeStatus
      ENCODEING = "ENCODING"
      SUCCESS  = "SUCCESS"
      FAILURE  = "FAILURE"
    end


    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods

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