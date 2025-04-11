defmodule VoileWeb.PropertyController do
  use VoileWeb, :controller

  alias Voile.Schema.Metadata
  alias Voile.Schema.Metadata.Property

  def index(conn, _params) do
    metadata_properties = Metadata.list_metadata_properties()
    render(conn, :index, metadata_properties: metadata_properties)
  end

  def new(conn, _params) do
    changeset = Metadata.change_property(%Property{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"property" => property_params}) do
    case Metadata.create_property(property_params) do
      {:ok, property} ->
        conn
        |> put_flash(:info, "Property created successfully.")
        |> redirect(to: ~p"/metadata_properties/#{property}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    property = Metadata.get_property!(id)
    render(conn, :show, property: property)
  end

  def edit(conn, %{"id" => id}) do
    property = Metadata.get_property!(id)
    changeset = Metadata.change_property(property)
    render(conn, :edit, property: property, changeset: changeset)
  end

  def update(conn, %{"id" => id, "property" => property_params}) do
    property = Metadata.get_property!(id)

    case Metadata.update_property(property, property_params) do
      {:ok, property} ->
        conn
        |> put_flash(:info, "Property updated successfully.")
        |> redirect(to: ~p"/metadata_properties/#{property}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, property: property, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    property = Metadata.get_property!(id)
    {:ok, _property} = Metadata.delete_property(property)

    conn
    |> put_flash(:info, "Property deleted successfully.")
    |> redirect(to: ~p"/metadata_properties")
  end
end
