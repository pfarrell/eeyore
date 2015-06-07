require 'date'

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
    redirect "/entries/#{params[:group]}/1"
  end

  get "/entries/:group/type/:type" do
    redirect "/entries/#{params[:group]}/type/#{params[:type]}/1"
  end

  get "/entries/:group/type/:type/:page" do
    page = params[:page].to_i
    data = Entry.select(:type, :date, :data).where(group: params[:group], type: params[:type]).order(Sequel.desc(:date)).paginate(page, 100)
    haml :specific, locals: {group: params[:group], type: params[:type], model: {header: specific_header, data: data}} 
  end
  
  get "/entries/:group/:page" do
    page = params[:page].to_i
    data = Entry.select(:type, :date, :data).where(group: params[:group]).order(Sequel.desc(:date)).paginate(page, 100)
    haml :report, locals: {group: params[:group], model: {header: group_header, data: data}, types: Entry.types(params[:group])} 
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
