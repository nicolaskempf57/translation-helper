defmodule TranslationHandler do
  @moduledoc """
  Module taking JSON string with translations and converting it to CSV
  """
  @spec main([binary]) :: [binary()] | {:error, binary}
  def main(args) do
    IO.puts "Parsing arguments"
    {[file: file_path], _, _} = OptionParser.parse(args, strict: [file: :string])
    IO.puts "Reading and converting file #{file_path}"
    convert(file_path)
  end

  @doc """
  Convert JSON string to Map and format it to CSV
  """
  @spec convert(String.t() | any()) :: [binary()] | {:error, String.t()}
  def convert(filename) when is_binary(filename) do
    case Path.extname(filename) do
      ".json" -> parse_json(filename)
      ".csv" -> parse_csv(filename)
    end
  end
  def convert(_), do: {:error, "JSON String is required"}

  defp print_result({:ok, _} = result) do
    IO.puts("File parsed and translations extracted")
    result
  end
  defp print_result({:error, reason} = result) do
    IO.warn(reason)
    result
  end

  defp parse_json(file) do
    JsonParser.parse(file)
    |> extract
    |> format_for_csv
    |> encode(file)
    |> print_result
  end

  defp parse_csv(file) do
    CsvParser.parse(file)
    |> extract
    |> format_for_json
    |> encode(file)
    |> print_result
  end

  defp extract({:ok, map}), do: {:ok, Extractor.extract(map)}
  defp extract({:error, _} = error), do: error

  defp encode({:ok, list}, filename) when is_list(list), do: {:ok, CsvParser.encode(list, filename)}
  defp encode({:ok, %{} = map}, filename), do: {:ok, JsonParser.encode(map, filename)}
  defp encode({:error, _} = error, _), do: error

  defp format_for_csv({:ok, list}) when is_list(list), do: {:ok, CsvFormatter.format(list)}
  defp format_for_csv({:error, _} = error), do: error

  defp format_for_json({:ok, list})when is_list(list), do: {:ok, JsonFormatter.format(list)}
  defp format_for_json({:error, _} = error), do: error
end
