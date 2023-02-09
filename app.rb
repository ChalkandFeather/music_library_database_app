# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'
require_relative 'lib/album'
require_relative 'lib/artist'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all
      
    return erb(:albums_all)
    end
    
  
    post '/albums' do
      repo = AlbumRepository.new
      new_album = Album.new

      new_album.title = params[:title]
      new_album.release_year = params[:release_year]
      new_album.artist_id = params[:artist_id]
      
      repo.create(new_album)
    end

    
  get '/' do
    @name = params[:name]
    # The erb method takes the view file name (as a Ruby symbol)
    # and reads its content so it can be sent 
    # in the response.
    return erb(:index)
  end

 

  get '/albums/:id' do
    
  repo = AlbumRepository.new
  artist_repo = ArtistRepository.new
  
    # Set an instance variable in the route block.
    @id = params[:id]
    @album = repo.find(@id) 
    @artist = artist_repo.find(@album.artist_id)
    # The process is then the following:
    #
    # 1. Ruby reads the .erb view file
    # 2. It looks for any ERB tags and replaces it by their final value
    # 3. The final generated HTML is sent in the response
    return erb(:albums_id)
    end


  get '/artists/:id' do
    
    repo = ArtistRepository.new
   
    
      # Set an instance variable in the route block.
      @id = params[:id]
      @artist = repo.find(@id) 
      
      # The process is then the following:
      #
      # 1. Ruby reads the .erb view file
      # 2. It looks for any ERB tags and replaces it by their final value
      # 3. The final generated HTML is sent in the response
      return erb(:artist_id)
      end


    get '/artists' do
      repo = ArtistRepository.new
      @artists = repo.all
      
      return erb(:artists_all)
      end


    post '/artists' do
      repo = ArtistRepository.new
      new_artist = Artist.new

      new_artist.name = params[:name]
      new_artist.genre = params[:genre]
      
      repo.create(new_artist)
    end
end