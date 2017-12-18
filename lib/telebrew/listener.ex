defmodule Telebrew.Listener do
  @moduledoc """
  Contains all macros for defining message event listeners
  """
  @reserved_events [:text, :default, :photo, :sticker, :audio]
  @default_message_name :m

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      import Telebrew.Methods

      Module.register_attribute __MODULE__, :events, accumulate: true
      @before_compile unquote(__MODULE__)
    end
  end

  
  defmacro __before_compile__(_env) do
    quote do
      def start do
        Telebrew.Polling.start(self(), __MODULE__, @events)
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
        raise Telebrew.ListenerError, message: "Event Listener: \'#{match_string}\' cannot be empty"
      end
      # raise error if listener has already been defined
      if unquote(match_atom) in @events do
        raise Telebrew.ListenerError, message: "Event Listener: \'#{match_string}\' is alread defined"
      end
      # raise error if match is not a valid event and does not start with /
      if (not String.starts_with?(match_string, "/")) and (not unquote(match_atom) in unquote(@reserved_events)) do
        msg = "Event Listener: \'#{match_string}\' is not a valid command or event. Perhaps you ment \'/#{match_string}\'"
        raise Telebrew.ListenerError, message: msg
      end
      # raise error if match has a space in it
      if String.contains?(match_string, [" "]) do
        raise Telebrew.ListenerError, message: "Event Listener: \'#{match_string}\' should be a single event or command (no spaces allowed)"
      end

      @events unquote(match_atom)

      def unquote(match_atom)(message) do
        var!(unquote(message_alias)) = message
        unquote(do_block)
      end
    end
  end


  @doc """
  Recieves messages from polling and then calles the appropriate listener
  """
  def listen(module, events) do
    receive do
      { :update, message } ->
        IO.puts "Recieved Message: #{if Map.has_key?(message, :text) do message.text else "No Text" end}"

        cond do
          Map.has_key?(message, :text) and String.starts_with?(message.text, "/")
            -> handle_command(module, events, message)
          true
            -> handle_event(module, message)
        end
    end
    listen(module, events)
  end


  defp handle_command(module, events, message) do
    { cmd, msg } = split_message(message.text)
    # update text to remove command
    new_message = %{ message | text: msg }
    cmd_atom = String.to_atom(cmd)
    # find the event to call based on the command
    match = Enum.find(events, fn x -> x == cmd_atom end)
    
    cond do
      # if match exists call that function 
      match
        -> spawn(module, match, [new_message])
      # if no match exists call default function
      Keyword.has_key?(module.__info__(:functions), :default)
        -> spawn(module, :default, [new_message])
      # if no match and no default do nothing
      true
        -> nil
    end
  end


  defp handle_event(module, message) do
    cond do
      # message has photo and module has photo listener call photo listener
      Map.has_key?(message, :photo) and Keyword.has_key?(module.__info__(:functions), :photo)
        -> spawn(module, :photo, [message])
      # if message is sticker and module has sticker listener call sticker listener
      Map.has_key?(message, :sticker) and Keyword.has_key?(module.__info__(:functions), :sticker)
        -> spawn(module, :sticker, [message])
      # if message is audio and module has audio listener call audio listener
      Map.has_key?(message, :audio) and Keyword.has_key?(module.__info__(:functions), :audio)
        -> spawn(module, :audio, [message])
      # if message has text and text listener exists call text listener
      Map.has_key?(message, :text) and Keyword.has_key?(module.__info__(:functions), :text)
        -> spawn(module, :text, [message])
      # if none of the previous conditions then do nothing
      true
        -> nil
    end
  end


  defp split_message(message) do
    [fst|rest] = String.split(message, " ")
    { fst, Enum.join(rest, " ")}
  end

end