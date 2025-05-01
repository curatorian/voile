defmodule Voile.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Voile.Catalog` context.
  """

  @doc """
  Generate a collection.
  """
  def collection_fixture(attrs \\ %{}) do
    {:ok, collection} =
      attrs
      |> Enum.into(%{
        access_level: "some access_level",
        description: "some description",
        status: "some status",
        thumbnail: "some thumbnail",
        title: "some title"
      })
      |> Voile.Catalog.create_collection()

    collection
  end

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        availability: "some availability",
        barcode: "some barcode",
        condition: "some condition",
        inventory_code: "some inventory_code",
        item_code: "some item_code",
        location: "some location",
        status: "some status"
      })
      |> Voile.Catalog.create_item()

    item
  end

  @doc """
  Generate a collection_field.
  """
  def collection_field_fixture(attrs \\ %{}) do
    {:ok, collection_field} =
      attrs
      |> Enum.into(%{
        field_type: "some field_type",
        label: "some label",
        name: "some name",
        required: true,
        sort_order: 42
      })
      |> Voile.Catalog.create_collection_field()

    collection_field
  end

  @doc """
  Generate a item_field_value.
  """
  def item_field_value_fixture(attrs \\ %{}) do
    {:ok, item_field_value} =
      attrs
      |> Enum.into(%{
        locale: "some locale",
        value: "some value"
      })
      |> Voile.Catalog.create_item_field_value()

    item_field_value
  end
end
