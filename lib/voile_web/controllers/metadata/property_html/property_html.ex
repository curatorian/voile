defmodule VoileWeb.PropertyHTML do
  use VoileWeb, :html

  embed_templates "*"

  @doc """
  Renders a property form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :vocabulary_list, :list
  attr :action, :string, required: true

  def property_form(assigns)
end
