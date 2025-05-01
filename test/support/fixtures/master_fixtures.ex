defmodule Voile.MasterFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Voile.Master` context.
  """

  @doc """
  Generate a creator.
  """
  def creator_fixture(attrs \\ %{}) do
    {:ok, creator} =
      attrs
      |> Enum.into(%{
        affiliation: "some affiliation",
        creator_contact: "some creator_contact",
        creator_name: "some creator_name",
        type: "some type"
      })
      |> Voile.Schema.Master.create_creator()

    creator
  end

  @doc """
  Generate a frequency.
  """
  def frequency_fixture(attrs \\ %{}) do
    {:ok, frequency} =
      attrs
      |> Enum.into(%{
        frequency: "some frequency",
        time_increment: 42,
        time_unit: "some time_unit"
      })
      |> Voile.Schema.Master.create_frequency()

    frequency
  end

  @doc """
  Generate a member_type.
  """
  def member_type_fixture(attrs \\ %{}) do
    {:ok, member_type} =
      attrs
      |> Enum.into(%{
        enable_reserve: true,
        loan_fine: 42,
        loan_grace_period: 42,
        loan_limit: 42,
        loan_period: 42,
        membership_period: 42,
        name: "some name",
        reloan_limit: 42
      })
      |> Voile.Schema.Master.create_member_type()

    member_type
  end

  @doc """
  Generate a locations.
  """
  def locations_fixture(attrs \\ %{}) do
    {:ok, locations} =
      attrs
      |> Enum.into(%{
        location_code: "some location_code",
        location_name: "some location_name",
        location_place: "some location_place"
      })
      |> Voile.Schema.Master.create_locations()

    locations
  end

  @doc """
  Generate a places.
  """
  def places_fixture(attrs \\ %{}) do
    {:ok, places} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Voile.Schema.Master.create_places()

    places
  end

  @doc """
  Generate a publishers.
  """
  def publishers_fixture(attrs \\ %{}) do
    {:ok, publishers} =
      attrs
      |> Enum.into(%{
        address: "some address",
        city: "some city",
        contact: "some contact",
        name: "some name"
      })
      |> Voile.Schema.Master.create_publishers()

    publishers
  end

  @doc """
  Generate a topic.
  """
  def topic_fixture(attrs \\ %{}) do
    {:ok, topic} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        type: "some type"
      })
      |> Voile.Schema.Master.create_topic()

    topic
  end
end
