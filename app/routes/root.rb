class App < Sinatra::Application
  get "/" do
    haml :index, locals: {groups: Group.all}
  end

  get "/download" do
    path=params[:path]
    respond_to do |wants|
      wants.csv { DB[:groups].to_csv}
    end
  end
end
