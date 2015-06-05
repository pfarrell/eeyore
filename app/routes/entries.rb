
require 'date'

class App < Sinatra::Application

  get "/entries/:group" do
    data = Entry.where(group: params[:group])
    haml :report, locals: {title: params[:group].upcase, model: {header: data.columns, data: data}} 
  end

  post "/entries/:group" do
    json=JSON.parse(request.body.read)
    entry = Entry.find_or_create(group: params[:group], type: json["type"], date: json["date"], data: json["data"])
    if(entry.id.nil?)
      entry.type = params[:type]
      entry.date = params[:date] || DateTime.now.iso8601
      entry.data = params[:data]
      entry = entry.save
    end
    entry.to_json
  end

end
