class Fenci
  STOP_WORDS = begin
    file = File.new File.expand_path(Rails.root.to_s + '/lib/stopwords.txt')
    file.read.split("\r\n") - ['']
  end

  def initialize(statuses)
    @statuses = statuses
  end

  def combine_into_words
    words = Hash.new(0)

    @statuses.each do |status|

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


  def sort_words
    words = combine_into_words
    words = words.sort_by {|k, v| v}.reverse
    ActiveSupport::OrderedHash[words]
  end


  def get_hot_words(count)
    hot_words = []
    words = sort_words
    words.keys[0..count].each { |key| hot_words << { key => words[key] } }
    hot_words
  end


  private
    def _prepate_text(text)
      s1 = text.gsub /@\S+/, ''
      s1.gsub /http:\/\/\S+/, ''
    end

end