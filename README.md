# Telebrew

**STILL IN PROGRESS, DO NOT USE**

Telebrew is a super easy to use wrapper over the telegram bot api that makes it simple to write telegram bots.

## Installation 

Add Telebrew to your `mix.exs` dependencies:
```elixir
def deps do
  [{:telebrew, "~> 1.0"}]
end
```

Then, update your dependencies:
```bash
$ mix deps.get
```

## Configuration
In your configuration file add your api key and any other settings you wish to configure:
```elixir
config :telebrew,
  api_key: "<Your Api Key>"
```

#### Other optional configuration settings
- `polling_interval`: (Integer) Amount of time in milliseconds between polling for updates, defaults to 1000
- `timeout_interval`: (Integer) Amount of time in milliseconds to wait after network timeout before trying again, defaults to 200

## Usage
In order to use telebrew you must use it in a module like this:
```elixir
defmodule YourModule do
  use Telebrew

end
```

Listeners are defined using the on macro and take a string or a list of strings and a do block.

```elixir
# prints world whenever /hello or /h is sent to your bot
on ["/h", "/hello"] do
  IO.puts "world"
end
```

The sent message is accessed by using the the m variable

```elixir
# whenever echo is called send the message back to the user
on "/echo" do
  send_message(m.chat.id, m.text)
end
```

### Shared state

State can be shared between listeners by defining the @state attribute in your module
then accessing the state variable in your listeners.  **Whatever is returned from the listener will become the new state**

```elixir
defmodule YourModule do
  use Telebrew

  # set initial state to 0
  @state 0

  # send the state to the user
  on "/get" do
    send_message m.chat.id, state

    state # Always return state even if it is not changed
  end

  # increment state by 1
  on "/increase" do
    state + 1
  end

  # decrement state by 1
  on "/decrease" do
    state - 1
  end

end
```

### Events and Commands

Listeners can be defined using Commands or Events

Commands are strings that are prefixed with the `"/"` character and can be anything but can't include spaces.

Valid: `"/hello"`, `"/test"`, `"/no_spaces"`

Invalid: `"/has spaces"`, `"no_slash"`

Events are strings not prefixed with "/" and represent predefined types of messages that can be received.  For example:

Valid: `"photo"`, `"document"`, `"video_note"`

Invalid: `"has spaces"`, `"not_defined"`, `"/command"`

```elixir
# called anytime a message is received with a photo
on "photo" do
  send_message m.chat.id, "You sent a photo"
end

# on a location message send the latitude and longitude
on "location" do
  send_message m.chat.id, "You are at: (#{m.location.latitude}, #{m.location.longitude})
end
```

The full list of events can be found in the Telebrew.on documentation
