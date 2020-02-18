require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    selection = []
    alphabet = ('A'..'Z').to_a
    9.times { selection << alphabet.sample }
    @letters = selection
    return @letters
  end

  def score
    @choice = params[:letters].upcase.split("")
    letters = params[:letter_list].upcase.split("")
    @score = @choice.count
    if grid_word(@choice, letters)
      if check_if_word(@choice)
        @result = "Congratulations, #{@choice.join.downcase.capitalize} is both a word, and in the grid, your score is #{@score}"
      else
        @result = "#{@choice.join.downcase.capitalize} isn't a real word, you fool"
      end
    else
      @result = "#{@choice.join.downcase.capitalize} can't be made from #{letters.join(" - ")}, learn to read you fool"
    end
    @result
  end

  def grid_word(attempt, grid)
    # binding.pry
    attempt.all? { |letter| attempt.count(letter) <= grid.count(letter) }
  end

  def check_if_word(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt.join}"
    valid = JSON.parse(open(url).read)
    valid['found'] == true
  end

end
