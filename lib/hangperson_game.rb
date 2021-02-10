class HangpersonGame
  
  def initialize(word)
      @word = word
      @wrong_guesses = ""
      @guesses = ""
  end

  def word()
      @word
  end

  def wrong_guesses()
      @wrong_guesses
  end

  def wrong_guesses_length()
      @wrong_guesses.length
  end

  def guesses()
      @guesses
  end

  def guess(letter)
    if(letter == nil || letter == "" || letter.match?(/[^a-zA-Z]/))
        raise ArgumentError
  end
      letter.downcase!
    if(@word.include?(letter))
        return false if @guesses.include?(letter)
        @guesses += letter
        return true
    else
        return false if @wrong_guesses.include?(letter)
        @wrong_guesses += letter
        return true
    end
  end

  def word_with_guesses()
    partial_matches = ""
    
    @word.each_char do |w| 
        if guesses.include?(w)
            partial_matches += w
        else
            partial_matches += "-"
        end
    end
    return partial_matches
end

def check_win_or_lose()
    return :win if @word == word_with_guesses()
    return :lose if @wrong_guesses.length == 7
    return :play
end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
