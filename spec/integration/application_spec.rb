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

  context "POST/albums" do
    it 'returns 200 OK and creates new album in database' do
      post_response = post('/albums', title: 'Voyage', release_year: 2022, artist_id: 2)
      expect(post_response.status).to eq(200)

      get_response = get('/albums')
      expect(get_response.body).to include "Voyage" 
    end
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
    it 'returns 200 OK and lists all artists in database' do
      response = get('/artists')
      expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone'
   
      expect(response.status).to eq(200)
      expect(response.body).to eq expected_response
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
