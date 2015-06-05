class App < Sinatra::Application
  get "/" do
    haml :index, locals: {entries: Entry.groups}
  end
end
