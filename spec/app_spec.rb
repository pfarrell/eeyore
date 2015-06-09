require 'spec_helper'
require 'byebug'

describe 'App' do

  let(:group) {Group.find_or_create(name: "test")}
  let(:error_tag) {Tag.find_or_create(group: group, tag:"ERROR")}
  let(:entry) {create_entry}
  let(:json) {{tags:["ERROR"], data: {test: "pat"}}.to_json}

  def create_entry
    e = Entry.find_or_create(group: group, date: DateTime.now)
    e.group = group
    e.add_tag error_tag
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

  it "shows you entries" do
    e = create_entry
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
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Home/)
  end

  it "searches groups" do
    e = create_entry
    get "/search/#{group.name}?q=test"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Home/)
  end

  it "shows you tags" do
    e = create_entry
    get "/entries/#{group.name}/tag/ERROR"
    expect(last_response).to be_ok
    expect(last_response.body).to match(/Home/)
  end

  it "takes posted entries" do
    post "/entries/#{group.name}", json
    expect(last_response).to be_ok
  end
    
end
