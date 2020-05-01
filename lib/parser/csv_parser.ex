defmodule CsvParser do
@moduledoc """
Module implementing Parser behaviour for CSV file
"""
  @behaviour Parser

  @spec parse(any) :: {:error, <<_::120>>}
  def parse(_filename) do
    {:error, "Not implemented"}
  end

  @doc """
  Encode data and save it to file with given filename
  """
  @spec encode(list(map), binary) :: {:error, binary} | {:ok, binary}
  def encode([%{} | _tail] = data, filename) when is_binary(filename) do
    Path.rootname(filename, ".json")
    |> Kernel.<>(".csv")
    |> File.open([:utf8, :write])
    |> case do
      {:ok, file} -> data
        |> CSV.encode(separator: ?;, headers: ["key", "from", "to"])
        |> Enum.each(fn row -> IO.write(file, row) end)
        {:ok, filename}
      {:error, reason} -> {:error, to_string(:file.format_error(reason))}
    end

  end
end
