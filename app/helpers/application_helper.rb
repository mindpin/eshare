module ApplicationHelper
  def truncate_u(text, length = 30, truncate_string = "...")
    truncate(text, :length => length, :separator => truncate_string)
  end

  def page_file_uploader
    # .page-file-uploader
    #   .list
    #     .item.sample{:style => 'display:none;'}
    #       = page_progress_bar 61, :striped, :active
    #       .meta
    #         .filename foobarfoobarfoobarfoobarfoobarfoobarfoobar.zip
    #         .size 1.6M
    #         .percent 62%

    haml_tag '.page-file-uploader' do
      haml_tag '.list' do
        haml_tag 'div.item.sample', :style => 'display:none;' do
          haml_concat page_progress_bar(62, :striped, :active)
          haml_tag '.meta' do
            haml_tag '.filename', 'foobarfoobarfoobarfoobarfoobarfoobarfoobar.zip'
            haml_tag '.size', '1.6M'
            haml_tag '.percent', '62%'
          end
        end
      end
    end
  end

  def avatar(user, style = :normal)
    klass = ['page-avatar', style] * ' '

    if user.blank?
      alt   = t('common.unknown-user')
      src   = User.new.avatar.versions[style].url
      meta  = 'unknown-user'
    else
      alt   = user.name
      src   = user.avatar.versions[style].url
      meta  = dom_id(user)
    end

    image_tag src, :alt => alt,
                   :class => klass,
                   :data => {
                      :meta => meta
                   }
  end
end
