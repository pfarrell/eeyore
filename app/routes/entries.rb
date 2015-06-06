
require 'date'

class App < Sinatra::Application

  get "/entries/:group" do
    data = Entry.where(group: params[:group])
    haml :report, locals: {title: params[:group].upcase, model: {header: data.columns, data: data}} 
  end

  post "/entries/:group" do
    json=JSON.parse(request.body.read)
    entry = Entry.find(group: params[:group], type: json["type"], date: json["date"])
    if(entry.nil?)
      entry = Entry.new
      entry.group = json["group"]
      entry.type = json["type"]
      entry.date = json["date"] || DateTime.now.iso8601
      entry.data = json["data"]
      entry = entry.save
    end
    entry.to_json
  end

end
