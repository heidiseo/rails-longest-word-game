require 'json'
require 'open-uri'

class GamesController < ApplicationController
  LETTERS = ('A'..'Z').to_a
  def new
    @letters = LETTERS.sample(10)
  end

  def score
    display = params[:displayed].split("")
    attempt = params[:word]
    result = attempt.upcase.chars.all? { |letter| attempt.upcase.chars.count(letter) <= display.count(letter) }
    if result
      @sentence = search(attempt)
    else
      @sentence = "The word can't be built out of the original grid"
    end
  end
end

def search(word)
  url = "https://wagon-dictionary.herokuapp.com/#{word}"
  dictionary = open(url).read
  word_search = JSON.parse(dictionary)
  if word_search["found"]
    @sentence = "Congrats! You gained #{word_search["length"]}points!"
  else
    @sentence = "Sorry, this is not a word"
  end
end
