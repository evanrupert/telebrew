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
    api_key = get_api_key_if_configured()

    json_body = Poison.encode!(body)

    headers = [{"Content-type", "application/json"}]

    # post method and get response
    HTTPoison.post("#{@url_base}#{api_key}/#{method}", json_body, headers)
  end

  @doc """
  Downloads a file by the file's id from the telegram servers
  """
  @spec http_download_file(binary, binary) :: :ok | {:error, any}
  def http_download_file(file_source, destination) do
    resp = make_file_get_request(file_source)

    destination_path = create_destination_path(file_source, destination)

    write_to_file_if_response_is_valid(resp, destination_path)
  end

  defp create_destination_path(file_source, destination) do
    Path.join(destination, Path.basename(file_source))
  end

  defp write_to_file_if_response_is_valid(resp, path) do
    with {:ok, %{body: body}} <- resp,
         {:error, _} <- Poison.decode(body) do
      write_to_file(path, body)
    else
      {:error, reason} ->
        {:error, reason.message}

      {:ok, %{"ok" => false, "reason" => reason}} ->
        {:error, reason}
    end
  end

  defp make_file_get_request(file_source) do
    api_key = get_api_key_if_configured()

    HTTPoison.get("#{@file_base}#{api_key}/#{file_source}")
  end

  defp get_api_key_if_configured do
    api_key = Application.get_env(:telebrew, :api_key)

    unless api_key do
      raise Telebrew.SyntaxError, message: "Api key is not configured"
    end

    api_key
  end

  defp write_to_file(path, body) do
    case File.open(path, [:write]) do
      {:ok, file} ->
        IO.write(file, body)
        :ok

      error ->
        error
    end
  end

  @doc """
  Basic function to send a post request to the telegram bot api where the method is a string of the method name and
  the body is a map of all of the parameters

  Returns either `{ :ok, result }` or `{ :error, reason }`
  """
  @spec request(binary, any) :: {:ok, any} | {:error, %{error_code: any, description: binary}}
  def request(method, body) do
    raw_response = raw_request(method, body)

    with {:ok, resp} <- raw_response,
         {:ok, decoded_resp} <- Poison.decode(resp.body),
         %{"ok" => true, "result" => result} <- decoded_resp do
      {:ok, string_map_to_atom_map(result)}
    else
      %{"ok" => false, "error_code" => code, "description" => description} ->
        {:error, %{error_code: code, description: description}}

      error ->
        error
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

  defp string_map_to_atom_map(list) when is_list(list), do: for(i <- list, do: string_map_to_atom_map(i))

  defp string_map_to_atom_map(resp) when not is_map(resp), do: resp

  defp string_map_to_atom_map(map) do
    for {key, val} <- map, into: %{} do
      {String.to_atom(key), string_map_to_atom_map(val)}
    end
  end

end
