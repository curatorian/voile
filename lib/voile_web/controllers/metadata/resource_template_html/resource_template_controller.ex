defmodule VoileWeb.ResourceTemplateController do
  use VoileWeb, :controller_dashboard

  alias Voile.Schema.Metadata
  alias Voile.Schema.Metadata.ResourceTemplate

  def index(conn, _params) do
    page = Map.get(conn.params, "page", "1") |> String.to_integer()
    per_page = 10

    {resource_template_collection, total_pages} =
      Metadata.list_resource_templates_paginated(page, per_page)

    conn
    |> assign(:resource_template_collection, resource_template_collection)
    |> assign(:page, page)
    |> assign(:total_pages, total_pages)
    |> render(:index)
  end

  def new(conn, _params) do
    resource_class = Metadata.list_resource_class()
    changeset = Metadata.change_resource_template(%ResourceTemplate{})

    conn
    |> assign(:resource_class, resource_class)
    |> assign(:changeset, changeset)
    |> render(:new)
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
    resource_class = Metadata.list_resource_class()
    resource_template = Metadata.get_resource_template!(id)

    conn
    |> assign(:resource_class, resource_class)
    |> assign(:resource_template, resource_template)
    |> render(:show)
  end

  def edit(conn, %{"id" => id}) do
    resource_class = Metadata.list_resource_class()
    resource_template = Metadata.get_resource_template!(id)
    changeset = Metadata.change_resource_template(resource_template)

    conn
    |> assign(:resource_class, resource_class)
    |> assign(:resource_template, resource_template)
    |> assign(:changeset, changeset)
    |> render(:edit)
  end

  def update(conn, %{"id" => id, "resource_template" => resource_template_params}) do
    resource_class = Metadata.list_resource_class()
    resource_template = Metadata.get_resource_template!(id)

    case Metadata.update_resource_template(resource_template, resource_template_params) do
      {:ok, resource_template} ->
        conn
        |> put_flash(:info, "Resource template updated successfully.")
        |> redirect(to: ~p"/manage/metaresource/resource_template/#{resource_template}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:resource_class, resource_class)
        |> assign(:resource_template, resource_template)
        |> assign(:changeset, changeset)
        |> render(:edit)
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
