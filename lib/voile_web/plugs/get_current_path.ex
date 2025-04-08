defmodule VoileWeb.Plugs.GetCurrentPath do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    current_path = conn.request_path
    conn |> assign(:current_path, current_path)
  end
end
