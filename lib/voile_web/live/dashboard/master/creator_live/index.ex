defmodule VoileWeb.Dashboard.Master.CreatorLive.Index do
  use VoileWeb, :live_view_dashboard

  alias Voile.Schema.Master
  alias Voile.Schema.Master.Creator

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :creators, Master.list_mst_creator())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Creator")
    |> assign(:creator, Master.get_creator!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Item")
    |> assign(:creator, %Creator{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Creators")
    |> assign(:creator, nil)
  end

  @impl true
  def handle_info(
        {VoileWeb.Dashboard.Master.CreatorLive.FormComponent, {:saved, creator}},
        socket
      ) do
    {:noreply, stream_insert(socket, :creators, creator)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    creator = Master.get_creator!(id)
    {:ok, _} = Master.delete_creator(creator)

    {:noreply, stream_delete(socket, :creators, creator)}
  end
end
