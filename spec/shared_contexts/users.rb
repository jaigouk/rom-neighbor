# frozen_string_literal: true

RSpec.shared_context "users" do
  before do
    inferrable_relations.concat %i[users]
  end

  before do |_example|
    conn.create_table :users do
      primary_key :id
      String :name
      String :email
    end

    conf.relation(:users) { schema(infer: true) }
  end

  before do |example|
    next if example.metadata[:seeds] == false

    conn[:users].insert(
      id: 1,
      name: "John Doe",
      email: "john.doe@example.com"
    )

    conn[:users].insert(
      id: 2,
      name: "Jane Smith",
      email: "jane.smith@example.com"
    )
  end
end
