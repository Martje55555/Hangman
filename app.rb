require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  get '/' do
    redirect '/home'
  end
  
  get '/home' do
    erb :home
  end

  get '/new' do
    erb :new
  end
  
  post '/create' do
    word = params[:word] || HangpersonGame.get_random_word
    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  post '/guess' do
        letter = params[:guess].to_s[0]
      begin
        valid = @game.guess(letter) 
       rescue ArgumentError
           flash[:message] = "Invalid Guess."
       else
           if valid == false
               flash[:message] = "You have already used that letter."
           end
      end
        redirect '/show'
  end
  
  get '/show' do
      redirect '/win' if @game.check_win_or_lose() == :win
      redirect '/lose' if @game.check_win_or_lose() == :lose
      redirect '/6MoreTries' if @game.check_win_or_lose() == :play && @game.wrong_guesses_length() == 1
      redirect '/5MoreTries' if @game.check_win_or_lose() == :play && @game.wrong_guesses_length() == 2
      redirect '/4MoreTries' if @game.check_win_or_lose() == :play && @game.wrong_guesses_length() == 3
      redirect '/3MoreTries' if @game.check_win_or_lose() == :play && @game.wrong_guesses_length() == 4
      redirect '/2MoreTries' if @game.check_win_or_lose() == :play && @game.wrong_guesses_length() == 5
      redirect '/1MoreTry' if @game.check_win_or_lose() == :play && @game.wrong_guesses_length() == 6

      erb :show #if @game.check_win_or_lose() == :play && @game.wrong_guesses_length() == 0
  end
  
  get '/win' do
    redirect '/show' if @game.check_win_or_lose() == :play
    erb :YouWON
  end
  
  get '/lose' do
    redirect '/show' if @game.check_win_or_lose() == :play
    erb :YouLOST
  end
    
  get '/6MoreTries' do
    redirect '/show' if @game.wrong_guesses_length() != 1
    erb :SixMoreTries
  end
    
  get '/5MoreTries' do
    redirect '/show' if @game.wrong_guesses_length() != 2
    erb :FiveMoreTries
  end
    
   get '/4MoreTries' do
    redirect '/show' if @game.wrong_guesses_length() != 3
    erb :FourMoreTries
  end
    
  get '/3MoreTries' do
    redirect '/show' if @game.wrong_guesses_length() != 4
    erb :ThreeMoreTries
  end
    
  get '/2MoreTries' do
    redirect '/show' if @game.wrong_guesses_length() != 5
    erb :TwoMoreTries
  end
    
  get '/1MoreTry' do
    redirect '/show' if @game.wrong_guesses_length() != 6
    erb :OneMoreTry
  end

end