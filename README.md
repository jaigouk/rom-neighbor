# Rom::Neighbor

[![Gem Version](https://badge.fury.io/rb/rom-neighbor.svg)](https://badge.fury.io/rb/rom-neighbor)
[![Ruby](https://github.com/jaigouk/rom-neighbor/actions/workflows/main.yml/badge.svg)](https://github.com/jaigouk/rom-neighbor/actions/workflows/main.yml)

THIS GEM IS UNDER DEVELOPMENT. DO NOT USE IT IN PRODUCTION.

this gem is a port of [neighbor gem](https://github.com/ankane/neighbor) for rom-rb.

Neighbor supports two extensions: [cube](https://www.postgresql.org/docs/current/cube.html) and [vector](https://github.com/pgvector/pgvector). cube ships with Postgres, while vector supports approximate nearest neighbor search.

## Installation

Add this line to your application’s Gemfile:

```ruby
gem "rom-neighbor"
```

## Choose An Extension

Neighbor supports two extensions: [cube](https://www.postgresql.org/docs/current/cube.html) and [vector](https://github.com/pgvector/pgvector). cube ships with Postgres, while vector supports approximate nearest neighbor search.

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

bundle exec rake 'db:create_migration[create_vector_extension]'
# add the following to the migration
CREATE EXTENSION vector;
```

## Usage

TBD

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jaigouk/rom-neighbor.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
