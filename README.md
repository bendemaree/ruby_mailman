# Ruby Mailman

- A ruby library for interacting with Central Service
  - Sending Messages
  - Subscribing to Channels
  - Follows the spec outlined in https://github.umn.edu/umnapi/services_interface

## Sending Messages

```ruby
class Key
end

k = Key.new
Mailman = RubyMailman::Mailman

Mailman.send(:create, k)
Mailman.send(:update, k)
Mailman.send(:destroy, k)

Mailman.create(k)
Mailman.update(k)
Mailman.destroy(k)

```

### Responses

Central Services has 3 types of response:
- success ('200')
- retry ('409')
- failure ('500')

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
#=> '200'
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
#=> '409'
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
#=> '500'
```

## Subscribing

You need to write some code that will handle the responses you'll get from subscription. There are a couple of ways to do this.

#### Listener Class

It just has to implement the `call` message with an arity of two. The channel will be the first parameter, the message will be the second. Do whatever you want within the method.

```ruby
class MyListener
  def call(channel, message)
    # your code to handle the new message
  end
end


RubyMailman::Subscription.subscribe(channel: :key, listener: MyListener.new, options: options)
#=> true
```

#### Listener Lambda

Since lambdas respond to `call`, you can do

```ruby
my_listener = lambda{ |channel, message| #your code }
RubyMailman::Subscription.subscribe(channel: :key, listener: my_listener, options: options)
#=> true
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
