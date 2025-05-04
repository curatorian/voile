defmodule Client.Storage.Local do
  @moduledoc """
  Storage modul to store fils locally.
  """

  def upload(%{"file" => %Plug.Upload{path: tmp_path, content_type: content_type}}) do
    # Create upload dir if it does not exist
    create_upload_dir()

    # Geneerate a unique filename
    file_name = "#{Ecto.UUID.generate()}.#{ext(content_type)}"

    case File.cp(tmp_path, Path.join(upload_dir(), file_name)) do
      :ok -> {:ok, Path.join(["uploads/contents", file_name])}
      {:error, reason} -> {:error, reason}
    end
  end

  def delete(file_url) do
    "priv/static/"
    |> Path.join(file_url)
    |> File.rm()
    |> case do
      :ok -> {:ok, file_url}
      {:error, reason} -> {:error, reason}
    end
  end

  defp ext(content_type) do
    [ext | _] = MIME.extensions(content_type)
    ext
  end

  defp upload_dir(), do: Path.join(["priv", "static", "uploads", "contents"])
  defp create_upload_dir(), do: File.mkdir_p!(upload_dir())
end
