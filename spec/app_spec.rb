require 'spec_helper'

describe 'App' do
  include RSpecMixin

  let(:group) {Group.find_or_create(name: "test")}
  let(:error_tag) {Tag.find_or_create(group: group, tag:"ERROR")}
  let(:debug_tag) {Tag.find_or_create(group: group, tag:"DEBUG")}
  let(:id_tag) {Tag.find_or_create(group: group, tag:"1234")}
  let(:entry) {create_entry}
  let(:json) {{tags:["ERROR"], data: {test: "pat"}}.to_json}

  before(:each) do
    authorize('u', 'p')
  end

  def create_entry
    e = Entry.find_or_create(group: group, date: DateTime.now)
    e.data = {listing_id: "1234"}
    e.group = group
    e.add_tag error_tag
    e.add_tag debug_tag
    e.add_tag id_tag
    e.save
    e
  end

  it "should allow access to the home page" do
    get "/"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Home/)
  end

  it "gives you the last entry send for a group" do
    get "/entries/#{group.name}/latest"
    expect(last_response).to be_ok
  end

  it "gives you uniqe errors" do
    e = create_entry
    get "/entries/#{group.name}/errors"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Home/)
  end

  it "paginates entries" do
    e = create_entry
    get "/entries/#{group.name}"
    expect(last_response).to be_redirect
  end

  it "requires basic auth" do
    test_env = ENV["RACK_ENV"]
    ENV["RACK_ENV"] = "production"
    get "/"
    expect(last_response).to be_ok
    ENV["RACK_ENV"] = test_env
  end

  it "shows you entries" do
    55.times do
      e = create_entry
    end
    get "/entries/#{group.name}/1"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Home/)
  end

  it "searches tags" do
    e = create_entry
    get "/search/#{group.name}/tags"
    expect(last_response).to be_ok
  end

  it "searches groups" do
    e = create_entry
    get "/search/#{group.name}?q=ERROR"
    expect(last_response).to be_redirect
  end

  it "searches groups" do
    e = create_entry
    get "/search/#{group.name}?q=test"
    expect(last_response).to be_redirect
  end

  it "searches groups" do
    e = create_entry
    get "/search/#{group.name}/1?q=test"
    expect(last_response).to be_ok 
    expect(last_response.body).to match(/Home/)
  end

  it "downloads searches" do
    e = create_entry
    get "/search/#{group.name}/1?q=ERROR&format=csv"
    expect(last_response).to be_ok
  end

  it "searches groups" do
    e = create_entry
    get "/search/#{group.name}/1?q=ERROR"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Home/)
  end

  it "shows you tags" do
    e = create_entry
    get "/entries/#{group.name}/tag/ERROR"
    expect(last_response).to be_redirect
  end

  it "shows you tags" do
    e = create_entry
    get "/entries/#{group.name}/tag/ERROR/1"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Home/)
  end

  it "takes posted entries" do
    post "/entries/#{group.name}", json
    expect(last_response).to be_ok
  end
    
end
