require 'spec_helper'

class Post
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Slug

  field :title
  slug  :title
end

describe "Mongoid paranoia with mongoid slug model" do
  let(:post) {Post.create!(title: "slug")}

  it "returns post for correct slug" do
    expect(Post.find(post.slug)).to eq(post)
  end

  it "raises for deleted slug" do
    post.delete
    expect{Post.find(post.slug)}.to raise_error(Mongoid::Errors::DocumentNotFound)
  end

  it "returns post for correct restored slug" do
    post.delete
    Post.deleted.first.restore
    expect(Post.find(post.slug)).to eq(post)
  end
end
