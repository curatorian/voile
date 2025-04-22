defmodule Voile.System do
  @moduledoc """
  The System context.
  """

  import Ecto.Query, warn: false
  alias Voile.Repo

  alias Voile.System.Node
  alias Voile.System.Setting
  alias Voile.System.SystemLog

  @doc """
  Returns the list of nodes.

  ## Examples

      iex> list_nodes()
      [%Node{}, ...]

  """
  def list_nodes do
    Repo.all(Node)
  end

  @doc """
  Gets a single node.

  Raises `Ecto.NoResultsError` if the Node does not exist.

  ## Examples

      iex> get_node!(123)
      %Node{}

      iex> get_node!(456)
      ** (Ecto.NoResultsError)

  """
  def get_node!(id), do: Repo.get!(Node, id)

  @doc """
  Creates a node.

  ## Examples

      iex> create_node(%{field: value})
      {:ok, %Node{}}

      iex> create_node(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_node(attrs \\ %{}) do
    %Node{}
    |> Node.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a node.

  ## Examples

      iex> update_node(node, %{field: new_value})
      {:ok, %Node{}}

      iex> update_node(node, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_node(%Node{} = node, attrs) do
    node
    |> Node.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a node.

  ## Examples

      iex> delete_node(node)
      {:ok, %Node{}}

      iex> delete_node(node)
      {:error, %Ecto.Changeset{}}

  """
  def delete_node(%Node{} = node) do
    Repo.delete(node)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking node changes.

  ## Examples

      iex> change_node(node)
      %Ecto.Changeset{data: %Node{}}

  """
  def change_node(%Node{} = node, attrs \\ %{}) do
    Node.changeset(node, attrs)
  end

  @doc """
  Returns the list of settings.

  ## Examples

      iex> list_settings()
      [%Setting{}, ...]

  """
  def list_settings do
    Repo.all(Setting)
  end

  @doc """
  Gets a single setting.

  Raises `Ecto.NoResultsError` if the Setting does not exist.

  ## Examples

      iex> get_setting!(123)
      %Setting{}

      iex> get_setting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_setting!(id), do: Repo.get!(Setting, id)

  @doc """
  Creates a setting.

  ## Examples

      iex> create_setting(%{field: value})
      {:ok, %Setting{}}

      iex> create_setting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_setting(attrs \\ %{}) do
    %Setting{}
    |> Setting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a setting.

  ## Examples

      iex> update_setting(setting, %{field: new_value})
      {:ok, %Setting{}}

      iex> update_setting(setting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_setting(%Setting{} = setting, attrs) do
    setting
    |> Setting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a setting.

  ## Examples

      iex> delete_setting(setting)
      {:ok, %Setting{}}

      iex> delete_setting(setting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_setting(%Setting{} = setting) do
    Repo.delete(setting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking setting changes.

  ## Examples

      iex> change_setting(setting)
      %Ecto.Changeset{data: %Setting{}}

  """
  def change_setting(%Setting{} = setting, attrs \\ %{}) do
    Setting.changeset(setting, attrs)
  end

  @doc """
  Returns the list of system_logs.

  ## Examples

      iex> list_system_logs()
      [%SystemLog{}, ...]

  """
  def list_system_logs do
    Repo.all(SystemLog)
  end

  @doc """
  Gets a single system_log.

  Raises `Ecto.NoResultsError` if the System log does not exist.

  ## Examples

      iex> get_system_log!(123)
      %SystemLog{}

      iex> get_system_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_system_log!(id), do: Repo.get!(SystemLog, id)

  @doc """
  Creates a system_log.

  ## Examples

      iex> create_system_log(%{field: value})
      {:ok, %SystemLog{}}

      iex> create_system_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_system_log(attrs \\ %{}) do
    %SystemLog{}
    |> SystemLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a system_log.

  ## Examples

      iex> update_system_log(system_log, %{field: new_value})
      {:ok, %SystemLog{}}

      iex> update_system_log(system_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_system_log(%SystemLog{} = system_log, attrs) do
    system_log
    |> SystemLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a system_log.

  ## Examples

      iex> delete_system_log(system_log)
      {:ok, %SystemLog{}}

      iex> delete_system_log(system_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_system_log(%SystemLog{} = system_log) do
    Repo.delete(system_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking system_log changes.

  ## Examples

      iex> change_system_log(system_log)
      %Ecto.Changeset{data: %SystemLog{}}

  """
  def change_system_log(%SystemLog{} = system_log, attrs \\ %{}) do
    SystemLog.changeset(system_log, attrs)
  end
end
