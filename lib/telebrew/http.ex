defmodule Telebrew.HTTP do
  
  
  @moduledoc """
  Module for low-level http requests to the telegram bot api
  """

  @url_base "https://api.telegram.org/bot"
  @api_key Application.get_env(:telebrew, :api_key)


  @doc """
  Basic function to send a post request to the telegram bot api where the method is a string of the method name and
  the body is a map of all of the parameters

  Returns either `{ :ok, result }` or `{ :error, reason }`
  """
  def request(method, body) do
    json_body = Poison.encode! body

    headers = [{"Content-type", "application/json"}]

    response = HTTPoison.post "#{@url_base}#{@api_key}/#{method}", json_body, headers
    

    case response do
      { :ok, resp } -> 
        case Poison.decode! resp.body do
          %{"ok" => true, "result" => result } 
            -> { :ok, strings_to_atoms result }
          %{"ok" => false, "error_code" => code, "description" => des} 
            -> { :error, %{ error_code: code, description: des } }
        end
      x -> x  
    end
  end


  @doc """
  Same as `request/2` but will throw `Telebrew.Error` on failure
  """
  def request!(method, body) do
    case request(method, body) do
      { :ok, result } -> result
      { :error, %{ error_code: code, description: des } }
        -> raise Telebrew.Error, message: des, error_code: code
    end
  end


  defp strings_to_atoms(list) when is_list(list), do: for i <- list, do: strings_to_atoms(i)
  defp strings_to_atoms(map) do
    for {key, val} <- map, into: %{} do
      if is_map val do
        {String.to_atom(key), strings_to_atoms(val)}
      else
        {String.to_atom(key), val}
      end
    end
  end
end