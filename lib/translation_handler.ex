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

  ## Examples

  First level value are converted to `Translation`

      iex> TranslationHandler.convert(~S({"create": "Créer", "next": "Suivant"}))
      {:ok, [%Translation{from: "Créer", key: "create", to: ""}, %Translation{from: "Suivant", key: "next", to: ""}]}

  Others levels are flatten, the result key is prefixed with their top level key and converted to `Translation`

      iex> TranslationHandler.convert(~S({"top": {"create": "Créer", "next": "Suivant"}}))
      {:ok, [%Translation{from: "Créer", key: "top.create", to: ""}, %Translation{from: "Suivant", key: "top.next", to: ""}]}

  You must provide a `String.t()` for the function otherwise it'll return an error.

      iex> TranslationHandler.convert(22)
      {:error, "JSON String is required"}

  The parameter must be a JSON decodable String otherwise it'll return an error.

      iex> TranslationHandler.convert("invalid")
      {:error, %Jason.DecodeError{data: "invalid", position: 0, token: nil}}

  """
  @spec convert(String.t() | any()) :: [binary()] | {:error, String.t()}
  def convert(filename) when is_binary(filename) do
    JsonParser.parse(Path.expand(filename))
    |> extract
    |> format
    |> encode(filename)
    |> print_result
  end
  def convert(_), do: {:error, "JSON String is required"}

  defp print_result({:ok, _}), do: IO.puts("File parsed and translations extracted")
  defp print_result({:error, reason}), do: IO.warn(reason)

  defp extract({:ok, map}), do: {:ok, Extractor.extract(map)}
  defp extract({:error, _} = error), do: error

  defp encode({:ok, list}, filename), do: {:ok, CsvParser.encode(list, filename)}
  defp encode({:error, _} = error, _), do: error

  defp format({:ok, list}), do: {:ok, Formatter.format(list)}
  defp format({:error, _} = error), do: error
end
