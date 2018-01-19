defmodule Telebrew.HTTP do
  @moduledoc """
  Module for low-level http requests to the telegram bot api
  """

  @url_base "https://api.telegram.org/bot"

  @file_base "https://api.telegram.org/file/bot"

  @doc """
  Sends a post request but dosn't check for errors, or encode the result into elixir
  """
  @spec raw_request(binary, any) :: any
  def raw_request(method, body) do
    # get api key
    api_key = Application.get_env(:telebrew, :api_key)

    # check if api key is valid
    unless api_key do
      raise Telebrew.SyntaxError, message: "Api key is not configured"
    end

    json_body = Poison.encode!(body)

    headers = [{"Content-type", "application/json"}]

    # post method and get response
    HTTPoison.post("#{@url_base}#{api_key}/#{method}", json_body, headers)
  end

  def http_download_file(file_source, destination) do
    api_key = Application.get_env(:telebrew, :api_key)

    unless api_key do
      raise Telebrew.SyntaxError, message: "Api key is not configured"
    end

    resp = HTTPoison.get("#{@file_base}#{api_key}/#{file_source}")

    path = Path.join(destination, Path.basename(file_source))

    case resp do
      {:ok, %{body: body}} ->
        case Poison.decode(body) do
          {:error, _} ->
            case File.open(path, [:write]) do
              {:ok, file} ->
                IO.write(file, body)

              x ->
                x
            end

          {:ok, %{"ok" => false, "reason" => reason}} ->
            {:error, reason}
        end

      {:error, reason} ->
        {:error, reason.message}
    end
  end

  @doc """
  Basic function to send a post request to the telegram bot api where the method is a string of the method name and
  the body is a map of all of the parameters

  Returns either `{ :ok, result }` or `{ :error, reason }`
  """
  @spec request(binary, any) :: {:ok, any} | {:error, %{error_code: any, description: binary}}
  def request(method, body) do
    response = raw_request(method, body)

    # check for errors
    case response do
      {:ok, resp} ->
        case Poison.decode!(resp.body) do
          %{"ok" => true, "result" => result} ->
            {:ok, strings_to_atoms(result)}

          %{"ok" => false, "error_code" => code, "description" => des} ->
            {:error, %{error_code: code, description: des}}
        end

      x ->
        x
    end
  end

  @doc """
  Same as `request/2` but will throw `Telebrew.Error` on failure
  """
  @spec request!(binary, any) :: any
  def request!(method, body) do
    case request(method, body) do
      {:ok, result} ->
        result

      {:error, %{id: id, reason: reason}} ->
        raise Telebrew.Error, message: reason, error_code: id

      {:error, %{error_code: code, description: des}} ->
        raise Telebrew.Error, message: des, error_code: code
    end
  end

  defp strings_to_atoms(list) when is_list(list), do: for(i <- list, do: strings_to_atoms(i))

  defp strings_to_atoms(resp) when not is_map(resp), do: resp

  defp strings_to_atoms(map) do
    for {key, val} <- map, into: %{} do
      case val do
        list when is_list(list) ->
          {String.to_atom(key), strings_to_atoms(list)}

        map when is_map(map) ->
          {String.to_atom(key), strings_to_atoms(map)}

        x ->
          {String.to_atom(key), x}
      end
    end
  end
end
