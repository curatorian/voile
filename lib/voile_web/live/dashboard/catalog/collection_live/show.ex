defmodule VoileWeb.Dashboard.Catalog.CollectionLive.Show do
  use VoileWeb, :live_view_dashboard

  alias Voile.Catalog
  alias Voile.Schema.Master
  alias Voile.Schema.Metadata
  alias Voile.Schema.System

  @impl true
  def mount(_params, _session, socket) do
    collections = Catalog.list_collections()
    collection_type = Metadata.list_resource_class()
    collection_properties = Metadata.list_metadata_properties_by_vocabulary()
    creator = Master.list_mst_creator()
    node_location = System.list_nodes()

    socket =
      socket
      |> stream(:collections, collections)
      |> assign(:collection_type, collection_type)
      |> assign(:collection_properties, collection_properties)
      |> assign(:creator, creator)
      |> assign(:node_location, node_location)
      |> assign(:step, 1)
      |> assign(:show_add_collection_field, true)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    get_data = Catalog.get_collection!(id)
    dbg(get_data)
    dbg(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:collection, Catalog.get_collection!(id))}
  end

  defp page_title(:show), do: "Show Collection"
  defp page_title(:edit), do: "Edit Collection"
end
