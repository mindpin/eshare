module MediaResourceCrudMethods
  extend ActiveSupport::Concern

  module CreateMethods
    extend ActiveSupport::Concern

    module ClassMethods
      def put_file_entity(creator, resource_path, file_entity)
        resource_path = _process_same_file_name(creator, resource_path)
        _put(creator, resource_path, file_entity)
      end

      def put(creator, resource_path, file)
        raise MediaResource::NotAssignCreatorError if creator.blank?
        raise MediaResource::FileEmptyError if file.blank?

        self.put_file_entity creator, resource_path, FileEntity.new(:attach => file)
      end

      def replace(creator, resource_path, file)
        raise MediaResource::NotAssignCreatorError if creator.blank?
        raise MediaResource::FileEmptyError if file.blank?

        _put creator, resource_path, FileEntity.new(:attach => file)
      end

      def create_folder(creator, resource_path)
        raise MediaResource::RepeatedlyCreateFolderError if !self.get(creator, resource_path).blank?

        with_exclusive_scope do
          dir_names = split_path(resource_path)
          return _mkdirs_by_names(creator, dir_names)
        end
      rescue MediaResource::InvalidPathError
        return nil
      end

      private
        # 根据传入的资源路径字符串以及文件对象，创建一个文件资源
        # 传入的路径类似 /hello/test.txt
        # 创建文件资源的过程中，关联创建文件夹资源
        def _put(creator, resource_path, file_entity)
          with_exclusive_scope do
            file_name = split_path(resource_path)[-1]
            dir_names = split_path(resource_path)[0...-1] # 只创建到上层目录

            collect = _mkdirs_by_names(creator, dir_names).media_resources

            resource = collect.find_or_initialize_by_name_and_creator_id(file_name, creator.id)

            resource.remove_children
            resource.update_attributes(
              :creator     => creator,
              :name        => file_name,
              :is_dir      => false,
              :is_removed  => false,
              :file_entity => file_entity
            )

            # 这里需要返回resource以便在controller里调用
            resource
          end
        end

        def _mkdirs_by_names(creator, dir_names)
          collect = creator.media_resources.root_res
          dir_resource = MediaResource::RootDir

          dir_names.each {|dir_name|
            dir_resource = collect.find_or_initialize_by_name_and_creator_id(dir_name, creator.id)
            dir_resource.update_attributes :is_removed => false, :is_dir => true
            collect = dir_resource.media_resources
          }

          return dir_resource
        end

        # 自动重命名同名文件
        def _process_same_file_name(creator, resource_path)
          resource = self.get(creator,resource_path)
          return resource_path if resource.blank?

          
          file_name = split_path(resource_path)[-1]
          dir_names = split_path(resource_path)[0...-1] # 只创建到上层目录

          loop do
            file_name = rename_duplicated_file_name(file_name)
            paths = dir_names+[file_name]
            resource_path = "/#{paths*"/"}"
            resource = self.get(creator,resource_path)
            break if resource.blank?
          end

          return resource_path
        end
    end
  end

  module ReadMethods
    extend ActiveSupport::Concern

    module ClassMethods
      # 根据传入的资源路径字符串，查找一个资源对象
      # 传入的路径类似 /foo/bar/hello/test.txt
      # 或者 /foo/bar/hello/world
      # 找到的资源对象，可能是一个文件资源，也可能是一个文件夹资源
      def get(creator, resource_path)
        collect = creator.media_resources.root_res
        resource = nil
        split_path(resource_path).each { |name|
          resource = collect.find_by_name(name)
          return nil if resource.blank?
          collect = resource.media_resources
        }

        return resource
      rescue MediaResource::InvalidPathError
        return nil
      end

      # 根据传入的文件夹资源路径字符串，查找该文件夹下所有资源对象
      # 传入的路径类似 /foo/bar
      # 返回该文件夹下所有资源，包括下级文件和下级文件夹
      # 如果传入的路径并非文件夹，抛出异常 NotDirError
      def gets(creator, resource_path = '/')
        return self.root_res if resource_path == '/' || resource_path.blank?

        dir = self.get creator, resource_path
        raise MediaResource::InvalidPathError if dir.nil?
        raise MediaResource::NotDirError if !dir.is_dir?
        dir.media_resources
      end
    end
  end

  module UpdateMethods
    def move_to(to_dir_path)
      to_dir = MediaResource.get(self.creator, to_dir_path)
      to_dir_id = to_dir.blank? ? 0 : to_dir.id
      self.dir_id = to_dir_id
      self.save
    end
  end

  module DeleteMethods
    extend ActiveSupport::Concern

    def remove
      self.remove_children

      self.is_removed = true
      self.fileops_time = Time.now
      self.save

      if self.is_file?
        parent_dir = self.dir
        while !parent_dir.blank? do
          parent_dir.decrement!(:files_count, 1)
          parent_dir = parent_dir.dir
        end
      end
    end

    # 清空文件夹下文件
    def remove_children
      self.media_resources.each { |resource|
        resource.remove
      } if self.is_dir?
    end

    module ClassMethods
      def del(creator, resource_path)
        r = self.get(creator, resource_path)
        raise MediaResource::InvalidPathError if r.nil?
        r.remove
      end
    end
  end

  module ShareMethods
    def shared?
      media_share_rule ? true : false
    end

    def shared_to?(user)
      user.received_media_shares.where(:media_resource_id => self.id).any?
    end
  end

  module TagsMethods
    def set_tags_by!(user, tags)
      return if user != self.creator && self.is_dir?
      self.tag_list = tags.split(%r{,\s*}).uniq
      self.save
    end
  end

  module CommonMethods
    extend ActiveSupport::Concern

    module ClassMethods
      private
        # 根据传入的 resource_path 划分出涉及到的资源名称数组
        def split_path(resource_path) 
          raise MediaResource::InvalidPathError if resource_path.blank?
          raise MediaResource::InvalidPathError if resource_path[0...1] != '/'
          raise MediaResource::InvalidPathError if resource_path == '/'
          raise MediaResource::InvalidPathError if resource_path.match /\/{2,}/
          raise MediaResource::InvalidPathError if resource_path.include?('\\')

          resource_path.sub('/', '').split('/')
        end
    end
  end

  include CreateMethods
  include ReadMethods
  include UpdateMethods
  include DeleteMethods
  include ShareMethods
  include TagsMethods
  include CommonMethods
end