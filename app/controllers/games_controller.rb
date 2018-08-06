require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    @letters = []
    letters = 10.times do |letter|
      letter = ("A".."Z").to_a.sample
      @letters << letter
    end
  end

  def score
    @try = params[:name]
    @grid = params[:letters]
    if build_out_of_the_grid?(@try, @grid)
      if is_english?(@try) == true
        @score = "Congratulations! #{@try} is a valid English word!"
      else
        @score = "Sorry but #{@try} does not seem to be a valid English word..."
      end
    else
      @score = "Sorry but #{@try} can't be built out of #{@grid}"
    end
  end

  def build_out_of_the_grid?(essai, grille)
    essai.upcase.split(//).each do |letter|
      if grille.include?(letter) && (grille.count(letter) >= essai.count(letter))
        @score = true
      else
        @score = false
      end
    end
    @score
  end

  def is_english?(essai)
    url = "https://wagon-dictionary.herokuapp.com/#{essai}"
    results = open(url).read
    result = JSON.parse(results)
    @score = result['found']
  end
end
