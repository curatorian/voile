defmodule Voile.MetadataFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Voile.Metadata` context.
  """

  @doc """
  Generate a vocabulary.
  """
  def vocabulary_fixture(attrs \\ %{}) do
    {:ok, vocabulary} =
      attrs
      |> Enum.into(%{
        information: "some information",
        label: "some label",
        namespace_url: "some namespace_url",
        prefix: "some prefix"
      })
      |> Voile.Metadata.create_vocabulary()

    vocabulary
  end

  @doc """
  Generate a resource_class.
  """
  def resource_class_fixture(attrs \\ %{}) do
    {:ok, resource_class} =
      attrs
      |> Enum.into(%{
        information: "some information",
        label: "some label",
        local_name: "some local_name"
      })
      |> Voile.Metadata.create_resource_class()

    resource_class
  end

  @doc """
  Generate a resource_template.
  """
  def resource_template_fixture(attrs \\ %{}) do
    {:ok, resource_template} =
      attrs
      |> Enum.into(%{
        label: "some label"
      })
      |> Voile.Metadata.create_resource_template()

    resource_template
  end

  @doc """
  Generate a resource_template_property.
  """
  def resource_template_property_fixture(attrs \\ %{}) do
    {:ok, resource_template_property} =
      attrs
      |> Enum.into(%{
        alternate_information: "some alternate_information",
        alternate_label: "some alternate_label",
        data_type: ["option1", "option2"],
        is_required: true,
        permission: "some permission",
        position: 42
      })
      |> Voile.Metadata.create_resource_template_property()

    resource_template_property
  end
end
