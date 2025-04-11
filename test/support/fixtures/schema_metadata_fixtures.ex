defmodule Voile.SchemaMetadataFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Voile.SchemaMetadata` context.
  """

  @doc """
  Generate a property.
  """
  def property_fixture(attrs \\ %{}) do
    {:ok, property} =
      attrs
      |> Enum.into(%{
        information: "some information",
        label: "some label",
        local_name: "some local_name"
      })
      |> Voile.SchemaMetadata.create_property()

    property
  end
end
