class App < Sinatra::Application
  def search_header
    props={}
    props["date"]={value:lambda{|x| x.date.strftime("%Y-%m-%d %H:%M:%S")}}
    props["tags"]={value:lambda{|x| x.tags.map{|y| y.tag}.join(", ")}}
    props
  end

  get "/search/:group/tags" do
    group = Group.find(name: params[:group])
    {"suggestions"=>Tag.where(group: group).where(Sequel.ilike(:tag, "%#{params[:q]}%")).map{|x| x.tag}}.to_json
  end

  get "/search/:group" do
    redirect "/search/#{params[:group]}/1?q=#{params[:q]}" 
  end

  get "/search/:group/:page" do
    page = params[:page].to_i
    group = Group.find(name: params[:group])
    tag = Tag.find(group: group, tag: params[:q])
    
    if tag.nil?
      haml :error, locals: {msg: "No matches"}
    else
      haml :specific, locals: {
        group: group.name, 
        tag: params[:q], 
        model: {
          header: search_header, 
          data: Entry.filter(group: group).filter(tags: tag).paginate(page, 50)
        }, 
        base: "/entries/#{group.name}"} 
    end
  end
end
