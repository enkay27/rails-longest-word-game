class GamesController < ApplicationController
  require 'json'
  require 'open-uri'

  def new
    @letters = []
    9.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @answers = params[:answer]
    @letters = params[:letters].chars
    @result = run_game(@answers, @letters)
  end

  private

  def run_game(attempt, grid)
    @score = 0
    if letters_match(attempt, grid) == false
      @message = "#{attempt} letters not in the grid!"
    elsif found_in_dict(attempt) == false
      @message = "#{attempt} not an english word"
    else
      @message = 'Well Done!'
      @score = attempt.length
    end
    { score: @score, message: @message }
  end

  def found_in_dict(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    json_hash = JSON.parse(open(url).read)
    json_hash['found']
  end

  def letters_match(answer, grid)
    letters = answer.upcase.chars
    letters.all? { |char| letters.count(char) <= grid.count(char) }
  end
end
