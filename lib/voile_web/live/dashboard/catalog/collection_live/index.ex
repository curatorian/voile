defmodule VoileWeb.Dashboard.Catalog.CollectionLive.Index do
  use VoileWeb, :live_view_dashboard

  alias Voile.Repo
  alias Voile.Catalog
  alias Voile.Catalog.Collection
  alias Voile.Schema.Master
  alias Voile.Schema.Metadata

  @impl true
  def mount(_params, _session, socket) do
    collections = Catalog.list_collections()
    collection_type = Metadata.list_resource_class()
    collection_properties = Metadata.list_metadata_properties_by_vocabulary()
    creator = Master.list_mst_creator()

    socket =
      socket
      |> stream(:collections, collections)
      |> assign(:collection_type, collection_type)
      |> assign(:collection_properties, collection_properties)
      |> assign(:creator, creator)
      |> assign(:step, 2)
      |> assign(:show_add_collection_field, true)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Collection")
    |> assign(:collection, Catalog.get_collection!(id))
  end

  defp apply_action(socket, :new, _params) do
    collection = %Collection{}

    collection =
      collection
      |> Repo.preload([
        :resource_class,
        :resource_template,
        :mst_creator,
        :node,
        :collection_fields
      ])

    socket
    |> assign(:page_title, "New Collection")
    |> assign(:collection, collection)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Collections")
    |> assign(:collection, nil)
  end

  @impl true
  def handle_info(
        {VoileWeb.Dashboard.Catalog.CollectionLive.FormComponent, {:saved, collection}},
        socket
      ) do
    {:noreply, stream_insert(socket, :collections, collection)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    collection = Catalog.get_collection!(id)
    {:ok, _} = Catalog.delete_collection(collection)

    {:noreply, stream_delete(socket, :collections, collection)}
  end
end
