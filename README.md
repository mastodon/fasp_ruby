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

## Contributing

See https://github.com/mastodon/.github/blob/main/CONTRIBUTING.md

## License

The code in this repository is available as open source under the terms
of the [MIT License](https://opensource.org/licenses/MIT).
