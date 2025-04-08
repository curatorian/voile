defmodule VoileWeb.Utils.DateUtils do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    year = Date.utc_today().year

    conn |> assign(:year, year)
  end
end
