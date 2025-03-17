defmodule VoileWeb.GoogleAuthController do
  use VoileWeb, :controller
  alias VoileWeb.UserAuthGoogle

  def request(conn, _params) do
    UserAuthGoogle.request(conn)
  end

  def callback(conn, _params) do
    UserAuthGoogle.callback(conn)
  end
end
