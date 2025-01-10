# Ruby FASP SDK 

A set of rails engines and a sample debug provider to facilitate
development of Fediverse Auxiliary Service Providers (FASP).

## Contents

* [`fasp_base`](fasp_base/)
  A rails engine with the basics of provider-server interactions
  (registration, provider info, API authentication). Includes a simple
  server-rendered HTML frontend, but could be used headless as well.
* [`fasp_data_sharing`](fasp_data_sharing/)
  A rails engine implementing most of the `data_sharing` discovery
  capability. Can be dropped into any FASP, which will only need to
  trigger subscriptions/backfill requests and implement background jobs
  to handle the URIs it receives. Also includes code to perform an
  "authorized fetch" of fediverse resources.
* [`debug`](debug/)
  A sample debug provider that utilizes both engines above to provide
  the `debug` capability and experiment with `data_sharing`.

## Quickstart

This repository contains a rails application template to get you up and
running quickly. To start a new FASP project, run:

```sh
rails new my_fasp -m https://raw.githubusercontent.com/mastodon/fasp_ruby/refs/heads/main/template.rb --css tailwind
```

> [!NOTE]
> You can add any additional command line options that `rails new`
> recognizes, e.g. `-d` to select a database system.
> Using tailwind is not strictly needed, but `fasp_base` will try to
> install an application layout that expects it. You can simply decline
> this step.

The application template will install the `fasp_base` engine that
includes all the basics that are needed for every type of FASP. It will
ask if it should also install the `fasp_data_sharing` engine. This is
only needed for discovery FASP that want to implement the `data_sharing`
capability.

Once all the generators have finished this should leave you with a
working rails application. Just run `bin/dev` and have a look at
`http://localhost:3000`.

Possible next steps:

* Adjust the initializer in `config/initializers/fasp_base.rb`
* Customize the home page
* Customize the registration process
* Implement capabilities

## Contributing

See https://github.com/mastodon/.github/blob/main/CONTRIBUTING.md

## License

The code in this repository is available as open source under the terms
of the [MIT License](https://opensource.org/licenses/MIT).
