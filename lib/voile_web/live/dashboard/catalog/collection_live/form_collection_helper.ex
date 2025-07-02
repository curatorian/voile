defmodule VoileWeb.Dashboard.Catalog.CollectionLive.FormCollectionHelper do
  use VoileWeb, :live_component

  alias Voile.Catalog
  alias Voile.Schema.Master
  alias Voile.Schema.Metadata

  def add_property_to_form(prop_id, socket) do
    params =
      case socket.assigns.form.params do
        nil ->
          socket.assigns.form_params

        _ ->
          Map.update(socket.assigns.form_params, "collection_fields", %{}, fn existing_fields ->
            Map.merge(existing_fields, socket.assigns.form.params["collection_fields"] || %{})
          end)
      end

    raw_fields = Map.get(params, "collection_fields", %{})
    existing = Map.values(raw_fields)

    property = Metadata.get_property!(prop_id)

    new_field = %{
      "label" => property.label,
      "type_value" => property.type_value,
      "information" => property.information,
      "property_id" => property.id,
      "name" => String.split(property.label, " ") |> Enum.join(""),
      "value_lang" => nil,
      "value" => nil,
      "sort_order" => length(existing) + 1
    }

    updated_list = existing ++ [new_field]

    dbg(updated_list)

    updated_map =
      updated_list
      |> Enum.with_index()
      |> Enum.into(%{}, fn {entry, idx} -> {to_string(idx), entry} end)

    new_params = Map.put(params, "collection_fields", updated_map)

    changeset = Catalog.change_collection(socket.assigns.collection, new_params)

    assign(socket, form: to_form(changeset, action: :validate))
  end

  def add_item_to_form(socket) do
    params =
      case socket.assigns.form.params do
        nil ->
          socket.assigns.form_params

        _ ->
          Map.update(socket.assigns.form_params, "items", %{}, fn existing_items ->
            Map.merge(existing_items, socket.assigns.form.params["items"] || %{})
          end)
      end

    raw_items = Map.get(params, "items", %{})
    existing = Map.values(raw_items)

    new_item = %{
      "item_code" => nil,
      "barcode" => nil,
      "location" => nil,
      "status" => nil,
      "condition" => nil,
      "availability" => nil
    }

    updated_list = existing ++ [new_item]

    updated_map =
      updated_list
      |> Enum.with_index()
      |> Enum.into(%{}, fn {entry, idx} -> {to_string(idx), entry} end)

    new_params = Map.put(params, "items", updated_map)

    changeset = Catalog.change_collection(socket.assigns.collection, new_params)

    assign(socket, form: to_form(changeset, action: :validate))
  end

  def assign_selected_creator(id, socket) do
    case Enum.find(socket.assigns.creator_list, fn c -> to_string(c.id) == id end) do
      nil ->
        socket
        |> assign(:creator_input, "")
        |> assign(:creator_suggestions, [])

      selected ->
        socket
        |> assign(:creator_input, selected.creator_name)
        |> assign(:creator_suggestions, [])
        |> assign(:collection, %{
          socket.assigns.collection
          | creator_id: selected.id
        })
    end
  end

  def create_or_select_creator(creator_name, socket) do
    case Master.get_or_create_creator(%{creator_name: creator_name}) do
      {:ok, new_creator} ->
        updated_creator_list = [new_creator | socket.assigns.creator_list]

        socket =
          socket
          |> assign(:creator_input, new_creator.creator_name)
          |> assign(:creator_suggestions, [])
          |> assign(:creator_list, updated_creator_list)
          |> assign(:collection, %{
            socket.assigns.collection
            | creator_id: new_creator.id
          })

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
    params =
      case socket.assigns.form.params do
        nil ->
          socket.assigns.form_params

        _ ->
          Map.update(socket.assigns.form_params, "collection_fields", %{}, fn existing_fields ->
            Map.merge(existing_fields, socket.assigns.form.params["collection_fields"] || %{})
          end)
      end

    raw_fields = Map.get(params, "collection_fields", %{})
    entries = Map.values(raw_fields)
    index = String.to_integer(index_str)

    new_list = List.delete_at(entries, index)

    new_map =
      new_list
      |> Enum.with_index()
      |> Enum.into(%{}, fn {entry, i} -> {to_string(i), entry} end)

    new_params = Map.put(params, "collection_fields", new_map)
    changeset = Catalog.change_collection(socket.assigns.collection, new_params)

    assign(socket, form: to_form(changeset, action: :validate))
  end

  def delete_existing_field(id, socket) do
    # Attempt to fetch and delete the collection field
    case Catalog.get_collection_field!(id) do
      nil -> :ok
      collection_field -> Catalog.delete_collection_field(collection_field)
    end

    # Refresh the collection with preloaded collection_fields
    updated_collection =
      Catalog.get_collection!(socket.assigns.collection.id)
      |> Voile.Repo.preload(:collection_fields)

    # Reconstruct the collection_fields param map
    updated_fields =
      updated_collection.collection_fields
      |> Enum.with_index()
      |> Enum.into(%{}, fn {field, idx} ->
        {to_string(idx),
         %{
           "id" => field.id,
           "label" => field.label,
           "value_lang" => field.value_lang,
           "value" => field.value,
           "sort_order" => field.sort_order
         }}
      end)

    new_params =
      Map.put(socket.assigns.form.params || %{}, "collection_fields", updated_fields)

    changeset = Catalog.change_collection(updated_collection, new_params)

    socket
    |> assign(:collection, updated_collection)
    |> assign(:form, to_form(changeset, action: :validate))
    |> assign(:form_params, new_params)
  end

  def confirm_field_deletion(id, socket) do
    chosen_collection_field = Catalog.get_collection_field!(id)

    socket
    |> assign(:delete_confirmation_id, id)
    |> assign(:chosen_collection_field, chosen_collection_field)
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
      if socket.assigns.form.params["thumbnail"] do
        old_file = Path.basename(socket.assigns.form.params["thumbnail"])
        old_path = Path.join([:code.priv_dir(:voile), "static", "uploads", "thumbnail", old_file])

        if File.exists?(old_path) do
          File.rm!(old_path)
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

          File.cp!(path, dest)
          {:ok, "/uploads/thumbnail/#{Path.basename(dest)}"}
        end)

      form_params = Map.put(socket.assigns.form.params || %{}, "thumbnail", url)
      changeset = Catalog.change_collection(socket.assigns.collection, form_params)

      {:noreply,
       socket
       |> assign(:form, to_form(changeset))
       |> assign(:collection, Ecto.Changeset.apply_changes(changeset))}
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
