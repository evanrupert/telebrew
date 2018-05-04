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
  api_key: <Your Api Key>
```

#### Other optional configuration settings
- `timeout_interval`: (Integer) Amount of time in milliseconds to wait after network timeout before trying again, defaults to 200
- `long_polling_timeout`: (Integer) Amount of time to wait for long polling response before resending a request, defaults to 10_000
- `quiet`: (Boolean) Weather or not to print message logs

## Usage

In order to use telebrew you must use it in your module like this:
```elixir
defmodule YourModule do
  use Telebrew

  # Your listeners
end
```

Listeners are defined using the `on` macro and take a string, a list of strings, or a sigil and then a do block.

```elixir
# prints world whenever /hello or /h is sent to your bot
on ["/h", "/hello"] do
  IO.puts "world"
end

# Or

# Same but using the string list sigil
on ~w(/h /hello) do
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

The `respond` macro will automatically send a message to the chat that sent the last message

```elixir
# Same as above example
on "/echo" do
  respond m.text
end
```

### Shared state

State can be shared between listeners by defining the @state attribute in your module
then accessing the state variable in your listeners.  State is unique to each chat.
**Whatever is returned from the listener will become the new state**

```elixir
defmodule YourModule do
  use Telebrew

  # set initial state to 0
  @state 0

  # send the state to the user
  on "/get" do
    respond state

    # Always return state even if it is not changed
    state
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

Events are strings not prefixed with `"/"` and represent predefined types of messages that can be received.  For example:

Valid: `"photo"`, `"document"`, `"video_note"`

Invalid: `"has spaces"`, `"not_defined"`, `"/command"`

```elixir
# called anytime a message is received with a photo
on "photo" do
  respond "You sent a photo"
end

# on a location message send the latitude and longitude
on "location" do
  respond "You are at: (#{m.location.latitude}, #{m.location.longitude})"
end
```

The full list of events can be found in the Telebrew.on documentation
