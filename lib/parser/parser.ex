defmodule Parser do
  @moduledoc """
  Define standard Parser behaviour for our JSON and CSV parsers
  """

  @doc """
  Parse a given file and return the parsed result
  """
  @callback parse(String.t) :: {:ok, list | map} | {:error, String.t}

  @doc """
  Encode data and save it to file with given filename
  """
  @callback encode(map | list, String.t) :: {:ok, String.t} | {:error, String.t}
end
