# Ruby Mailman

- A ruby library for connecting to Central Service
- https://github.umn.edu/umnapi/services_interface

## Usage

```ruby
class Key
end

k = Key.new
Mailman = RubyMailman::Mailman

Mailman.send(:create, k)
Mailman.send(:update, k)
Mailman.send(:update, k)

Mailman.create(k)
Mailman.update(k)
Mailman.destroy(k)

Mailman.subscribe(channel: :key, history: :all)
```

### Responses

Central Services has 3 types of response:
- success ('OK')
- retry ('Retry')
- failure ('Fail')

#### Success

```ruby
response = Mailman.send(:create, obj)
response.success?
#=> true
response.retry?
#=> false
response.fail?
#=> false
response.body
#=> 'OK'
```

#### Retry

```ruby
response = Mailman.send(:create, obj)
response.success?
#=> false
response.retry?
#=> true
response.fail?
#=> false
response.body
#=> 'Retry'
```

#### Failure

```ruby
response = Mailman.send(:create, obj)
response.success?
#=> false
response.retry?
#=> false
response.fail?
#=> true
response.body
#=> 'Fail'
```

## Setup

- Add `gem ruby_mailman` to your service
- `bundle install`

It is expected that your service already has the compiled [protobuf objects](https://github.umn.edu/umnapi/protobufs). Mailman will only be able to work with these objects.

## Development

To work on the gem:

- Clone this repo
- run `bundle install --path ./vendor/bundle`
- run `bundle exec rake setup_development`
- run `bundle exec rake` to run all the tests and make sure all is well

