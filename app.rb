$: << File.expand_path('../app', __FILE__)

require 'sinatra'
require 'sinatra/url_for'
require 'sinatra/respond_to'
require 'securerandom'
require 'haml'

class App < Sinatra::Application
  helpers Sinatra::UrlForHelper
  register Sinatra::RespondTo

  if ENV["RACK_ENV"] == "production"
    use Rack::Auth::Basic, "Restricted Area" do |username, password|
      username == ENV["APP_USER"] and password == ENV["APP_PASS"]
    end
  end


  enable :sessions
  set :session_secret, ENV["APP_SESSION_SECRET"] || "youshouldreallychangethis"
  set :views, Proc.new { File.join(root, "app/views") }

  before do
    response.set_cookie(:appc, value: SecureRandom.uuid, expires: Time.now + 3600 * 24 * 365 * 10) if request.cookies["bmc"].nil?
  end

  helpers do
    def save_file(data, file)
      require 'byebug'
      byebug

    end

    def download_link
      "#{request.path}?#{request.query_string}&format=csv"
    end
  end

end

require 'models'
require 'routes'
require 'patches'
