defmodule VoileWeb.PageController do
  use VoileWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home)
  end

  def about(conn, _params) do
    render(conn, :about)
  end
end
