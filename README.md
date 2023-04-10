# Rom::Neighbor

[![Gem Version](https://badge.fury.io/rb/rom-neighbor.svg)](https://badge.fury.io/rb/rom-neighbor)
[![Ruby](https://github.com/jaigouk/rom-neighbor/actions/workflows/main.yml/badge.svg)](https://github.com/jaigouk/rom-neighbor/actions/workflows/main.yml)

**THIS GEM IS UNDER DEVELOPMENT. DO NOT USE IT IN PRODUCTION.**

this gem is a port of [neighbor gem](https://github.com/ankane/neighbor) for rom-rb.

## Installation

Neighbor supports two extensions: [cube](https://www.postgresql.org/docs/current/cube.html) and [vector](https://github.com/pgvector/pgvector). cube ships with Postgres, while vector supports approximate nearest neighbor search.


You need to install pg_cube and pg_vector extensions

```sh
bundle exec rake 'db:create_migration[create_cube_extension]'
# add the following to the migration
CREATE EXTENSION cube;
```

For vector, [install pgvector](https://github.com/pgvector/pgvector#installation) and run:

```sh
cd /tmp
git clone --branch v0.4.1 https://github.com/pgvector/pgvector.git
cd pgvector
make
make install # may need sudo
```

on macos,

```
brew install pgvector
```

Add this line to your application’s Gemfile:

```ruby
gem "rom-neighbor"
```

In config/initializers/rom.rb (or wherever you configure rom)

```ruby
require 'rom/neighbor'
```

and then run migration to add extensions

```sh
bundle install

bundle exec rake db:rom_neighbor_for[cube, items]
# or
bundle exec rake db:rom_neighbor_for[vector, items]
```

it will create a migration file like this

```ruby
# frozen_string_literal: true

ROM::SQL.migration do
  up do
    alter_table :items do
      add_column :embedding, :cube
      # or
      # add_column :embedding, :vector, limit: 3 # dimensions
    end
  end

  down do
    alter_table :items do
      drop_column :embedding
    end
  end
end
```

it will create or update entity file like this

```ruby
# frozen_string_literal: true

module MyProject
  module Entities
    class Item < ROM::Struct
      # attribute :id, Types::Int
      # attribute :embedding, Types::PG::Cube
      # or
      # attribute :embedding, Types::PG::Vector
    end
  end
end
```

it will create or update relation file like this

```ruby
# frozen_string_literal: true

module MyProject
  module Relations
    class Items < ROM::Relation[:sql]
      schema(:items, infer: true) do
        attribute :embedding, Types::PG::Cube
        # or
        # attribute :embedding, Types::PG::Vector
      end
    end
  end
end
```

it will create or update repository file like this

```ruby
# frozen_string_literal: true

module MyProject
  module Repositories
      # include Neighbor::Repository will add the following methods to the repository
      #
      # def nearest_neighbors(column, vector = nil, distance: "euclidean")
      #   if vector
      #     items.where { |r| r.send(column).nearest_neighbors(vector, distance: distance) }
      #   else
      #     items.where { |r| r.send(column).nearest_neighbors(distance: distance) }
      #   end
      # end
    class ItemsRepository < ROM::Repository[:items]
      include Neighbor::Repository
    end
  end
end
```

## Usage


relation

```ruby
class Iteam < ROM::Relation[:sql]
  schema do
    attribute :id, Types::Serial
    attribute :embedding, Types::PG::Cube
    # or
    attribute :embedding, Types::PG::Vector
  end
end

```

repository

```ruby
item_repository = MyProject::App.container['repositories.item']
item_repository.update(embedding: [1.0, 1.2, 0.5])
```

Get the nearest neighbors to a record

```ruby
item_repository = MyProject::App.container['repositories.item']
item_repository.nearest_neighbors(:embedding, distance: "euclidean").first(5)
```

Get the nearest neighbors to a vector

```ruby
item_repository = MyProject::App.container['repositories.item']
item_repository.nearest_neighbors(:embedding, [0.9, 1.3, 1.1], distance: "euclidean").first(5)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jaigouk/rom-neighbor.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
