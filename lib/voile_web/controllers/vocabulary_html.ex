defmodule VoileWeb.VocabularyHTML do
  use VoileWeb, :html

  embed_templates "vocabulary_html/*"

  @doc """
  Renders a vocabulary form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def vocabulary_form(assigns)
end
