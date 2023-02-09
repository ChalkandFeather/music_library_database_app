require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  before(:each) do
    albums_seeds_sql = File.read("spec/seeds/albums_seeds.sql")
    artists_seeds_sql = File.read("spec/seeds/artists_seeds.sql")
    connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test" })
    connection.exec(albums_seeds_sql)
    connection.exec(artists_seeds_sql)
  end

  context "GET/albums" do
    it 'lists all albums in database' do
      response = get('/albums')
  
      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/albums/2">Surfer Rosa</a><br />')	
      expect(response.body).to include('<a href="/albums/3">Waterloo</a><br />')	
      expect(response.body).to include('<a href="/albums/4">Super Trouper</a><br />')	
  end
end

context 'GET /albums/new' do
  it 'should return the form to add a new album' do
    response = get('/albums/new')

    expect(response.status).to eq(200)
    expect(response.body).to include('<form method="POST" action="/albums">')
    expect(response.body).to include('<input type="text" name="title" />')
    expect(response.body).to include('<input type="text" name="release_year" />')
    expect(response.body).to include('<input type="text" name="artist_id" />')

  end
end

context "POST/albums" do
  it 'should validate album parameters' do
    response = post('/albums', invalid_artist_title: 'OK Computer', another_invalid_thing: 123)
    
    expect(response.status).to eq(400)
  end
  ######################################
  xit 'returns 200 OK and creates new album in database' do
    post_response = post('/albums', title: 'Voyage', release_year: 2022, artist_id: 2)
    
    expect(post_response.status).to eq(200)
   
    
    get_response = get('/albums')
    
    expect(get_response.body).to include "Voyage" 
  end
end



context "GET /albums/:id" do
  it 'contains a h1 title containing albums title  and body params from albums id 1' do
    response = get('/albums/1')

    expect(response.status).to eq(200)
    expect(response.body).to include('<h1>Doolittle</h1>')
    expect(response.body).to include('Release year: 1989')
    expect(response.body).to include ('Artist: Pixies')
  end
end

it 'contains a h1 title containing albums title  and body params from albums id 2' do
  response = get('/albums/2')

  expect(response.status).to eq(200)
  expect(response.body).to include('<h1>Surfer Rosa</h1>')
  expect(response.body).to include('Release year: 1988')
  expect(response.body).to include ('Artist: Pixies')
end
  
    context "GET/artists" do
      it 'lists all artists in database' do
        response = get('/artists')
    
        expect(response.status).to eq(200)
        expect(response.body).to include('<a href="/artists/1">Pixies</a><br />')	
        expect(response.body).to include('<a href="/artists/2">ABBA</a><br />')	
        expect(response.body).to include('<a href="/artists/3">Taylor Swift</a><br />')	
    end
  end


context "GET /artists/:id" do
  it 'contains artist and body params from artist id 1' do
    response = get('/artists/1')

    expect(response.status).to eq(200)
    expect(response.body).to include('<h1>Artist</h1>')
    expect(response.body).to include('Name: Pixies')
    expect(response.body).to include('Genre: Rock')
    end
  end

    context "POST/artists" do
    it 'returns 200 OK and creates new artist in database' do
      post_response = post('/artists', name: 'Wild nothing', genre: 'Indie')
      expect(post_response.status).to eq(200)

      get_response = get('/artists')
      expect(get_response.body).to include "Wild nothing" 
    end
  end
end

