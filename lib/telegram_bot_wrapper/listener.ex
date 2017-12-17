defmodule TelegramBotWrapper.Listener do
  
  @reserved_matches [:text, :default]
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


  defmacro on(match, [as: name], [do: block]), do: add_function(String.to_atom(match), {name, [], Elixir}, block)

  defmacro on(match, do: block), do: add_function(String.to_atom(match), {@default_message_name, [], Elixir}, block)
  

  defp add_function(match_atom, message_alias, do_block) do
    quote do
      @events unquote(match_atom)
      def unquote(match_atom)(message) do
        var!(unquote(message_alias)) = message
        unquote(do_block)
      end
    end
  end
  
end