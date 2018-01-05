defmodule Telebrew do
@moduledoc """
  Contains all macros for defining message event listeners
  """
  @reserved_events [:text, :default, :photo, :sticker, :audio, 
                    :document, :video, :video_note, :voice,
                    :location]

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      import Telebrew.Methods

      # make events attribute to capture all of the listener functions
      Module.register_attribute(__MODULE__, :events, accumulate: true)
      # give init attribute a value of nil to avoid the '@init is not defined' warnings
      Module.put_attribute(__MODULE__, :init, nil)
      
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def start do
        IO.puts "\n================="
        IO.puts "Starting Listener"
        IO.puts "=================\n"

        state = @init

        {:ok, listener_pid} = GenServer.start_link(Telebrew.Listener, {__MODULE__, @events, state})

        Task.start(Telebrew.Polling, :run, [listener_pid])
      end
    end
  end

  @doc """
  Main macro used for defining event listeners.
  The first argument is a string that defines what commmand or event will invoke this macro.  The default message variable is m 
  meaning that one only needs to use m as the received message.  Commands are 
  prefixed by '/'.  Events have no prefix and have to be one of the reserved predefined events.

  ## Events ##

  - `text`: Will match on any text without a command
  - `default`: Will match any command that is not previously defined
  - `photo`: Will match any photo
  - `sticker`: Will match any sticker
  - `audio`: Will match any audio file
  - `voice`: Will match a sent voice message
  - `video`: Will match any video file
  - `video_note`: Will match a video note
  - `document`: Will match any other type of file
  - `location`: Will match any location message

  ## Examples ##
      # will be called on any message prefixed by '/test'
      on "/test" do
        send_message m.chat.id, "Hello"
      end

      # will be called on any video
      on "video" do
        send_message m.chat.id, "Received photo with id: \#{m.photo.file_id}"
      end
  """
  defmacro on(match, options \\ [], _do = [do: do_block]) do
    when_block = Keyword.get(options, :when, true)

    # if given match is a list create multiple identical functions with different names
    if is_list(match) do
      for m <- match do
        add_function(m, when_block, do_block)
      end
    else
      add_function(match, when_block, do_block)
    end
  end

  defp add_function(match, when_block, do_block) do
    match_atom = String.to_atom(match)

    quote do
      # raise error if listener match is empty
      if unquote(match) == "" do
        raise Telebrew.SyntaxError,
          message: "Event Listener: \'#{unquote(match)}\' cannot be empty"
      end

      # raise error if listener has already been defined
      if unquote(match_atom) in @events do
        raise Telebrew.SyntaxError,
          message: "Event Listener: \'#{unquote(match)}\' is alread defined"
      end

      # raise error if match is not a valid event and does not start with /
      if not String.starts_with?(unquote(match), "/") and
           unquote(match_atom) not in unquote(@reserved_events) do
        msg =
          "Event Listener: \'#{unquote(match)}\' is not a valid command or event. Perhaps you ment \'/#{
            unquote(match)
          }\'"

        raise Telebrew.SyntaxError, message: msg
      end

      # raise error if match has a space in it
      if String.contains?(unquote(match), [" "]) do
        raise Telebrew.SyntaxError,
          message:
            "Event Listener: \'#{unquote(match)}\' should be a single event or command (no spaces allowed)"
      end

      # add defined event to events list
      @events unquote(match_atom)

      # If init is defined, then define state in the macro therefore warning them if a listener does not use state
      if @init != nil do
        def unquote(match_atom)(message, state) do
          var!(m) = message
          var!(state) = state
  
          if unquote(when_block) do
            unquote(do_block)
          else
            state
          end
        end

      # if init is not defined, than do not define state preventing a bunch of warnings about state not being defined
      else
        def unquote(match_atom)(message, _state) do
          var!(m) = message

          if unquote(when_block) do
            unquote(do_block)
          end

          nil
        end
      end
    end
  end
end
