defmodule Voile.SchemaMetadataTest do
  use Voile.DataCase

  alias Voile.SchemaMetadata

  describe "metadata_properties" do
    alias Voile.SchemaMetadata.Property

    import Voile.SchemaMetadataFixtures

    @invalid_attrs %{label: nil, local_name: nil, information: nil}

    test "list_metadata_properties/0 returns all metadata_properties" do
      property = property_fixture()
      assert SchemaMetadata.list_metadata_properties() == [property]
    end

    test "get_property!/1 returns the property with given id" do
      property = property_fixture()
      assert SchemaMetadata.get_property!(property.id) == property
    end

    test "create_property/1 with valid data creates a property" do
      valid_attrs = %{label: "some label", local_name: "some local_name", information: "some information"}

      assert {:ok, %Property{} = property} = SchemaMetadata.create_property(valid_attrs)
      assert property.label == "some label"
      assert property.local_name == "some local_name"
      assert property.information == "some information"
    end

    test "create_property/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SchemaMetadata.create_property(@invalid_attrs)
    end

    test "update_property/2 with valid data updates the property" do
      property = property_fixture()
      update_attrs = %{label: "some updated label", local_name: "some updated local_name", information: "some updated information"}

      assert {:ok, %Property{} = property} = SchemaMetadata.update_property(property, update_attrs)
      assert property.label == "some updated label"
      assert property.local_name == "some updated local_name"
      assert property.information == "some updated information"
    end

    test "update_property/2 with invalid data returns error changeset" do
      property = property_fixture()
      assert {:error, %Ecto.Changeset{}} = SchemaMetadata.update_property(property, @invalid_attrs)
      assert property == SchemaMetadata.get_property!(property.id)
    end

    test "delete_property/1 deletes the property" do
      property = property_fixture()
      assert {:ok, %Property{}} = SchemaMetadata.delete_property(property)
      assert_raise Ecto.NoResultsError, fn -> SchemaMetadata.get_property!(property.id) end
    end

    test "change_property/1 returns a property changeset" do
      property = property_fixture()
      assert %Ecto.Changeset{} = SchemaMetadata.change_property(property)
    end
  end
end
