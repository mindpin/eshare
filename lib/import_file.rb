module ImportFile

  class FormatError < Exception; end

  def self.open_spreadsheet(file)
    original_filename = file.original_filename
    case File.extname(original_filename)
    when ".sxc" then Roo::Openoffice.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise FormatError.new("Incorrect format #{original_filename}")
    end
  end


  module UserMethods
    
    def User.import(file, role)
      spreadsheet = ImportFile.open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        user = find_by_email(row['email']) || new
        user.attributes = row.to_hash.slice(*accessible_attributes)
        user.set_role(role)
        user.save
      end
    end

    
  end




  module CourseMethods

    def Course.import(file, user)
      spreadsheet = ImportFile.open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        course = Course.new(:name => row['name'],
                          :cid => row['cid'],
                          :desc => row['desc'],
                          :syllabus => row['syllabus'])
        course.creator = user
        course.save
      end
    end

    
  end


end