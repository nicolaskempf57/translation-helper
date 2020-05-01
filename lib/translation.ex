defmodule Translation do
  @moduledoc """
   `%Translation{}` is a struct holding informations for a single translation with :
  - a translation `key` used to reference this particular translation
  - a `from` translation to show translator what they have to work on
  - a `to` translation to build the translation file for the system (app, server, etc.)
  """

  @typedoc """
  A Translation struct
  """
  @type t :: %__MODULE__{key: String, from: String, to: String}
  @enforce_keys [:key, :from, :to]
  defstruct [:key, :from, :to]
end
