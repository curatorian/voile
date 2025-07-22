defmodule VoileWeb.Dashboard.MetaResource.ResourceTemplateLive.Edit do
  use VoileWeb, :live_view_dashboard

  alias Voile.Schema.Metadata

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    resource_template = get_resource_template_with_properties(id)
    changeset = Metadata.change_resource_template(resource_template)
    resource_class = Metadata.list_resource_class()

    # Convert existing template properties to the format used by the form
    selected_properties = build_selected_properties(resource_template.template_properties)

    socket =
      socket
      |> assign(:resource_template, resource_template)
      |> assign(:form, to_form(changeset))
      |> assign(:resource_class, resource_class)
      |> assign(:properties, [])
      |> assign(:selected_properties, selected_properties)
      |> assign(:search_term, "")
      |> assign(:loading, false)
      |> assign(:dragging, nil)
      |> assign(:original_template_properties, resource_template.template_properties)
      |> stream(:selected_props, selected_properties)
      |> assign(:initial_values, build_initial_values(selected_properties))

    {:ok, socket}
  end

  def handle_event("validate", params, socket) do
    changeset = Metadata.change_resource_template(socket.assigns.resource_template, params)
    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  @impl true
  def handle_event("search", %{"key" => _key, "value" => value}, socket) do
    handle_search(value, socket)
  end

  def handle_event("search", %{"value" => value}, socket) do
    handle_search(value, socket)
  end

  @impl true
  def handle_event("add_property", %{"id" => id}, socket) do
    property = find_property(socket.assigns.properties, id)

    if property && !property_selected?(socket.assigns.selected_properties, id) do
      next_position = length(socket.assigns.selected_properties) + 1

      property_map =
        property
        |> Map.from_struct()
        |> Map.take([:id, :label, :local_name, :information, :type_value])
        |> Map.put(:override_label, nil)
        |> Map.put(:position, next_position)
        |> Map.put(:template_property_id, nil)

      selected = socket.assigns.selected_properties ++ [property_map]
      initial_values = Map.put(socket.assigns.initial_values, property.id, nil)

      socket =
        socket
        |> assign(:selected_properties, selected)
        |> assign(:initial_values, initial_values)
        |> assign(:search_term, "")
        |> assign(:properties, [])
        |> assign(:loading, false)
        |> rebuild_stream(selected)

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("remove_property", %{"id" => id}, socket) do
    [_id_prefix, id_str] = String.split(id, "-")
    id_int = String.to_integer(id_str)
    selected = Enum.reject(socket.assigns.selected_properties, &(&1.id == id_int))

    socket =
      socket
      |> assign(:selected_properties, selected)
      |> rebuild_stream(selected)

    {:noreply, socket}
  end

  @impl true
  def handle_event("update_label", %{"id" => id, "value" => value}, socket) do
    [_id_prefix, id_str] = String.split(id, "-")
    id_int = String.to_integer(id_str)

    initial_value = socket.assigns.initial_values[id_int]

    if initial_value != value do
      # Update the selected_properties list
      selected =
        Enum.map(socket.assigns.selected_properties, fn
          prop when prop.id == id_int ->
            Map.put(prop, :override_label, value)

          prop ->
            prop
        end)

      socket =
        socket
        |> assign(:selected_properties, selected)
        |> rebuild_stream(selected)

      {:noreply, socket}
    else
      # If the value is the same as the initial value, do nothing
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("save", params, socket) do
    IO.inspect(socket.assigns.selected_properties, label: "Selected properties before save")

    template_properties = build_template_properties(socket.assigns.selected_properties)
    IO.inspect(template_properties, label: "Built template properties")

    template_params = %{
      label: params["label"],
      description: params["description"],
      resource_class_id: params["resource_class_id"],
      template_properties: build_template_properties(socket.assigns.selected_properties)
    }

    case Metadata.update_resource_template(socket.assigns.resource_template, template_params) do
      {:ok, template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Template updated successfully!")
         |> redirect(to: ~p"/manage/metaresource/resource_template/#{template.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  @impl true
  def handle_event("drag_start", %{"id" => id}, socket) do
    IO.inspect(id, label: "Drag start ID")
    {:noreply, assign(socket, :dragging, id)}
  end

  @impl true
  def handle_event("drag_end", _params, socket) do
    IO.inspect("Drag end")
    {:noreply, assign(socket, :dragging, nil)}
  end

  @impl true
  def handle_event("drop", %{"target_id" => target_id}, socket) do
    dragging_id = socket.assigns.dragging

    IO.inspect(dragging_id, label: "Dragging ID")
    IO.inspect(target_id, label: "Target ID")
    IO.inspect(socket.assigns.selected_properties, label: "Before reorder")

    if dragging_id && dragging_id != target_id do
      selected = reorder_properties(socket.assigns.selected_properties, dragging_id, target_id)

      IO.inspect(selected, label: "After reorder")

      socket =
        socket
        |> assign(:selected_properties, selected)
        # Changed: rebuild stream to reflect new order
        |> rebuild_stream(selected)

      {:noreply, socket}
    else
      IO.inspect("No reordering - same ID or nil dragging_id")
      {:noreply, socket}
    end
  end

  @impl true
  def handle_async(:search_properties, {:ok, properties}, socket) do
    {:noreply,
     socket
     |> assign(:properties, properties)
     |> assign(:loading, false)}
  end

  def handle_async(:search_properties, {:exit, reason}, socket) do
    IO.puts("Search failed: #{inspect(reason)}")
    {:noreply, assign(socket, :loading, false)}
  end

  defp rebuild_stream(socket, selected_properties) do
    # Clear the stream and rebuild it with correct order
    socket
    |> stream(:selected_props, [], reset: true)
    |> then(fn socket ->
      Enum.reduce(selected_properties, socket, fn prop, acc_socket ->
        stream_insert(acc_socket, :selected_props, prop)
      end)
    end)
  end

  defp get_resource_template_with_properties(id) do
    Metadata.get_resource_template!(id)
    |> Voile.Repo.preload([
      :resource_class,
      template_properties: [:property]
    ])
  end

  defp build_selected_properties(template_properties) do
    template_properties
    |> Enum.sort_by(& &1.position)
    |> Enum.map(fn tp ->
      %{
        id: tp.property.id,
        template_property_id: tp.id,
        label: tp.property.label,
        local_name: tp.property.local_name,
        information: tp.property.information,
        type_value: tp.property.type_value,
        override_label: tp.override_label,
        position: tp.position
      }
    end)
  end

  defp build_initial_values(selected_properties) do
    Enum.reduce(selected_properties, %{}, fn prop, acc ->
      Map.put(acc, prop.id, prop.override_label)
    end)
  end

  defp handle_search(term, socket) do
    if String.length(term) >= 2 do
      {:noreply,
       socket
       |> assign(:search_term, term)
       |> assign(:loading, true)
       |> start_async(:search_properties, fn -> search_properties(term) end)}
    else
      {:noreply,
       socket
       |> assign(:properties, [])}
    end
  end

  defp search_properties(term) do
    Metadata.search_property(term)
  end

  defp find_property(properties, id) do
    id_int = String.to_integer(id)
    Enum.find(properties, &(&1.id == id_int))
  end

  defp property_selected?(selected, id) do
    id_int = String.to_integer(id)
    Enum.any?(selected, &(&1.id == id_int))
  end

  defp build_template_properties(selected_properties) do
    selected_properties
    |> Enum.map(fn property ->
      base_attrs = %{
        position: property.position,
        property_id: property.id,
        override_label: property.override_label
      }

      # Include ID for existing records so Ecto knows to update them
      case property.template_property_id do
        nil ->
          # New property - no ID, Ecto will create it
          base_attrs

        template_property_id ->
          # Existing property - include ID so Ecto will update it
          Map.put(base_attrs, :id, template_property_id)
      end
    end)
  end

  defp reorder_properties(properties, dragging_id, target_id) do
    IO.inspect({dragging_id, target_id}, label: "Raw IDs")

    dragging_id =
      case String.contains?(dragging_id, "-") do
        true ->
          [_prefix, id_str] = String.split(dragging_id, "-")
          String.to_integer(id_str)

        false ->
          String.to_integer(dragging_id)
      end

    target_id =
      case String.contains?(target_id, "-") do
        true ->
          [_prefix, id_str] = String.split(target_id, "-")
          String.to_integer(id_str)

        false ->
          String.to_integer(target_id)
      end

    IO.inspect({dragging_id, target_id}, label: "Parsed IDs")
    dragging_index = Enum.find_index(properties, &(&1.id == dragging_id))
    target_index = Enum.find_index(properties, &(&1.id == target_id))

    IO.inspect({dragging_index, target_index}, label: "Found indices")

    reordered_properties =
      case {dragging_index, target_index} do
        {nil, _} ->
          properties

        {_, nil} ->
          properties

        {same, same} ->
          properties

        {drag_idx, target_idx} ->
          # Remove the dragging item
          {dragging_item, remaining} = List.pop_at(properties, drag_idx)
          # Calculate new target index (adjust for removed item)
          new_target_idx = if drag_idx < target_idx, do: target_idx - 1, else: target_idx
          # Insert the dragging item at the new position
          List.insert_at(remaining, new_target_idx, dragging_item)
      end

    # Reassign positions based on the new order
    final_result =
      reordered_properties
      |> Enum.with_index(1)
      |> Enum.map(fn {property, new_position} ->
        Map.put(property, :position, new_position)
      end)

    IO.inspect(final_result, label: "Final reordered result")
    final_result
  end
end
