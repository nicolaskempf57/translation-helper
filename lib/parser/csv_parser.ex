defmodule CsvParser do
@moduledoc """
Module implementing Parser behaviour for CSV file
"""
  @behaviour Parser

  @headers ["key", "from", "to"]

  @impl Parser
  @spec parse(String.t) :: {:error, String.t} | {:ok, list(map)}
  def parse(filename) when is_binary(filename) do
    File.stream!(filename)
    |> CSV.decode([separator: ?;, headers: @headers])
    |> Enum.reduce({:ok, []}, &parse_csv/2)
  end

  @spec parse_csv({:error, String.t} | {:ok, map}, {:error, String.t} | {:ok, list(map)}) ::
          {:error, String.t} | {:ok, list(map)}
  def parse_csv({:ok, %{} = row}, {:ok, list}) when is_list(list), do: {:ok, [row | list]}
  def parse_csv({:error, reason}, {:ok, list}) when is_binary(reason) and is_list(list), do: {:error, reason}
  def parse_csv({:ok, %{}}, {:error, reason} = error) when is_binary(reason), do: error
  def parse_csv({:error, new_reason}, {:error, reason}) when is_binary(new_reason) and is_binary(reason), do: {:error, "#{reason}\n#{new_reason}"}

  @doc """
  Encode data and save it to file with given filename
  """
  @impl Parser
  @spec encode(list(map), binary) :: {:ok, binary} | {:error, binary}
  def encode([%{} | _tail] = data, filename) when is_binary(filename) do
    Path.rootname(filename, ".json")
    |> Kernel.<>(".csv")
    |> File.open([:utf8, :write])
    |> case do
      {:ok, file} -> data
        |> CSV.encode(separator: ?;, headers: @headers)
        |> Enum.each(fn row -> IO.write(file, row) end)
        {:ok, filename}
      {:error, reason} -> {:error, to_string(:file.format_error(reason))}
    end
  end
end
