defmodule Telebrew do
@moduledoc """
  Contains all macros for defining message event listeners
  """
  @reserved_events [:text, :default, :photo, :sticker, :audio, 
                    :document, :video]
  @default_message_name :m

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      import Telebrew.Methods

      Module.register_attribute(__MODULE__, :events, accumulate: true)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def start do
        IO.puts "\n================="
        IO.puts "Starting Listener"
        IO.puts "=================\n"
        
        {:ok, listener_pid} = GenServer.start_link(Telebrew.Listener, {__MODULE__, @events})

        Task.start(Telebrew.Polling, :run, [listener_pid])
      end
    end
  end

  @doc """
  Main macro used for defining event listeners.
  The first argument is a string that defines what commmand or event will invoke this macro.  The default message variable is m 
  meaning that one only needs to use m as the received messageCommands are 
  prefixed by '/'.  Events have no prefix and have to be one of the reserved predefined events.

  ## Events ##

  - `text`: Will match on any text without a command
  - `default`: Will match any command that is not previously defined
  - `photo`: Will match any photo
  - `sticker`: Will match any sticker
  - `audio`: Will match any audio file
  - `video`: Will match any video file
  - `document`: Will match any other type of file

  ## Examples ##
      # will be called on any message prefixed by '/test'
      on "/test" do
        send_message m.chat.id, "Hello"
      end

      # will be called on any message without a command
      on "text" do
        send_message m.chat.id, "You said: \#{m.text}"
      end
  """
  defmacro on(match, options \\ [], _do = [do: do_block]) do
    as = Keyword.get(options, :as, @default_message_name)
    when_block = Keyword.get(options, :when, true)

    add_function(match, {as, [], Elixir}, when_block, do_block)
  end

  defp add_function(match, message_alias, when_block, do_block) do
    match_atom = String.to_atom(match)

    quote do
      # raise error if listener match is empty
      if unquote(match) == "" do
        raise Telebrew.ListenerError,
          message: "Event Listener: \'#{unquote(match)}\' cannot be empty"
      end

      # raise error if listener has already been defined
      if unquote(match_atom) in @events do
        raise Telebrew.ListenerError,
          message: "Event Listener: \'#{unquote(match)}\' is alread defined"
      end

      # raise error if match is not a valid event and does not start with /
      if not String.starts_with?(unquote(match), "/") and
           unquote(match_atom) not in unquote(@reserved_events) do
        msg =
          "Event Listener: \'#{unquote(match)}\' is not a valid command or event. Perhaps you ment \'/#{
            unquote(match)
          }\'"

        raise Telebrew.ListenerError, message: msg
      end

      # raise error if match has a space in it
      if String.contains?(unquote(match), [" "]) do
        raise Telebrew.ListenerError,
          message:
            "Event Listener: \'#{unquote(match)}\' should be a single event or command (no spaces allowed)"
      end

      @events unquote(match_atom)

      def unquote(match_atom)(message) do
        var!(unquote(message_alias)) = message

        if unquote(when_block) do
          unquote(do_block)
        end
      end
    end
  end
end
