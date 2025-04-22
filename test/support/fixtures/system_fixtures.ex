defmodule Voile.SystemFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Voile.System` context.
  """

  @doc """
  Generate a node.
  """
  def node_fixture(attrs \\ %{}) do
    {:ok, node} =
      attrs
      |> Enum.into(%{
        abbr: "some abbr",
        image: "some image",
        name: "some name"
      })
      |> Voile.System.create_node()

    node
  end

  @doc """
  Generate a setting.
  """
  def setting_fixture(attrs \\ %{}) do
    {:ok, setting} =
      attrs
      |> Enum.into(%{
        setting_name: "some setting_name",
        setting_value: "some setting_value"
      })
      |> Voile.System.create_setting()

    setting
  end

  @doc """
  Generate a system_log.
  """
  def system_log_fixture(attrs \\ %{}) do
    {:ok, system_log} =
      attrs
      |> Enum.into(%{
        log_date: ~U[2025-04-21 08:02:00Z],
        log_location: "some log_location",
        log_msg: "some log_msg",
        log_type: "some log_type"
      })
      |> Voile.System.create_system_log()

    system_log
  end
end
