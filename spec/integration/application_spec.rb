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
    it 'returns 200 OK and lists all albums in database' do
      response = get('/albums')
      expected_response = 'Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'
   
      expect(response.status).to eq(200)
      expect(response.body).to eq expected_response
  end
end

context "GET to /" do
  it 'contains a h1 title containing greeting hello' do
    response = get('/')

    expect(response.body).to include('<h1>Hello!</h1>')
  end
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