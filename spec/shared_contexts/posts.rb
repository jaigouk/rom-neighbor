# frozen_string_literal: true

require 'rom-sql'

RSpec.shared_context "posts" do
  before do
    conn.create_table :posts do
      primary_key :id
      foreign_key :author_id, :users
      String :title
      String :body
    end

    conf.relation(:posts) do
      schema(:posts, infer: true)
    end
  end

  before do |example|
    next if example.metadata[:seeds] == false

    conn[:posts].insert(
      id: 1,
      author_id: 2,
      title: "Joe's post",
      body: "Joe wrote something"
    )

    conn[:posts].insert(
      id: 2,
      author_id: 1,
      title: "Jane's post",
      body: "Jane wrote something"
    )
  end
end
