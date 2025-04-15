defmodule VoileWeb.ResourceClassController do
  use VoileWeb, :controller

  alias Voile.Schema.Metadata
  alias Voile.Schema.Metadata.ResourceClass

  def index(conn, _params) do
    resource_class = Metadata.list_resource_class()
    render(conn, :index, resource_class_collection: resource_class)
  end

  def new(conn, _params) do
    changeset = Metadata.change_resource_class(%ResourceClass{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"resource_class" => resource_class_params}) do
    case Metadata.create_resource_class(resource_class_params) do
      {:ok, resource_class} ->
        conn
        |> put_flash(:info, "Resource class created successfully.")
        |> redirect(to: ~p"/resource_class/#{resource_class}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    resource_class = Metadata.get_resource_class!(id)
    render(conn, :show, resource_class: resource_class)
  end

  def edit(conn, %{"id" => id}) do
    resource_class = Metadata.get_resource_class!(id)
    changeset = Metadata.change_resource_class(resource_class)
    render(conn, :edit, resource_class: resource_class, changeset: changeset)
  end

  def update(conn, %{"id" => id, "resource_class" => resource_class_params}) do
    resource_class = Metadata.get_resource_class!(id)

    case Metadata.update_resource_class(resource_class, resource_class_params) do
      {:ok, resource_class} ->
        conn
        |> put_flash(:info, "Resource class updated successfully.")
        |> redirect(to: ~p"/resource_class/#{resource_class}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, resource_class: resource_class, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    resource_class = Metadata.get_resource_class!(id)
    {:ok, _resource_class} = Metadata.delete_resource_class(resource_class)

    conn
    |> put_flash(:info, "Resource class deleted successfully.")
    |> redirect(to: ~p"/resource_class")
  end
end
