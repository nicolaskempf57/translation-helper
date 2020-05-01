defmodule Extractor do

  @moduledoc """
  Module extracting all `Translation` values to a List
  """

  @doc """
  Extract `Translation` from Map, extracted data will be a list of `Translation`

  ## Examples

  First level value are converted to `Translation`

      iex> Extractor.extract(%{"create" => "Créer", "next" =>"Suivant"})
      [%Translation{from: "Créer", key: "create", to: ""}, %Translation{from: "Suivant", key: "next", to: ""}]

  Others levels are flatten, the result key is prefixed with their top level key and converted to `Translation`

      iex> Extractor.extract(%{"top" => %{"create" => "Créer", "next" =>"Suivant"}})
      [%Translation{from: "Créer", key: "top.create", to: ""}, %Translation{from: "Suivant", key: "top.next", to: ""}]


  """
  @spec extract(map()) :: [Translation.t()]
  def extract(map) when is_map(map), do: Enum.flat_map(map, &extractData/1)

  # Extract list of `Translation` struct from a single Map entry
  defp extractData({key, value}) when is_binary(value), do: [%Translation{key: key, from: value, to: ""}]
  defp extractData({key, value}) when is_map(value) do
    Enum.map(value, fn {k, v} -> {"#{key}.#{k}", v} end)
    |> Enum.flat_map(&extractData/1)
  end
end
