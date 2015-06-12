class App < Sinatra::Application
  get "/" do
    haml :index, locals: {groups: Group.all}
  end

end
