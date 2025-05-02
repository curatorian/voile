defmodule VoileWeb.Dashboard.Master.CreatorLive.Index do
  use VoileWeb, :live_view_dashboard

  alias Voile.Schema.Master
  # alias Voile.Schema.Master.Creator

  def mount(_params, _session, socket) do
    {:ok, assign(socket, creators: Master.list_mst_creator())}
  end
end
