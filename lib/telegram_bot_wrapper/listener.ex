defmodule TelegramBotWrapper.Listener do
  @moduledoc """
  Contains all macros for defining message event listeners
  """
  @reserved_events [:text, :default]
  @default_message_name :m

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      import TelegramBotWrapper.Methods

      Module.register_attribute __MODULE__, :events, accumulate: true
      @before_compile unquote(__MODULE__)
    end
  end

  
  defmacro __before_compile__(_env) do
    quote do
      def start do
        TelegramBotWrapper.Polling.start(self(), __MODULE__, @events)
      end
    end
  end

  @doc """
  Same as `on/2` but allows the user to define the name of the variable message
  
  ## Example ##
      on "/hello", as: :thing do
        send_message(thing.chat.id, "Hello")
      end
  """
  defmacro on(match, _as = [as: name], _do = [do: block]), do: add_function(String.to_atom(match), {name, [], Elixir}, block)

  @doc """
  Main macro used for defining event listeners.
  The first argument is a string that defines what commmand or event will invoke this macro.  The default message variable is m 
  meaning that one only needs to use m as the received messageCommands are 
  prefixed by '/'.  Events have no prefix and have to be one of the reserved predefined events.

  ## Events ##
  | Name    | Effect                                                | 
  | ----    | ------                                                |
  | text    | Will match on any text without a command              |
  | default | Will match any command that is not previously defined |

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
  defmacro on(match, _do = [do: block]), do: add_function(String.to_atom(match), {@default_message_name, [], Elixir}, block)
  

  defp add_function(match_atom, message_alias, do_block) do
    quote do
      match_string = to_string(unquote(match_atom))
      # raise error if listener match is empty
      if match_string == "" do
        raise TelegramBotWrapper.ListenerError, message: "Event Listener: \'#{match_string}\' cannot be empty"
      end
      # raise error if listener has already been defined
      if unquote(match_atom) in @events do
        raise TelegramBotWrapper.ListenerError, message: "Event Listener: \'#{match_string}\' is alread defined"
      end
      # raise error if match is not a valid event and does not start with /
      if (not String.starts_with?(match_string, "/")) and (not unquote(match_atom) in unquote(@reserved_events)) do
        msg = "Event Listener: \'#{match_string}\' is not a valid command or event. Perhaps you ment \'/#{match_string}\'"
        raise TelegramBotWrapper.ListenerError, message: msg
      end
      # raise error if match has a space in it
      if String.contains?(match_string, [" "]) do
        raise TelegramBotWrapper.ListenerError, message: "Event Listener: \'#{match_string}\' should be a single event or command (no spaces allowed)"
      end

      @events unquote(match_atom)

      def unquote(match_atom)(message) do
        var!(unquote(message_alias)) = message
        unquote(do_block)
      end
    end
  end

  
end