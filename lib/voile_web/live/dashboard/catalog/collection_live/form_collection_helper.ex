defmodule VoileWeb.Dashboard.Catalog.CollectionLive.FormCollectionHelper do
  use VoileWeb, :live_component

  import Voile.Utils.ItemHelper

  alias Voile.Catalog
  alias Voile.Schema.Master
  alias Voile.Schema.Metadata

  def add_property_to_form(prop_id, socket) do
    # Get current form params
    current_params = socket.assigns.form.params || %{}

    existing_items = current_params["items"] || %{}

    # Get current collection fields
    current_fields = current_params["collection_fields"] || %{}

    # Get property data
    property = Metadata.get_property!(prop_id)

    # Determine next index
    new_index = map_size(current_fields)

    # Create new field
    new_field = %{
      "label" => property.label,
      "type_value" => property.type_value,
      "information" => property.information,
      "property_id" => property.id,
      "name" => String.split(property.label) |> Enum.join(""),
      "value_lang" => "id",
      "value" => nil,
      "sort_order" => new_index + 1
    }

    # Add to existing fields
    updated_fields = Map.put(current_fields, to_string(new_index), new_field)

    # Create updated params with ALL existing data
    new_params =
      current_params
      |> Map.put("collection_fields", updated_fields)
      |> Map.put("items", existing_items)

    # Create changeset and update socket
    changeset = Catalog.change_collection(socket.assigns.collection, new_params)

    socket
    |> assign(:form, to_form(changeset, action: :validate))
  end

  def add_item_to_form(socket) do
    # Get current form params
    current_params = socket.assigns.form.params || %{}
    existing_fields = current_params["collection_fields"] || %{}

    # Safely get collection data
    collection = socket.assigns.collection || %{unit_id: nil, type_id: nil}

    # Safely get unit and type data
    unit_data =
      if collection.unit_id,
        do: Voile.Schema.System.get_node!(collection.unit_id) || %{abbr: "UNK"},
        else: %{abbr: "UNK"}

    type_data =
      if collection.type_id,
        do: Voile.Schema.Metadata.get_resource_class!(collection.type_id) || %{local_name: "UNK"},
        else: %{local_name: "UNK"}

    # Get current items
    current_items = current_params["items"] || %{}

    # Generate new item
    new_index = map_size(current_items)

    new_item = %{
      "item_code" =>
        generate_item_code(
          unit_data.abbr,
          type_data.local_name,
          socket.assigns.time_identifier,
          to_string(new_index + 1)
        ),
      "inventory_code" =>
        generate_inventory_code(
          unit_data.abbr,
          type_data.local_name,
          to_string(new_index + 1)
        ),
      "barcode" => Ecto.UUID.generate(),
      "location" => to_string(collection.unit_id),
      "status" => "active",
      "condition" => "new",
      "availability" => "available"
    }

    # Add new item
    updated_items = Map.put(current_items, to_string(new_index), new_item)

    new_params =
      current_params
      |> Map.put("items", updated_items)
      |> Map.put("collection_fields", existing_fields)

    changeset = Voile.Catalog.Collection.changeset(socket.assigns.collection, new_params)

    assign(socket,
      form: to_form(changeset, action: :validate),
      collection_has_more_than_one_item: true
    )
  end

  def assign_selected_creator(id, socket) do
    case Enum.find(socket.assigns.creator_list, fn c -> to_string(c.id) == id end) do
      nil ->
        socket
        |> assign(:creator_input, "")
        |> assign(:creator_suggestions, [])

      selected ->
        # Get current form params
        current_params = socket.assigns.form.params || %{}
        # Update form params with selected creator_id
        updated_params = Map.put(current_params, "creator_id", selected.id |> to_string())
        # Create updated changeset
        changeset = Voile.Catalog.change_collection(socket.assigns.collection, updated_params)

        socket
        |> assign(:creator_input, selected.creator_name)
        |> assign(:creator_suggestions, [])
        |> assign(:collection, %{
          socket.assigns.collection
          | creator_id: selected.id
        })
        |> assign(:form, to_form(changeset, action: :validate))
    end
  end

  def create_or_select_creator(creator_name, socket) do
    case Master.get_or_create_creator(%{creator_name: creator_name}) do
      {:ok, new_creator} ->
        updated_creator_list = [new_creator | socket.assigns.creator_list]

        # Get current form params
        current_params = socket.assigns.form.params || %{}
        # Update form params with selected creator_id
        updated_params = Map.put(current_params, "creator_id", new_creator.id |> to_string())
        # Create updated changeset
        changeset = Catalog.change_collection(socket.assigns.collection, updated_params)

        socket =
          socket
          |> assign(:creator_input, new_creator.creator_name)
          |> assign(:creator_suggestions, [])
          |> assign(:creator_list, updated_creator_list)
          |> assign(:collection, %{
            socket.assigns.collection
            | creator_id: new_creator.id
          })
          |> assign(:form, to_form(changeset, action: :validate))

        {:ok, socket}

      {:error, _reason} ->
        socket =
          socket
          |> put_flash(:error, "Failed to create new creator.")
          |> assign(:creator_suggestions, [])
          |> assign(:collection, socket.assigns.collection)

        {:error, socket}
    end
  end

  def clear_selected_creator(socket) do
    socket
    |> assign(:creator_input, nil)
    |> assign(:collection, %{socket.assigns.collection | creator_id: nil})
  end

  def delete_unsaved_field_at(index_str, socket) do
    # Always start with current form parameters
    current_params = socket.assigns.form.params || %{}

    # Get current collection fields
    current_fields = Map.get(current_params, "collection_fields", %{})

    # Convert to list while preserving order
    sorted_entries =
      current_fields
      |> Enum.sort_by(fn {k, _} -> String.to_integer(k) end)
      |> Enum.map(fn {_, v} -> v end)

    # Convert index to integer
    index = String.to_integer(index_str)

    # Delete the entry at the given index
    new_list = List.delete_at(sorted_entries, index)

    # Reindex and convert back to map
    new_fields =
      new_list
      |> Enum.with_index()
      |> Enum.into(%{}, fn {entry, idx} -> {to_string(idx), entry} end)

    # Create updated params with all existing data
    new_params = Map.put(current_params, "collection_fields", new_fields)

    # Create changeset with only the parameters (not the form struct)
    changeset = Catalog.change_collection(socket.assigns.collection, new_params)

    assign(socket, form: to_form(changeset, action: :validate))
  end

  def delete_unsaved_item_at(index_str, socket) do
    current_params = socket.assigns.form.params || %{}
    current_items = Map.get(current_params, "items", %{})

    sorted_entries =
      current_items
      |> Enum.sort_by(fn {k, _} -> String.to_integer(k) end)
      |> Enum.map(fn {_, v} -> v end)

    index = String.to_integer(index_str)
    new_list = List.delete_at(sorted_entries, index)

    new_items =
      new_list
      |> Enum.with_index()
      |> Enum.into(%{}, fn {entry, idx} -> {to_string(idx), entry} end)

    new_params = Map.put(current_params, "items", new_items)
    changeset = Catalog.change_collection(socket.assigns.collection, new_params)

    assign(socket, form: to_form(changeset, action: :validate))
  end

  def delete_existing_field(id, socket) do
    # Try to fetch the collection field
    case Catalog.get_collection_field!(id) do
      nil ->
        # Field not found, return unchanged socket
        socket

      field ->
        # Delete the field from database
        case Catalog.delete_collection_field(field) do
          {:ok, _} ->
            # Get current form params
            current_params = socket.assigns.form.params || %{}

            # Get current collection fields
            current_fields = Map.get(current_params, "collection_fields", %{})

            # Remove the deleted field from form state
            updated_fields =
              current_fields
              |> Enum.reject(fn {_, field_data} ->
                field_data["id"] == id || field_data[:id] == id
              end)
              |> Enum.with_index()
              |> Enum.into(%{}, fn {field_data, idx} -> {to_string(idx), field_data} end)

            # Create updated params preserving all other data
            new_params = Map.put(current_params, "collection_fields", updated_fields)

            # Create changeset with updated params
            changeset = Catalog.change_collection(socket.assigns.collection, new_params)

            # Update socket without reloading collection
            socket
            |> assign(:form, to_form(changeset, action: :validate))

          {:error, _} ->
            # Deletion failed, show error
            socket
            |> put_flash(:error, "Could not delete field")
        end
    end
  end

  def delete_existing_item(id, socket) do
    case Catalog.get_item!(id) do
      nil ->
        socket

      item ->
        case Catalog.delete_item(item) do
          {:ok, _} ->
            current_params = socket.assigns.form.params || %{}
            current_items = Map.get(current_params, "items", %{})

            updated_items =
              current_items
              |> Enum.reject(fn {_, item_data} ->
                item_data["id"] == id || item_data[:id] == id
              end)
              |> Enum.with_index()
              |> Enum.into(%{}, fn {item_data, idx} -> {to_string(idx), item_data} end)

            new_params = Map.put(current_params, "items", updated_items)
            changeset = Catalog.change_collection(socket.assigns.collection, new_params)

            socket
            |> assign(:form, to_form(changeset, action: :validate))

          {:error, _} ->
            socket
            |> put_flash(:error, "Could not delete item")
        end
    end
  end

  def confirm_field_deletion(id, socket) do
    chosen_collection_field = Catalog.get_collection_field!(id)

    socket
    |> assign(:delete_confirmation_id, id)
    |> assign(:chosen_collection_field, chosen_collection_field)
  end

  def confirm_item_deletion(id, socket) do
    chosen_item = Catalog.get_item!(id)

    socket
    |> assign(:delete_confirmation_id, id)
    |> assign(:chosen_item, chosen_item)
  end

  def search_properties(query, socket) do
    filtered = filter_properties(socket.assigns.collection_properties, query)

    socket
    |> assign(:property_search, query)
    |> assign(:filtered_properties, filtered)
  end

  def handle_delete_thumbnail(%{"thumbnail" => thumbnail_path}, socket) do
    uploads = socket.assigns.uploads

    # Cancel all thumbnail uploads
    socket =
      Enum.reduce(uploads.thumbnail.entries, socket, fn entry, sock ->
        cancel_upload(sock, :thumbnail, entry.ref)
      end)

    case socket.assigns.action do
      :new -> handle_delete_thumbnail_new(thumbnail_path, socket)
      :edit -> handle_delete_thumbnail_edit(thumbnail_path, socket)
      _ -> handle_delete_thumbnail_new(thumbnail_path, socket)
    end
  end

  def handle_thumbnail_progress(:thumbnail, entry, socket) do
    if entry.done? do
      # Delete old thumbnail if exists
      dbg(socket.assigns.form.params["thumbnail"])

      if socket.assigns.form.params["thumbnail"] do
        old_file = Path.basename(socket.assigns.form.params["thumbnail"])
        old_path = Path.join([:code.priv_dir(:voile), "static", "uploads", "thumbnail", old_file])

        if File.exists?(old_path) do
          case File.rm(old_path) do
            :ok ->
              IO.puts("Successfully deleted old thumbnail: #{old_path}")

            {:error, reason} ->
              IO.puts("Could not delete old thumbnail #{old_path}: #{inspect(reason)}")
              # Continue execution even if deletion fails
          end
        end
      end

      [url] =
        consume_uploaded_entries(socket, :thumbnail, fn %{path: path}, entry ->
          ext = Path.extname(entry.client_name)
          file_name = "#{System.system_time(:second)}-thumbnail-#{Ecto.UUID.generate()}#{ext}"

          dest =
            Path.join([
              :code.priv_dir(:voile),
              "static",
              "uploads",
              "thumbnail",
              file_name
            ])

          case File.cp(path, dest) do
            :ok ->
              {:ok, "/uploads/thumbnail/#{Path.basename(dest)}"}

            {:error, reason} ->
              IO.puts("Failed to copy thumbnail file: #{inspect(reason)}")
              {:error, "Failed to upload thumbnail"}
          end
        end)

      case url do
        {:error, error_message} ->
          {:noreply,
           socket
           |> put_flash(:error, error_message)}

        url when is_binary(url) ->
          form_params = Map.put(socket.assigns.form.params || %{}, "thumbnail", url)
          changeset = Catalog.change_collection(socket.assigns.collection, form_params)

          {:noreply,
           socket
           |> assign(:form, to_form(changeset))
           |> assign(:collection, Ecto.Changeset.apply_changes(changeset))}
      end
    else
      {:noreply, socket}
    end
  end

  def save_collection(socket, :edit, collection_params) do
    case Catalog.update_collection(socket.assigns.original_collection, collection_params) do
      {:ok, collection} ->
        notify_parent({:saved, collection})

        {:noreply,
         socket
         |> put_flash(:info, "Collection updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def save_collection(socket, :new, collection_params) do
    case Catalog.create_collection(collection_params) do
      {:ok, collection} ->
        notify_parent({:saved, collection})

        {:noreply,
         socket
         |> put_flash(:info, "Collection created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp handle_delete_thumbnail_new(thumbnail_path, socket) do
    collection_attrs = Map.put(socket.assigns.form.params, "thumbnail", nil)
    changeset = Catalog.change_collection(%Catalog.Collection{}, collection_attrs)

    delete_thumbnail_file(thumbnail_path)

    socket =
      socket
      |> assign(:collection, %{socket.assigns.collection | thumbnail: nil})
      |> assign(:form, to_form(changeset))
      |> put_flash(:info, "Thumbnail removed")

    {:noreply, socket}
  end

  defp handle_delete_thumbnail_edit(thumbnail_path, socket) do
    collection = socket.assigns.collection

    case Catalog.update_collection(collection, %{thumbnail: nil}) do
      {:ok, updated_collection} ->
        delete_thumbnail_file(thumbnail_path)

        socket =
          socket
          |> assign(:collection, updated_collection)
          |> assign(:form, to_form(Catalog.change_collection(updated_collection, %{})))
          |> put_flash(:info, "Thumbnail deleted successfully")

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(:form, to_form(changeset))
          |> put_flash(:error, "Failed to delete thumbnail")

        {:noreply, socket}
    end
  end

  defp delete_thumbnail_file(nil), do: :ok
  defp delete_thumbnail_file(""), do: :ok

  defp delete_thumbnail_file(thumbnail_path) do
    file_path =
      Path.join([
        :code.priv_dir(:voile),
        "static",
        thumbnail_path
      ])

    if File.exists?(file_path) do
      case File.rm(file_path) do
        :ok ->
          :ok

        {:error, reason} ->
          dbg("Failed to delete thumbnail file: #{reason}")
      end
    else
      :ok
    end
  end

  defp filter_properties(properties, query) when is_binary(query) and query != "" do
    query = String.downcase(query)

    properties
    |> Enum.map(fn {category, props} ->
      filtered_props =
        Enum.filter(props, fn prop ->
          String.contains?(String.downcase(prop.label), query)
        end)

      {category, filtered_props}
    end)
    |> Enum.filter(fn {_category, props} -> length(props) > 0 end)
  end

  defp filter_properties(properties, _query), do: properties

  defp notify_parent(msg),
    do: send(self(), {VoileWeb.Dashboard.Catalog.CollectionLive.FormComponent, msg})
end
