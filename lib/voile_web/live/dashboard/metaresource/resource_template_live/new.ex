defmodule VoileWeb.Dashboard.MetaResource.ResourceTemplateLive.New do
  use VoileWeb, :live_view_dashboard

  alias Voile.Schema.Metadata
  alias Voile.Schema.Metadata.ResourceTemplate

  @impl true
  def mount(_params, _session, socket) do
    changeset = Metadata.change_resource_template(%ResourceTemplate{})
    resource_class = Metadata.list_resource_class()

    socket =
      socket
      |> assign(:form, to_form(changeset))
      |> assign(:resource_class, resource_class)
      |> assign(:properties, [])
      |> assign(:selected_properties, [])
      |> assign(:search_term, "")
      |> assign(:loading, false)
      |> assign(:dragging, nil)
      |> stream(:selected_props, [])
      |> assign(:initial_values, %{})

    {:ok, socket}
  end

  def handle_event("validate", params, socket) do
    changeset = Metadata.change_resource_template(%ResourceTemplate{}, params)
    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  @impl true
  def handle_event("search", %{"key" => _key, "value" => value}, socket) do
    dbg(socket.assigns.form.params)
    handle_search(value, socket)
  end

  def handle_event("search", %{"value" => value}, socket) do
    dbg(socket.assigns.form.params)
    handle_search(value, socket)
  end

  @impl true
  def handle_event("add_property", %{"id" => id}, socket) do
    property = find_property(socket.assigns.properties, id)

    if property && !property_selected?(socket.assigns.selected_properties, id) do
      property_map =
        property
        |> Map.from_struct()
        |> Map.take([:id, :label, :local_name, :information, :type_value])
        |> Map.put(:override_label, property.label)

      selected = [property_map | socket.assigns.selected_properties]
      initial_values = Map.put(socket.assigns.initial_values, property.id, nil)

      socket =
        socket
        |> assign(:selected_properties, selected)
        |> assign(:initial_values, initial_values)
        |> assign(:search_term, "")
        |> assign(:properties, [])
        |> assign(:loading, false)
        |> stream_insert(:selected_props, property_map)

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
      |> stream_delete(:selected_props, id)

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

      # Find the property to update in the stream
      property = Enum.find(socket.assigns.selected_properties, &(&1.id == id_int))

      # Only update stream if property exists
      socket =
        if property do
          updated_prop = %{
            id: property.id,
            label: property.label,
            local_name: property.local_name,
            override_label: value
          }

          socket
          |> assign(:selected_properties, selected)
          |> stream_insert(:selected_props, updated_prop)
        else
          assign(socket, :selected_properties, selected)
        end

      {:noreply, socket}
    else
      # If the value is the same as the initial value, do nothing
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("save", params, socket) do
    template_params = %{
      label: params["label"],
      description: params["description"],
      owner_id: socket.assigns.current_user.id,
      resource_class_id: params["resource_class_id"],
      template_properties: build_template_properties(socket.assigns.selected_properties)
    }

    case Metadata.create_resource_template(template_params) do
      {:ok, template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Template created successfully!")
         |> redirect(to: ~p"/manage/metaresource/resource_template/#{template.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        dbg(changeset)
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  @impl true
  def handle_event("drag_start", %{"id" => id}, socket) do
    {:noreply, assign(socket, :dragging, id)}
  end

  @impl true
  def handle_event("drag_end", _params, socket) do
    {:noreply, assign(socket, :dragging, nil)}
  end

  @impl true
  def handle_event("drop", %{"target_id" => target_id}, socket) do
    dragging_id = socket.assigns.dragging

    if dragging_id && dragging_id != target_id do
      selected = reorder_properties(socket.assigns.selected_properties, dragging_id, target_id)
      {:noreply, assign(socket, :selected_properties, selected)}
    else
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

  defp build_template_properties(selected) do
    Enum.with_index(selected, 1)
    |> Enum.map(fn {property, idx} ->
      %{
        position: idx,
        property_id: property.id,
        override_label: property.override_label
      }
    end)
  end

  defp reorder_properties(properties, dragging_id, target_id) do
    dragging_id = String.to_integer(dragging_id)
    target_id = String.to_integer(target_id)

    {dragging, others} = Enum.split_with(properties, &(&1.id == dragging_id))

    if Enum.empty?(dragging) do
      properties
    else
      dragging_prop = hd(dragging)

      {before_list, after_list} = Enum.split_while(others, &(&1.id != target_id))

      if Enum.empty?(after_list) do
        # Target not found, append to end
        others ++ dragging
      else
        [target | rest] = after_list
        before_list ++ [target, dragging_prop] ++ rest
      end
    end
  end
end
