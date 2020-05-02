defmodule CsvFormatter do
  @moduledoc """
  Module to format `Translation` list to Map list with String keys
  """

  @behaviour Formatter

  @doc """
  Format `Translation` to Map

      iex> CsvFormatter.format(%Translation{from: "Créer", key: "top.create", to: ""})
      %{"from" => "Créer", "key" => "top.create", "to" => ""}

  Works with List of `Translation` too

      iex> CsvFormatter.format([%Translation{from: "Créer", key: "top.create", to: ""}, %Translation{from: "Suivant", key: "top.next", to: ""}])
      [%{"from" => "Créer", "key" => "top.create", "to" => ""}, %{"from" => "Suivant", "key" => "top.next", "to" => ""}]

  """
  @spec format(list(Translation.t) | Translation.t) :: list(map) | Translation.t
  def format([%Translation{} = _ | _tail] = translations) do
    Enum.map(translations, &format/1)
  end
  def format(%Translation{} = translation) do
    Map.from_struct(translation)
    |> Map.new(fn {k, v} -> {Atom.to_string(k) , v} end)
  end
end
