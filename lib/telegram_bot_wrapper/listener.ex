defmodule TelegramBotWrapper.Listener do
  
  @reserved_matches [:text]

  defmacro __using__(_opts) do
    quote do
      import TelegramBotWrapper.Listener

      @matches []

    end
  end


  defmacro on(match_string, do: block) do
    IO.inspect block
    
    if String.starts_with?(match_string, "/") do
      match = String.to_atom(match_string <> "_cmd")

      quote do
        if unquote(match) in @matches do
          raise unquote(TelegramBotWrapper.ListenerError), message: "There is alread a listener for that command"
        else
          @matches [ {unquote(match), unquote(block) } | @matches]
        end
      end
    else
      match = String.to_atom(match_string)
      
      quote do
        if not unquote(match) in unquote(@reserved_matches) do
          raise unquote(TelegramBotWrapper.ListenerError), message: "That is not a valid event perhaps you ment /#{unquote(match)}"
        else 
          if unquote(match) in @matches do
            raise unquote(TelegramBotWrapper.ListenerError), message: "That event alread has a listener"
          else
            @matches [ {unquote(match), unquote(block) } | @matches]
          end
        end
      end
    end
  end


  defmacro __before_compile__(_env) do
    quote do
      def run do
        Enum.each @matches, fn m -> IO.puts m end
      end
    end
  end


  
end