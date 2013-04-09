# 产生一个随机字符串
def randstr(length=8)
  base = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  size = base.size
  re = '' << base[rand(size-10)]
  (length - 1).times {
    re << base[rand(size)]
  }
  re
end

# 转换文件名为 mime-type
def file_content_type(file_name)
  MIME::Types.type_for(file_name).first.content_type
rescue
  ext = file_name.split(".")[-1]
  case ext
  when 'rmvb'
    'application/vnd.rn-realmedia'
  else
    'application/octet-stream'
  end
end

# 生成重名文件标示，例如: bla.jpg -> bla(1).jpg, bla(1).jpg -> bla(2).jpg
def rename_duplicated_file_name(file_name)
  file_ext = File.extname file_name
  file_basename = File.basename file_name, file_ext
  dup_note_reg = /\((\d)\)$/
  dup_note_match = file_basename.match dup_note_reg
  new_file_basename = dup_note_match ? file_basename.sub(dup_note_reg, "(#{dup_note_match[1].to_i + 1})") : file_basename + '(1)'

  new_file_basename + file_ext
end