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
        row = row.values

        user = User.new(:login => row[0],
                    :name => row[1],
                    :email => row[2],
                    :password => row[3])

        user.set_role(role)
        user.save
      end
    end

    
  end


end