defmodule Formatter do
  @moduledoc """
  Define standard Formatter behaviour for our JSON and CSV formatters
  """

  @doc """
  Format a given list of `Translation` and return the formatted result
  """
  @callback format(list(Translation.t)) :: term
end
