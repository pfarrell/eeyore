
require 'date'
    require 'byebug'

class App < Sinatra::Application

  def group_header
    props={}
    props["date"]={value:lambda{|x| x.date}}
    props["type"]={value:lambda{|x| x.type}}
    props["data"]={value:lambda{|x| x.data}}
    props
  end

  def specific_header
    props={}
    props["date"]={value:lambda{|x| x.date}}
    props["type"]={value:lambda{|x| x.type}}
    props
  end

  get "/entries/:group" do
    data = Entry.select(:type, :date, :data).where(group: params[:group])
    haml :report, locals: {title: params[:group].upcase, model: {header: group_header, data: data}, types: Entry.types(params[:group])} 
  end

  get "/entries/:group/:type" do
    data = Entry.select(:type, :date, :data).where(group: params[:group], type: params[:type])
    haml :specific, locals: {title: params[:group].upcase, model: {header: specific_header, data: data}} 
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
