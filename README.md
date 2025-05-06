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

It will try to overwrite `app/views/layout/application.html.erb` and
`app/assets/tailwind/application.css`. Confirm both unless you want to
start from scratch with you own markup and possibly CSS.

Once all the generators have finished this should leave you with a
working rails application. Just run `bin/dev` and have a look at
`http://localhost:3000`.

Possible next steps:

* Adjust the initializer in `config/initializers/fasp_base.rb`
* Customize the home page
* Customize the registration process
* Implement capabilities

## Configuration

The `fasp_base` engine can be configured via
`config/initializers/fasp_base.rb`. The values set here will be used in
the [provider info](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/general/v0.1/provider_info.md)
and in various other places, e.g. page titles.

The following can be configured:

* `fasp_name`: The name of your provider. Used for the provider info,
  page titles and name of AP actor, when data sharing is enabled
* `domain`: The domain name of your provider. Used to generate URIs
  outside of the regular rails request/response cycle. The default in
  the generated configuration allows using an environment variable for
  this in production and uses `localhost:3000` as a fallback for other
  environments
* `capabilities`: The list of capabilities your provider implements as
  returned in the provider info. Example capability:
  `{id: "callback", version: "0.1"}`
* `privacy_policy_url`: As returned in the provider info
* `privacy_policy_language`: As returned in the provider info
* `contact_email`: As returned in the provider info
* `fediverse_account`: As returned in the provider info

## User Interface

`fasp_base` installs an application layout and includes some basic views
e.g. for user/server registration. These use TailwindCSS utility classes
for styling.

You can decide to (re-)use this in which case you should set up your
project to use TailwindCSS (v3 only for now).

Of course you can also add your own CSS code to style the existing
views.

All existing views can also be overwritten in your project, so you have
total conrol over markup and styling.

Last but not least, all controllers in `fasp_base` also try to return
something sensible when a JSON content-type is request. That means that
as long as you are fine with a session-cookie based authentication, you
should be able to put a JS-based SPA in front of this using the
framework of your choice.

(Note that this last use-case has not been tested, but we are happy to
receive any feedback on this you might have.)

## Current Limitations

The data structure allows for a single user to have multiple servers.
This is on purpose and something we want to support ASAP. But right now
there is no UI to add additional servers and/or manage servers that you
already have.

If you take the current code as-is, your provider will have an open
registration, i.e. everyone can create an account and connect a server.
This is probably not what most providers will want.

Trouble is, there are many alternatives, and we are not yet sure which
make the most sense to have in such a generic base plugin.

Ideas include:

* Sign up with an invite code
* Sign up with one-time invitiation URLs
* Manual verification of sign ups by a (super-)admin (though this might
  require a spec change)

Feedback is very welcome.

## Implementing Capabilities

`fasp_base` requires your base URI to be at `/fasp/`. So when
implementing capabilities you will probably want to define your routes
under a `:fasp` namespace:

```ruby
namespace :fasp do
  # ...
end
```

In your controllers you can include the `FaspBase::ApiAuthentication`
module. This will automatically authenticate any requests and add a
`#current_server` and `#current_user` method to access the server that
was authenticated and the associated user respectively.

`#current_user` is also made available as a helper method to your views.

To make authenticated HTTP calls to a server, you can use the
`FaspBase::Request` class. Create a new instance by passing a
`FaspBase::Server` object:

```ruby
request = FaspBase::Request.new(current_server)
request.get("/capability/v23/test")
```

Note that the `#get`, `#post` and `#delete` methods will automatically
prepend the base URI of the server you can use path names as given in
the specification of the capability.

For test support, have a look at the
[IntegrationTestHelper](fasp_base/lib/fasp_base/integration_test_helper.rb)
and
[this example usage here](debug_fasp/test/integration/fasp/debug/v0/logs_test.rb).

## Contributing

See https://github.com/mastodon/.github/blob/main/CONTRIBUTING.md

## License

The code in this repository is available as open source under the terms
of the [MIT License](https://opensource.org/licenses/MIT).
