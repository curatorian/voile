defmodule VoileWeb.Dashboard.Circulation.Index do
  use VoileWeb, :live_view_dashboard

  def render(assigns) do
    ~H"""
    <h1>Circulation Dashboard</h1>

    <p>Welcome to the Circulation Dashboard. Here you can manage circulation-related tasks.</p>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
