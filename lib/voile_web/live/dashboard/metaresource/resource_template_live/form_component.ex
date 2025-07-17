defmodule VoileWeb.Dashboard.MetaResource.ResourceTemplateLive.FormComponent do
  use VoileWeb, :live_component

  alias Voile.Schema.Metadata

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto px-6 py-12">
      <h1 class="text-2xl font-bold mb-6">{@title}</h1>
      
      <.simple_form
        :let={f}
        for={@form}
        phx-submit="save"
        phx-change="validate"
        phx-target={@myself}
        class="space-y-6"
      >
        <!-- Template Name -->
        <div>
          <.label>Template Name</.label>
          
          <.input
            field={f[:label]}
            type="text"
            label="Label"
            placeholder="e.g., Book Template"
            required_value={true}
          />
          <.input
            field={f[:description]}
            type="textarea"
            label="Description"
            placeholder="Description (optional)"
            required_value={false}
          />
          <.input
            field={f[:resource_class_id]}
            type="select"
            label="Resource Class"
            options={Enum.map(@resource_class, fn res -> {res.label, res.id} end)}
            prompt="Select a resource class"
            required_value={true}
          />
        </div>
        
    <!-- Property Search -->
        <div class="space-y-2">
          <.label>Add Properties</.label>
          
          <div class="relative">
            <input
              type="text"
              name="search"
              placeholder="Search properties..."
              autocomplete="off"
              phx-keyup="search"
              phx-debounce="300"
              phx-target={@myself}
              class="default-input"
            />
            <div :if={@loading} class="absolute right-3 top-2.5">
              <.icon name="hero-arrow-path" class="w-5 h-5 animate-spin" />
            </div>
          </div>
          
    <!-- Search Results -->
          <div class="border rounded max-h-60 overflow-y-auto bg-gray-50">
            <div
              :if={Enum.empty?(@properties) && @search_term != ""}
              class="p-4 text-center text-gray-500"
            >
              <%= case {@loading, @search_term, @properties} do %>
                <% {true, _, _} -> %>
                  Searching for {@search_term}...
                <% {false, term, []} when term != "" -> %>
                  {term} No properties found for "{@search_term}"
                <% {_, _, _} -> %>
                  You can add other properties by searching for them on the search box.
              <% end %>
            </div>
            
            <%= for property <- @properties do %>
              <div
                class="p-3 hover:bg-gray-100 cursor-pointer border-b"
                phx-click="add_property"
                phx-value-id={property.id}
                phx-target={@myself}
              >
                <div class="font-medium">{property.label}</div>
                
                <div class="text-sm text-gray-600">{property.local_name}</div>
              </div>
            <% end %>
          </div>
        </div>
        
    <!-- Selected Properties -->
        <div :if={!Enum.empty?(@selected_properties)} class="space-y-4">
          <.label>Selected Properties</.label>
          
          <div id="selected-properties" class="space-y-3" phx-hook="DragDrop" phx-update="stream">
            <div
              :for={{id, prop} <- @streams.selected_props}
              id={"prop-#{id}"}
              draggable="true"
              class={"p-3 border rounded bg-white flex justify-between items-start gap-4 #{if @dragging == to_string(id), do: "opacity-50"}"}
              phx-dragstart="drag_start"
              phx-value-id={id}
              phx-dragend="drag_end"
              phx-drop="drop"
              phx-target-id={id}
              phx-target={@myself}
            >
              <div class="cursor-move pt-1">
                <.icon name="hero-arrows-pointing-in" class="w-5 h-5 text-gray-400" />
              </div>
              
              <div class="flex-1">
                <div class="font-medium text-gray-900">
                  <%= if is_map(prop) && Map.has_key?(prop, :override_label) do %>
                    {prop.override_label || prop.label}
                  <% else %>
                    {prop.label}
                  <% end %>
                </div>
                
                <div class="text-sm text-gray-300">
                  {prop.local_name}
                </div>
                
                <div class="mt-2">
                  <input
                    type="text"
                    value={if is_map(prop), do: prop[:override_label] || "", else: ""}
                    placeholder="Custom label..."
                    phx-blur="update_label"
                    phx-value-id={id}
                    phx-target={@myself}
                    class="default-input"
                  />
                </div>
              </div>
              
              <button
                type="button"
                class="text-red-500 hover:text-red-700 mt-1"
                phx-click="remove_property"
                phx-value-id={id}
                phx-target={@myself}
              >
                <.icon name="hero-x-mark" class="w-5 h-5" />
              </button>
            </div>
          </div>
        </div>
        
    <!-- Submit Button -->
        <div class="flex gap-4">
          <.button type="submit" phx-disable-with={@submit_text}>
            {@action}
          </.button>
          
          <.link :if={@cancel_path} navigate={@cancel_path} class="btn btn-secondary">
            Cancel
          </.link>
        </div>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{resource_template: resource_template} = assigns, socket) do
    form = to_form(Metadata.change_resource_template(resource_template))

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, form)}
  end

  @impl true
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
      property_map =
        property
        |> Map.from_struct()
        |> Map.take([:id, :label, :local_name, :information, :type_value])
        |> Map.put(:override_label, nil)

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
    send(self(), {:save, params})
    {:noreply, socket}
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
