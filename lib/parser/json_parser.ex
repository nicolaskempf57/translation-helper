defmodule JsonParser do
  @moduledoc """
  Module implementing Parser behaviour for JSON file
  """
  @behaviour Parser

  @impl Parser
  @spec parse(String.t()) :: {:error, String.t()} | {:ok, term}
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
  @spec encode(any, binary) :: {:error, <<_::120>>}
  def encode(_, filename) when is_binary(filename) do
    {:error, "Not implemented"}
  end
end
