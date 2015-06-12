class App < Sinatra::Application
  get "/" do
    haml :index, {locals: {groups: Group.all}, layout: :layout_no_download}
  end

end
