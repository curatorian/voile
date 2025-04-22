defmodule VoileWeb.Dashboard.Master.MasterLive do
  use VoileWeb, :live_view_dashboard

  def render(assigns) do
    ~H"""
    <div class="">
      <h1>Master Dashboard</h1>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Master Component")

    {:ok, socket}
  end
end
