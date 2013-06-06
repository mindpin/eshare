module Fenci
  STOP_WORDS = begin
    file = File.new File.expand_path(Rails.root.to_s + '/lib/stopwords.txt')
    file.read.split("\r\n") - ['']
  end


  private
    def self._prepate_text(text)
      s1 = text.gsub /@\S+/, ''
      s1.gsub /http:\/\/\S+/, ''
    end

    def self._combine_statuses(statuses)
      words = Hash.new(0)

      statuses.each do |status|

        algor = RMMSeg::Algorithm.new(_prepate_text(status))
      
        loop do
          tok = algor.next_token
          break if tok.nil?

          word = tok.text.force_encoding("UTF-8")

          if !STOP_WORDS.include?(word) && word.split(//u).length > 1
            words[word] = words[word] + 1            
          end
         
        end
      end

      words
    end

end