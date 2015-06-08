class App < Sinatra::Application
  def specific_header
    props={}
    props["date"]={value:lambda{|x| x.date.strftime("%Y-%m-%d %H:%M:%S")}}
    props["tags"]={value:lambda{|x| x.tags.map{|y| y.tag}.join(", ")}}
    props
  end

  get "/search/:group" do
    group = Group.find(name: params[:group])
    tags = Tag.find(group: group, tag: params[:q])
    data = tags.nil? ? nil : tags.entries.sort_by{|entry| entry.date}.reverse
    if data.nil?
      haml :error, locals: {msg: "No matches"}
    else
      haml :specific, locals: {
        group: group.name, 
        tag: params[:q], 
        model: {
          header: specific_header, 
          data: data
        }, 
        base: "/entries/#{group.name}"} 
    end
  end
end
