defmodule VoileWeb.Dashboard.Catalog.CollectionLive.Show do
  use VoileWeb, :live_view_dashboard

  alias Voile.Catalog

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:step, 1)
      |> assign(:show_add_collection_field, true)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    dbg(Catalog.get_collection!(id))

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:collection, Catalog.get_collection!(id))}
  end

  defp page_title(:show), do: "Show Collection"
  defp page_title(:edit), do: "Edit Collection"
end
