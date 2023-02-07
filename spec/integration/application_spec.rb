require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  xcontext "POST/albums" do
    it 'returns 200 OK and creates new album in database' do
      response = post('/albums', title: 'Voyage', release_year: 2022, artist_id: 2)
      expect(response.status).to eq(200)
    end
  end

  context "GET/albums" do
    it 'returns 200 OK and lists all albums in database' do
      response = get('/albums')
      expected_response = 'Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova,Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'
   
      expect(response.status).to eq(200)
      expect(response.body).to eq expected_response
end
end
end