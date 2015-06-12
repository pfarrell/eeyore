class App < Sinatra::Application
  get "/download" do
    path=params[:path]
    respond_to do |wants|
      group = Group.first
      wants.csv { Report.errors(group).to_csv}
    end
  end
end
