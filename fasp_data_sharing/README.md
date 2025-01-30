# FaspDataSharing

This rails engine includes building blocks needed to implement
[FASP data sharing](https://github.com/mastodon/fediverse_auxiliary_service_provider_specifications/blob/main/discovery/data_sharing/v0.1/data_sharing.md).

It is based on `fasp_base`. See [the top-level README](../README.md) for
installation instructions.

This is not a complete solution to implement data sharing. At the very
least you will still need to implement how to deal with incoming data.

## Creating Subscriptions 

```ruby
FaspDataSharing::Subscription.subscribe_to_content(server, max_batch_size: 10)

FaspDataSharing::Subscription.subscribe_to_accounts(server, max_batch_size: 10)

FaspDataSharing::Subscription.subscribe_to_trends(server, max_batch_size: 10)
```

(`server` is an instance of `FaspBase::Server`.)

## Creating Backfill Requests

```ruby
FaspDataSharing::BackfillRequest.make(server, category: "content")
```

(Again, `server` is an instance of `FaspBase::Server`, `category` is one
of `"content"`, `"account"`.

## Handling Incoming Notifications

`fasp_data_sharing` expects that you handle incoming notifications from
connected fediverse servers asynchronously using `ActiveJob`.

To this end it defines the following jobs:

* `FaspDataSharing::ProcessAccountBackfillJob`
* `FaspDataSharing::ProcessAccountDeletionJob`
* `FaspDataSharing::ProcessAccountUpdateJob`
* `FaspDataSharing::ProcessContentBackfillJob`
* `FaspDataSharing::ProcessContentDeletionJob`
* `FaspDataSharing::ProcessContentUpdateJob`
* `FaspDataSharing::ProcessNewAccountJob`
* `FaspDataSharing::ProcessNewContentJob`
* `FaspDataSharing::ProcessTrendingContentJob`

Each job gets a single URI as its first and only parameter.

These classes are mostly empty. You need to overwrite them in your
provider.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
