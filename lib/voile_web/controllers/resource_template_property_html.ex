defmodule VoileWeb.ResourceTemplatePropertyHTML do
  use VoileWeb, :html

  embed_templates "resource_template_property_html/*"

  @doc """
  Renders a resource_template_property form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def resource_template_property_form(assigns)
end
