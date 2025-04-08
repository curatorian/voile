defmodule VoileWeb.Utils.SaltGenerator do
  def generate do
    salt = :crypto.strong_rand_bytes(4)
    salt |> Base.url_encode64(padding: false)
  end
end
