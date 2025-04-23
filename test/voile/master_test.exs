defmodule Voile.MasterTest do
  use Voile.DataCase

  alias Voile.Master

  describe "mst_creator" do
    alias Voile.Master.Creator

    import Voile.MasterFixtures

    @invalid_attrs %{type: nil, creator_name: nil, creator_contact: nil, affiliation: nil}

    test "list_mst_creator/0 returns all mst_creator" do
      creator = creator_fixture()
      assert Master.list_mst_creator() == [creator]
    end

    test "get_creator!/1 returns the creator with given id" do
      creator = creator_fixture()
      assert Master.get_creator!(creator.id) == creator
    end

    test "create_creator/1 with valid data creates a creator" do
      valid_attrs = %{
        type: "some type",
        creator_name: "some creator_name",
        creator_contact: "some creator_contact",
        affiliation: "some affiliation"
      }

      assert {:ok, %Creator{} = creator} = Master.create_creator(valid_attrs)
      assert creator.type == "some type"
      assert creator.creator_name == "some creator_name"
      assert creator.creator_contact == "some creator_contact"
      assert creator.affiliation == "some affiliation"
    end

    test "create_creator/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Master.create_creator(@invalid_attrs)
    end

    test "update_creator/2 with valid data updates the creator" do
      creator = creator_fixture()

      update_attrs = %{
        type: "some updated type",
        creator_name: "some updated creator_name",
        creator_contact: "some updated creator_contact",
        affiliation: "some updated affiliation"
      }

      assert {:ok, %Creator{} = creator} = Master.update_creator(creator, update_attrs)
      assert creator.type == "some updated type"
      assert creator.creator_name == "some updated creator_name"
      assert creator.creator_contact == "some updated creator_contact"
      assert creator.affiliation == "some updated affiliation"
    end

    test "update_creator/2 with invalid data returns error changeset" do
      creator = creator_fixture()
      assert {:error, %Ecto.Changeset{}} = Master.update_creator(creator, @invalid_attrs)
      assert creator == Master.get_creator!(creator.id)
    end

    test "delete_creator/1 deletes the creator" do
      creator = creator_fixture()
      assert {:ok, %Creator{}} = Master.delete_creator(creator)
      assert_raise Ecto.NoResultsError, fn -> Master.get_creator!(creator.id) end
    end

    test "change_creator/1 returns a creator changeset" do
      creator = creator_fixture()
      assert %Ecto.Changeset{} = Master.change_creator(creator)
    end
  end

  describe "mst_frequency" do
    alias Voile.Master.Frequency

    import Voile.MasterFixtures

    @invalid_attrs %{time_unit: nil, frequency: nil, time_increment: nil}

    test "list_mst_frequency/0 returns all mst_frequency" do
      frequency = frequency_fixture()
      assert Master.list_mst_frequency() == [frequency]
    end

    test "get_frequency!/1 returns the frequency with given id" do
      frequency = frequency_fixture()
      assert Master.get_frequency!(frequency.id) == frequency
    end

    test "create_frequency/1 with valid data creates a frequency" do
      valid_attrs = %{
        time_unit: "some time_unit",
        frequency: "some frequency",
        time_increment: 42
      }

      assert {:ok, %Frequency{} = frequency} = Master.create_frequency(valid_attrs)
      assert frequency.time_unit == "some time_unit"
      assert frequency.frequency == "some frequency"
      assert frequency.time_increment == 42
    end

    test "create_frequency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Master.create_frequency(@invalid_attrs)
    end

    test "update_frequency/2 with valid data updates the frequency" do
      frequency = frequency_fixture()

      update_attrs = %{
        time_unit: "some updated time_unit",
        frequency: "some updated frequency",
        time_increment: 43
      }

      assert {:ok, %Frequency{} = frequency} = Master.update_frequency(frequency, update_attrs)
      assert frequency.time_unit == "some updated time_unit"
      assert frequency.frequency == "some updated frequency"
      assert frequency.time_increment == 43
    end

    test "update_frequency/2 with invalid data returns error changeset" do
      frequency = frequency_fixture()
      assert {:error, %Ecto.Changeset{}} = Master.update_frequency(frequency, @invalid_attrs)
      assert frequency == Master.get_frequency!(frequency.id)
    end

    test "delete_frequency/1 deletes the frequency" do
      frequency = frequency_fixture()
      assert {:ok, %Frequency{}} = Master.delete_frequency(frequency)
      assert_raise Ecto.NoResultsError, fn -> Master.get_frequency!(frequency.id) end
    end

    test "change_frequency/1 returns a frequency changeset" do
      frequency = frequency_fixture()
      assert %Ecto.Changeset{} = Master.change_frequency(frequency)
    end
  end

  describe "mst_member_types" do
    alias Voile.Master.MemberType

    import Voile.MasterFixtures

    @invalid_attrs %{
      name: nil,
      loan_limit: nil,
      loan_period: nil,
      enable_reserve: nil,
      membership_period: nil,
      reloan_limit: nil,
      loan_fine: nil,
      loan_grace_period: nil
    }

    test "list_mst_member_types/0 returns all mst_member_types" do
      member_type = member_type_fixture()
      assert Master.list_mst_member_types() == [member_type]
    end

    test "get_member_type!/1 returns the member_type with given id" do
      member_type = member_type_fixture()
      assert Master.get_member_type!(member_type.id) == member_type
    end

    test "create_member_type/1 with valid data creates a member_type" do
      valid_attrs = %{
        name: "some name",
        loan_limit: 42,
        loan_period: 42,
        enable_reserve: true,
        membership_period: 42,
        reloan_limit: 42,
        loan_fine: 42,
        loan_grace_period: 42
      }

      assert {:ok, %MemberType{} = member_type} = Master.create_member_type(valid_attrs)
      assert member_type.name == "some name"
      assert member_type.loan_limit == 42
      assert member_type.loan_period == 42
      assert member_type.enable_reserve == true
      assert member_type.membership_period == 42
      assert member_type.reloan_limit == 42
      assert member_type.loan_fine == 42
      assert member_type.loan_grace_period == 42
    end

    test "create_member_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Master.create_member_type(@invalid_attrs)
    end

    test "update_member_type/2 with valid data updates the member_type" do
      member_type = member_type_fixture()

      update_attrs = %{
        name: "some updated name",
        loan_limit: 43,
        loan_period: 43,
        enable_reserve: false,
        membership_period: 43,
        reloan_limit: 43,
        loan_fine: 43,
        loan_grace_period: 43
      }

      assert {:ok, %MemberType{} = member_type} =
               Master.update_member_type(member_type, update_attrs)

      assert member_type.name == "some updated name"
      assert member_type.loan_limit == 43
      assert member_type.loan_period == 43
      assert member_type.enable_reserve == false
      assert member_type.membership_period == 43
      assert member_type.reloan_limit == 43
      assert member_type.loan_fine == 43
      assert member_type.loan_grace_period == 43
    end

    test "update_member_type/2 with invalid data returns error changeset" do
      member_type = member_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Master.update_member_type(member_type, @invalid_attrs)
      assert member_type == Master.get_member_type!(member_type.id)
    end

    test "delete_member_type/1 deletes the member_type" do
      member_type = member_type_fixture()
      assert {:ok, %MemberType{}} = Master.delete_member_type(member_type)
      assert_raise Ecto.NoResultsError, fn -> Master.get_member_type!(member_type.id) end
    end

    test "change_member_type/1 returns a member_type changeset" do
      member_type = member_type_fixture()
      assert %Ecto.Changeset{} = Master.change_member_type(member_type)
    end
  end

  describe "mst_locations" do
    alias Voile.Master.Locations

    import Voile.MasterFixtures

    @invalid_attrs %{location_code: nil, location_name: nil, location_place: nil}

    test "list_mst_locations/0 returns all mst_locations" do
      locations = locations_fixture()
      assert Master.list_mst_locations() == [locations]
    end

    test "get_locations!/1 returns the locations with given id" do
      locations = locations_fixture()
      assert Master.get_locations!(locations.id) == locations
    end

    test "create_locations/1 with valid data creates a locations" do
      valid_attrs = %{
        location_code: "some location_code",
        location_name: "some location_name",
        location_place: "some location_place"
      }

      assert {:ok, %Locations{} = locations} = Master.create_locations(valid_attrs)
      assert locations.location_code == "some location_code"
      assert locations.location_name == "some location_name"
      assert locations.location_place == "some location_place"
    end

    test "create_locations/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Master.create_locations(@invalid_attrs)
    end

    test "update_locations/2 with valid data updates the locations" do
      locations = locations_fixture()

      update_attrs = %{
        location_code: "some updated location_code",
        location_name: "some updated location_name",
        location_place: "some updated location_place"
      }

      assert {:ok, %Locations{} = locations} = Master.update_locations(locations, update_attrs)
      assert locations.location_code == "some updated location_code"
      assert locations.location_name == "some updated location_name"
      assert locations.location_place == "some updated location_place"
    end

    test "update_locations/2 with invalid data returns error changeset" do
      locations = locations_fixture()
      assert {:error, %Ecto.Changeset{}} = Master.update_locations(locations, @invalid_attrs)
      assert locations == Master.get_locations!(locations.id)
    end

    test "delete_locations/1 deletes the locations" do
      locations = locations_fixture()
      assert {:ok, %Locations{}} = Master.delete_locations(locations)
      assert_raise Ecto.NoResultsError, fn -> Master.get_locations!(locations.id) end
    end

    test "change_locations/1 returns a locations changeset" do
      locations = locations_fixture()
      assert %Ecto.Changeset{} = Master.change_locations(locations)
    end
  end

  describe "mst_places" do
    alias Voile.Master.Places

    import Voile.MasterFixtures

    @invalid_attrs %{name: nil}

    test "list_mst_places/0 returns all mst_places" do
      places = places_fixture()
      assert Master.list_mst_places() == [places]
    end

    test "get_places!/1 returns the places with given id" do
      places = places_fixture()
      assert Master.get_places!(places.id) == places
    end

    test "create_places/1 with valid data creates a places" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Places{} = places} = Master.create_places(valid_attrs)
      assert places.name == "some name"
    end

    test "create_places/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Master.create_places(@invalid_attrs)
    end

    test "update_places/2 with valid data updates the places" do
      places = places_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Places{} = places} = Master.update_places(places, update_attrs)
      assert places.name == "some updated name"
    end

    test "update_places/2 with invalid data returns error changeset" do
      places = places_fixture()
      assert {:error, %Ecto.Changeset{}} = Master.update_places(places, @invalid_attrs)
      assert places == Master.get_places!(places.id)
    end

    test "delete_places/1 deletes the places" do
      places = places_fixture()
      assert {:ok, %Places{}} = Master.delete_places(places)
      assert_raise Ecto.NoResultsError, fn -> Master.get_places!(places.id) end
    end

    test "change_places/1 returns a places changeset" do
      places = places_fixture()
      assert %Ecto.Changeset{} = Master.change_places(places)
    end
  end

  describe "mst_publishers" do
    alias Voile.Master.Publishers

    import Voile.MasterFixtures

    @invalid_attrs %{name: nil, address: nil, city: nil, contact: nil}

    test "list_mst_publishers/0 returns all mst_publishers" do
      publishers = publishers_fixture()
      assert Master.list_mst_publishers() == [publishers]
    end

    test "get_publishers!/1 returns the publishers with given id" do
      publishers = publishers_fixture()
      assert Master.get_publishers!(publishers.id) == publishers
    end

    test "create_publishers/1 with valid data creates a publishers" do
      valid_attrs = %{
        name: "some name",
        address: "some address",
        city: "some city",
        contact: "some contact"
      }

      assert {:ok, %Publishers{} = publishers} = Master.create_publishers(valid_attrs)
      assert publishers.name == "some name"
      assert publishers.address == "some address"
      assert publishers.city == "some city"
      assert publishers.contact == "some contact"
    end

    test "create_publishers/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Master.create_publishers(@invalid_attrs)
    end

    test "update_publishers/2 with valid data updates the publishers" do
      publishers = publishers_fixture()

      update_attrs = %{
        name: "some updated name",
        address: "some updated address",
        city: "some updated city",
        contact: "some updated contact"
      }

      assert {:ok, %Publishers{} = publishers} =
               Master.update_publishers(publishers, update_attrs)

      assert publishers.name == "some updated name"
      assert publishers.address == "some updated address"
      assert publishers.city == "some updated city"
      assert publishers.contact == "some updated contact"
    end

    test "update_publishers/2 with invalid data returns error changeset" do
      publishers = publishers_fixture()
      assert {:error, %Ecto.Changeset{}} = Master.update_publishers(publishers, @invalid_attrs)
      assert publishers == Master.get_publishers!(publishers.id)
    end

    test "delete_publishers/1 deletes the publishers" do
      publishers = publishers_fixture()
      assert {:ok, %Publishers{}} = Master.delete_publishers(publishers)
      assert_raise Ecto.NoResultsError, fn -> Master.get_publishers!(publishers.id) end
    end

    test "change_publishers/1 returns a publishers changeset" do
      publishers = publishers_fixture()
      assert %Ecto.Changeset{} = Master.change_publishers(publishers)
    end
  end

  describe "mst_topics" do
    alias Voile.Master.Topic

    import Voile.MasterFixtures

    @invalid_attrs %{name: nil, type: nil, description: nil}

    test "list_mst_topics/0 returns all mst_topics" do
      topic = topic_fixture()
      assert Master.list_mst_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Master.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      valid_attrs = %{name: "some name", type: "some type", description: "some description"}

      assert {:ok, %Topic{} = topic} = Master.create_topic(valid_attrs)
      assert topic.name == "some name"
      assert topic.type == "some type"
      assert topic.description == "some description"
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Master.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()

      update_attrs = %{
        name: "some updated name",
        type: "some updated type",
        description: "some updated description"
      }

      assert {:ok, %Topic{} = topic} = Master.update_topic(topic, update_attrs)
      assert topic.name == "some updated name"
      assert topic.type == "some updated type"
      assert topic.description == "some updated description"
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Master.update_topic(topic, @invalid_attrs)
      assert topic == Master.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Master.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Master.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Master.change_topic(topic)
    end
  end
end
