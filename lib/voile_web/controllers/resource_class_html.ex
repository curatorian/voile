defmodule VoileWeb.ResourceClassHTML do
  use VoileWeb, :html

  embed_templates "resource_class_html/*"

  @doc """
  Renders a resource_class form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def resource_class_form(assigns)
end
