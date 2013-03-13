module ImportFile

  module UserMethods
    def User.included(base)
      base.send(:include, ClassMethods)
    end

    
    class ClassMethods

      def User.import(file, role)
        spreadsheet = open_spreadsheet(file)
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          p row
          user = find_by_email(row['email']) || new
          user.attributes = row.to_hash.slice(*accessible_attributes)
          user.set_role(role)
          user.save
        end
      end

      def User.open_spreadsheet(file)
        original_filename = file.original_filename
        case File.extname(original_filename)
        when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
        when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
        when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
        else raise "Unknown file type: #{original_filename}"
        end
      end

    end
  end
 


end