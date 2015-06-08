require 'date'

class App < Sinatra::Application

  def group_header
    props={}
    props["date"]={value:lambda{|x| x.date.strftime("%Y-%m-%d %H:%M:%S")}}
    props["data"]={value:lambda{|x| x.data.to_json}}
    props["tags"]={value:lambda{|x| x.tags.map{|x| x.tag}.join(", ")}}
    props
  end

  def specific_header
    props={}
    props["date"]={value:lambda{|x| x.date.strftime("%Y-%m-%d %H:%M:%S")}}
    props["tags"]={value:lambda{|x| x.tags.map{|y| y.tag}.join(", ")}}
    props
  end

  get "/entries/:group/latest" do
    group = Group.find(name: params[:group])
    latest = Entry.where(group: group).order(Sequel.desc(:date)).first
    latest.to_json
  end

  get "/entries/:group/errors" do
    group = Group.find(name: params[:group])
    tag = Tag.find(group: group, tag: "ERROR")
    arr = tag.entries.map{|x| x.data["listing_id"]}.uniq
    haml :errors, locals: {group: group, errors: arr}
  end

  get "/entries/:group" do
    redirect "/entries/#{params[:group]}/1"
  end

  get "/entries/:group/tag/:tag" do
    page = params[:page].to_i
    group = Group.find(name: params[:group])
    data = Tag.find(group: group, tag: params[:tag]).entries.sort_by{|entry| entry.date}.reverse
    haml :specific, locals: {
      group: group.name, 
      tag: params[:tag], 
      model: {
        header: specific_header, 
        data: data
      }, 
      base: "/entries/#{group.name}"} 
  end
  
  get "/entries/:group/:page" do
    page = params[:page].to_i
    group = Group.find(name: params[:group])
    tags = DB[:entries_tags].join(:tags, id: :tag_id).where(group_id: group.id).group_and_count(:tag).order(Sequel.desc(:count))
    data = Entry.where(group: group).order(Sequel.desc(:date)).paginate(page, 100)
    haml :report, locals: {group: group.name, model: {header: group_header, data: data}, tags: tags} 
  end


  post "/entries/:group" do
    group = Group.find_or_create(name: params[:group])
    json=JSON.parse(request.body.read)
    entry = handle_entry(group, json)
    handle_tags(entry, json["tags"])
    entry.to_json
  end

  def handle_entry(group, hsh)
    entry = Entry.find(group: group, date: hsh["date"])
    if(entry.nil?)
      entry = Entry.new
      entry.group = group
      entry.date = hsh["date"] || DateTime.now.iso8601
      entry.data = hsh["data"]
      entry = entry.save
    end
    entry
  end
  
  def handle_tags(entry, arr)
    arr.each do |tag| 
      tag = Tag.find_or_create(group: entry.group, tag: tag)
      if entry.tags.select{|x| x == tag}.count == 0
        entry.add_tag tag
        tag.save
      end
    end
  end
end
