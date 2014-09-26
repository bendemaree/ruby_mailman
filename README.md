# Ruby Mailman

- A ruby library for interacting with Central Service
  - Sending Messages
  - Subscribing to Channels
  - Follows the spec outlined in https://github.umn.edu/umnapi/services_interface

## Sending Messages

Central Services will expect objects to be serialized [protobuf objects](https://github.umn.edu/umnapi/protobufs). If you send other types of objects in your messages it probably will not work.

```ruby
module Interfaces
  class Auth < ::Protobuf::Message
    defined_in __FILE__
    optional :string, :email, 2
    optional :string, :public_key, 3
    optional :string, :private_key, 4
  end
end

auth = Interfaces::Auth.new
message = auth.serialize_to_string

RubyMailman::Mailman.send(:create, message)
RubyMailman::Mailman.send(:update, message)
RubyMailman::Mailman.send(:destroy, message)

RubyMailman::Mailman.create(message)
RubyMailman::Mailman.update(message)
RubyMailman::Mailman.destroy(message)
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


RubyMailman::Subscription.subscribe(channel: :key, listener: MyListener.new)
#=> true
```

#### Listener Lambda

Since lambdas respond to `call`, you can do

```ruby
my_listener = lambda{ |channel, message| #your code }
RubyMailman::Subscription.subscribe(channel: :key, listener: my_listener)
#=> true
```

### Subscription Messages

Your listener will receive `call` with  the channel and the message. The message is an instance of RubyMailman::Subscription::Message and responds to:

- channel: the channel again
- action: `create`, `update` or `destroy`
- content: A serialized protobuff object

This is a very specific message, since it's really only designed to do one thing -- tell your service about new/changed/destroyed objects. Let's look at an example of a service that care about Auth objects, and it locally persists those Auth objects as LocalAuth:

```ruby
class AuthListener
  def call(channel, message)
    a = Interfaces::Auth.new
    a.parse_from_string(message.content)

    AuthLogger.new("Message received on #{message.channel} telling me to #{message.action} the object #{a.to_s}")

    case message.action
    when 'create'
      LocalAuth.new(a).save #We'll leave the implementation of LocalAuth to your imagination.
    when 'update'
      LocalAuth.replace(a).save
    when 'destroy'
      LocalAuth.destroy(a).save
    else
      raise ArgumentError
    end
  end
end

RubyMailman::Subscription.new(channel: Auth, listener: AuthListener.new)
```

## Setup

- Add `gem ruby_mailman` to your service
- `bundle install`

## Development

To work on the gem:

- Clone this repo
- run `bundle install --path ./vendor/bundle`
- run `bundle exec rake setup_development`
- run `bundle exec rake` to run all the tests and make sure all is well
