module MediaResourceDynatreeMethods
  extend ActiveSupport::Concern

  def lazyload_sub_dynatree(current_resource)
    return [] if current_resource == self
    child_resources = self.media_resources.dir_res
    child_resources.map do |resource|
      isLazy = resource.media_resources.dir_res.blank? ? false : true
      isLazy = false if current_resource == resource
      {
        :title => resource.name, :dir => resource.path,
        :isFolder => true, :isLazy => isLazy
      }
    end
  end

  def preload_dynatree
    root_resources = self.creator.media_resources.root_res.dir_res
    ancestor_resources = self_and_ancestors-[self]
    children = self.class._preload_dynatree(root_resources,ancestor_resources,self)
    [{
      :title => '根目录', :isFolder => true, :activate => true, :dir => "",
      :children=>children, :expand => true
    }]
  end

  def self_and_ancestors
    resources = [self]
    loop do
      resource = resources.first.dir
      break if resource.blank?
      resources.unshift(resource)
    end
    resources
  end

  module ClassMethods

    def root_dynatree(user)
      root_resources = user.media_resources.root_res.dir_res
      [{
        :title => '根目录', :isFolder => true, :activate => true, :dir => "",
        :children=>_preload_dynatree(root_resources,[]), :expand => true
      }]
    end

    def _preload_dynatree(resources,ancestor_resources,current_resource = nil)
      resources.map do |resource|
        child_resources = resource.media_resources.dir_res
        isLazy = child_resources.blank? ? false : true
        children = ancestor_resources.include?(resource) ? _preload_dynatree(child_resources,ancestor_resources,current_resource) : []
        activate = resource == current_resource ? true : false
        expand = ancestor_resources.include?(resource) ? true : false

        {
          :title => resource.name, :dir => resource.path,
          :isFolder => true, :children => children,
          :expand => expand, :activate => activate, :isLazy => isLazy
        }
      end
    end

    # 个人资源库 整个文件树的 dynatree 数据
    def dynatree(user)
      root_resources = user.media_resources.root_res
      [{
        :title => '根目录', :isFolder => true, :activate => true, :dir => "",
        :children=>_dynatree(root_resources), :expand => true
      }]
    end

    def _dynatree(resources)
      resources.map do |resource|
        media_resources = resource.media_resources
        {
          :title => resource.name, :isFolder => resource.is_dir?,
          :activate => true, :id => resource.id,
          :children=>_dynatree(media_resources), :expand => false
        }
      end
    end

  end

end



