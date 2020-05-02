defmodule JsonFormatter do
  @moduledoc """
  Module to format `Translation` list to Map with String keys
  """

  @behaviour Formatter

  @doc """
  Format `Translation` to Map and split key

      iex> JsonFormatter.format(%Translation{from: "Créer", key: "top.create", to: "Create"})
      %{"top" => %{"create" => "Create"}}

  Works with List of `Translation` too

      iex> JsonFormatter.format([%Translation{from: "Créer", key: "top.create", to: "Create"}, %Translation{from: "Suivant", key: "top.next", to: "Next"}])
      %{"top" => %{"create" => "Create", "next" => "Next"}}

      iex> JsonFormatter.format([%Translation{from: "Créer", key: "top.second.create", to: "Create"}, %Translation{from: "Suivant", key: "top.next", to: "Next"}])
      %{"top" => %{"second" => %{"create" => "Create"}, "next" => "Next"}}
  """
  @spec format(list(Translation.t) | Translation.t) :: map
  def format([%Translation{} | _tail] = translations) do
    Enum.reduce(translations, %{}, fn translation, map -> Map.merge(map, format(translation), &merge/3) end)
  end

  def format(%Translation{key: key, to: to}) do
    String.split(key, ".")
    |> Enum.reverse()
    |> Enum.reduce(to, fn current_key, map -> %{current_key => map} end)
  end

  @spec merge(String.t, map, map) :: %{String.t => map}
  def merge(key, %{} = map1, %{} = map2) when is_binary(key) do
    Map.merge(map1, map2, &merge/3)
  end

end
