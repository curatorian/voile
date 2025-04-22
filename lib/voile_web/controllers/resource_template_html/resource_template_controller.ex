defmodule VoileWeb.ResourceTemplateController do
  use VoileWeb, :controller

  alias Voile.Schema.Metadata
  alias Voile.Schema.Metadata.ResourceTemplate

  def index(conn, _params) do
    resource_template = Metadata.list_resource_template()
    render(conn, :index, resource_template_collection: resource_template)
  end

  def new(conn, _params) do
    changeset = Metadata.change_resource_template(%ResourceTemplate{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"resource_template" => resource_template_params}) do
    case Metadata.create_resource_template(resource_template_params) do
      {:ok, resource_template} ->
        conn
        |> put_flash(:info, "Resource template created successfully.")
        |> redirect(to: ~p"/manage/metaresource/resource_template/#{resource_template}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    resource_template = Metadata.get_resource_template!(id)
    render(conn, :show, resource_template: resource_template)
  end

  def edit(conn, %{"id" => id}) do
    resource_template = Metadata.get_resource_template!(id)
    changeset = Metadata.change_resource_template(resource_template)
    render(conn, :edit, resource_template: resource_template, changeset: changeset)
  end

  def update(conn, %{"id" => id, "resource_template" => resource_template_params}) do
    resource_template = Metadata.get_resource_template!(id)

    case Metadata.update_resource_template(resource_template, resource_template_params) do
      {:ok, resource_template} ->
        conn
        |> put_flash(:info, "Resource template updated successfully.")
        |> redirect(to: ~p"/manage/metaresource/resource_template/#{resource_template}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, resource_template: resource_template, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    resource_template = Metadata.get_resource_template!(id)
    {:ok, _resource_template} = Metadata.delete_resource_template(resource_template)

    conn
    |> put_flash(:info, "Resource template deleted successfully.")
    |> redirect(to: ~p"/manage/metaresource/resource_template")
  end
end
