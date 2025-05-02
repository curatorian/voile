defmodule VoileWeb.Dashboard.Master.CreatorLive.Show do
  use VoileWeb, :live_view_dashboard

  alias Voile.Schema.Master

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:creator, Master.get_creator!(id))}
  end

  defp page_title(:show), do: "Show Creator"
  defp page_title(:edit), do: "Edit Creator"
end
