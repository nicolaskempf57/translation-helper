defmodule JsonParser do
  @moduledoc """
  Module implementing Parser behaviour for JSON file
  """
  @behaviour Parser

  @impl Parser
  @spec parse(String.t) :: {:ok, map} | {:error, String.t}
  def parse(filename) when is_binary(filename) do
    case File.read(filename) do
      {:ok, file_content} -> parse_json(file_content)
      {:error, error} -> {:error, to_string(:file.format_error(error))}
    end
  end

  defp parse_json(content) when is_binary(content) do
    case Jason.decode(content) do
      {:ok, _} = valid -> valid
      {:error, reason} -> {:error, Jason.DecodeError.message(Map.from_struct(reason))}
    end
  end

  @impl Parser
  @spec encode(map, binary) :: {:ok, binary} | {:error, binary}
  def encode(%{} = data, filename) when is_binary(filename) do
    Path.rootname(filename, ".csv")
    |> Kernel.<>(".json")
    |> File.open([:utf8, :write])
    |> case do
      {:ok, file} -> data
        |> Jason.encode([escape: :json, maps: :strict, pretty: true])
        |> case do
          {:ok, json} -> {IO.write(file, json), filename}
          {:error, %Jason.EncodeError{message: message}} -> {:error, message}
        end
      {:error, reason} -> {:error, to_string(:file.format_error(reason))}
    end
  end
end
