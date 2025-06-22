defmodule VoileWeb.Dashboard.Catalog.CollectionLive.FormComponent do
  use VoileWeb, :live_component

  alias Voile.Catalog
  alias Voile.Schema.Master
  alias Voile.Schema.Metadata

  alias Ecto.Changeset

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= if msg = @flash["error"] do %>
        <.flash kind={:error} class="mb-4">{msg}</.flash>
      <% end %>
      
      <%= if msg = @flash["info"] do %>
        <.flash kind={:info} class="mb-4">{msg}</.flash>
      <% end %>
      
      <.modal id="col_field_delete_confirmation">
        <div class="text-center">
          <h5>
            Are you sure want to delete {(@chosen_collection_field && @chosen_collection_field.label) ||
              ""} ?
          </h5>
          
          <p class="text-sm text-gray-500">
            This action cannot be undone. Please confirm your action.
          </p>
          
          <p class="text-sm italic font-semibold text-red-500">
            You will delete this property :
          </p>
          
          <div class="my-4">
            <h6 class="text-brand">
              {(@chosen_collection_field && @chosen_collection_field.label) || ""}
            </h6>
            
            <p class="text-xs">with value :</p>
            
            <h6 class="font-bold text-gray-500">
              {(@chosen_collection_field && @chosen_collection_field.value) || ""}
            </h6>
          </div>
          
          <div class="flex items-center w-full my-5 gap-5">
            <.button
              class="w-full warning-btn"
              phx-click={
                JS.push("delete_existed_field") |> hide_modal("col_field_delete_confirmation")
              }
              phx-value-id={@delete_confirmation_id}
              phx-target={@myself}
            >
              Delete
            </.button>
            
            <.button
              class="w-full"
              phx-click={hide_modal("col_field_delete_confirmation")}
              phx-target={@myself}
            >
              Cancel
            </.button>
          </div>
        </div>
      </.modal>
      
      <.header>
        {@title}
        <:subtitle>Use this form to manage collection records in your database.</:subtitle>
      </.header>
       {@step}
      <.simple_form
        for={@form}
        id="collection-form-1"
        phx-target={@myself}
        phx-change="validate"
        phx-debounce="300"
        phx-submit="save"
      >
        <%= if @step == 1 do %>
          <.input field={@form[:title]} type="text" label="Title" required_value={true} />
          <.input
            type="text"
            name="creator"
            value={
              (@collection.mst_creator && @collection.mst_creator.creator_name) || @creator_input
            }
            label="Creator"
            disabled={@creator_input != "" and @collection.creator_id !== nil}
            required_value={true}
          />
          <%= if @creator_input != "" and @creator_suggestions != [] and @form[:creator_id] != nil and @collection.creator_id == nil do %>
            <ul class="absolute z-10 bg-white border -mt-4 rounded shadow max-h-64 overflow-y-auto max-w-full">
              <%= for creator <- @creator_suggestions do %>
                <li
                  phx-click="select_creator"
                  phx-value-id={creator.id}
                  phx-target={@myself}
                  class="px-4 py-2 hover:bg-gray-100 cursor-pointer"
                >
                  {creator.creator_name}
                </li>
              <% end %>
            </ul>
          <% end %>
          
          <%= if @creator_input != nil and @creator_suggestions == [] and @collection.creator_id == nil do %>
            <.button
              type="button"
              phx-click="create_new_creator"
              phx-value-creator={@creator_input}
              phx-target={@myself}
            >
              Create {@creator_input}
            </.button>
            
            <%= for {_msg, _opts} <- Keyword.get_values(@form.errors, :creator_id) do %>
              <p class="text-red-500 text-sm mt-2">Please choose Creator or click Create!</p>
            <% end %>
          <% end %>
          
          <%= if @collection.creator_id != nil do %>
            <.button phx-click="delete_creator" phx-target={@myself}>
              Delete Author
            </.button>
          <% end %>
          
          <.input
            field={@form[:description]}
            type="textarea"
            label="Description"
            required_value={true}
          />
          <.input
            field={@form[:status]}
            type="select"
            label="Status"
            options={[
              {"Draft", "draft"},
              {"Pending", "pending"},
              {"Published", "published"},
              {"Archived", "archived"}
            ]}
            required_value={true}
          />
          <.input
            field={@form[:access_level]}
            type="select"
            label="Access Level"
            options={[
              {"Public", "public"},
              {"Private", "private"},
              {"Restricted", "restricted"}
            ]}
            required_value={true}
          />
          <.input
            field={@form[:thumbnail]}
            type="text"
            label="Thumbnail"
            disabled="true"
            required_value={true}
          />
          <input
            name={@form[:creator_id].name}
            value={@form[:creator_id].value || @current_user.id}
            type="hidden"
            disabled
          />
          <div class="p-6">
            <%= if @form[:thumbnail].value == nil or @form[:thumbnail].value == "" do %>
              <!-- Upload Area (when no thumbnail) -->
              <div
                class="border-2 border-dashed border-gray-300 rounded-xl p-8 text-center hover:border-blue-400 hover:bg-blue-50 transition-all duration-300 cursor-pointer group"
                phx-drop-target={@uploads.thumbnail.ref}
              >
                <div class="space-y-4">
                  <div class="mx-auto w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center group-hover:bg-blue-200 transition-colors">
                    <svg
                      class="w-8 h-8 text-blue-500"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"
                      >
                      </path>
                    </svg>
                  </div>
                  
                  <div>
                    <p class="text-gray-700 font-medium">Click to upload or drag and drop</p>
                    
                    <p class="text-gray-500 text-sm mt-1">PNG, JPG, GIF up to 10MB</p>
                  </div>
                  
                  <div class="mt-4">
                    <.live_file_input upload={@uploads.thumbnail} class="hidden" />
                    <label
                      for={@uploads.thumbnail.ref}
                      class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-blue-500 to-purple-600 text-white font-medium rounded-lg hover:from-blue-600 hover:to-purple-700 transition-all duration-200 cursor-pointer shadow-lg hover:shadow-xl transform hover:-translate-y-0.5"
                    >
                      <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                        >
                        </path>
                      </svg>
                      Choose File
                    </label>
                  </div>
                </div>
              </div>
            <% end %>
            
            <%= for entry <- @uploads.thumbnail.entries do %>
              <div class="space-y-4">
                <div class="flex items-center space-x-3">
                  <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                    <svg
                      class="w-6 h-6 text-blue-500"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
                      >
                      </path>
                    </svg>
                  </div>
                  
                  <div class="flex-1">
                    <p class="text-gray-700 font-medium text-sm">{entry.client_name}</p>
                    
                    <div class="mt-2 bg-gray-200 rounded-full h-2">
                      <div
                        class="bg-gradient-to-r from-blue-500 to-purple-500 h-2 rounded-full transition-all duration-300"
                        style={"width: #{entry.progress}%"}
                      >
                      </div>
                    </div>
                    
                    <p class="text-gray-500 text-xs mt-1">Uploading... {entry.progress}%</p>
                  </div>
                </div>
              </div>
            <% end %>
            
            <%= if @form[:thumbnail].value != nil and @form[:thumbnail].value != "" do %>
              <div class="space-y-4">
                <div class="relative group w-full max-w-96">
                  <img
                    src={@form[:thumbnail].value}
                    alt="Collection thumbnail"
                    class="w-96 object-cover rounded-xl shadow-md"
                  />
                  <div class="absolute w-96 inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-30 rounded-xl transition-all duration-300 flex items-center justify-center">
                  </div>
                </div>
                
                <div class="flex items-center justify-between w-full max-w-96">
                  <div class="flex items-center space-x-2 text-green-600">
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                      <path
                        fill-rule="evenodd"
                        d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                        clip-rule="evenodd"
                      >
                      </path>
                    </svg>
                     <span class="text-sm font-medium">Thumbnail uploaded</span>
                  </div>
                  
                  <.button
                    type="button"
                    phx-click="delete_thumbnail"
                    phx-value-thumbnail={@form[:thumbnail].value}
                    phx-target={@myself}
                    class="warning-btn"
                    phx-disable-with="Removing..."
                  >
                    <svg
                      class="w-4 h-4 inline mr-1"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                      >
                      </path>
                    </svg>
                    Remove
                  </.button>
                </div>
              </div>
            <% end %>
          </div>
        <% end %>
        
        <%= if @step == 2 do %>
          <div class="flex items-start gap-5">
            <div class="sticky top-0 w-full max-w-72">
              <h5>Collection Properties</h5>
              
              <div class="w-full h-[512px] border border-1 border-violet-100 overflow-y-auto overflow-x-hidden rounded-xl mt-2 p-4">
                <p class="text-xs italic mb-4 max-w-48">
                  You can click each category below and pick any necessary property for your collection.
                </p>
                
                <div>
                  <.input
                    type="text"
                    name="property_search"
                    label="Search Property"
                    value={@property_search}
                    placeholder="Search property..."
                    phx-keyup="search_properties"
                    phx-target={@myself}
                    phx-debounce="300"
                  />
                </div>
                
                <%= if Enum.empty?(@filtered_properties) do %>
                  <p class="text-red-500 text-sm mt-2">No property found.</p>
                <% else %>
                  <%= for {id, props} <- @filtered_properties do %>
                    <div>
                      <h6
                        class="mb-4 border border-1 border-violet-100 rounded-xl p-2 hover:text-brand cursor-pointer transition-all duration-1000"
                        phx-click={
                          JS.toggle(
                            to: "##{id |> String.downcase() |> String.replace(" ", "-")}",
                            in: "block scale-y-100 transition transform duration-300 ease-out",
                            out: "hidden scale-y-0 transition transform duration-300 ease-in",
                            display: "block"
                          )
                        }
                      >
                        {id}
                        <%= if length(props) > 0 do %>
                          (<span class="text-brand">{length(props)}</span>)
                        <% end %>
                      </h6>
                      
                      <div
                        id={id |> String.downcase() |> String.replace(" ", "-")}
                        class={
                          if @property_search != "",
                            do:
                              "block scale-y-100 origin-top overflow-hidden transition-transform duration-300",
                            else:
                              "hidden scale-y-0 origin-top overflow-hidden transition-transform duration-300"
                        }
                      >
                        <div class="flex flex-col gap-3">
                          <%= for prop <- props do %>
                            <button
                              type="button"
                              phx-click="select_props"
                              phx-value-id={prop.id}
                              phx-target={@myself}
                              class="btn text-left hover-btn ml-3"
                            >
                              {prop.label}
                            </button>
                          <% end %>
                        </div>
                      </div>
                    </div>
                  <% end %>
                <% end %>
              </div>
            </div>
            
            <div class="w-full">
              <%= if @form[:collection_fields] == nil or Enum.empty?(@form[:collection_fields].value || []) do %>
                <p class="text-red-500 text-sm mt-2">No collection fields added yet.</p>
              <% else %>
                <div>
                  <.inputs_for :let={col_field} field={@form[:collection_fields]}>
                    <h6 class="bg-violet-200 px-4 py-1 rounded-t-xl text-brand">
                      {col_field[:label].value}
                    </h6>
                    
                    <div class="flex flex-col w-full bg-gray-100 p-4 rounded-b-xl mb-4">
                      <p class="text-gray-500 italic mb-4">{col_field[:information].value}</p>
                      
                      <input
                        type="hidden"
                        name={col_field[:label].name}
                        value={col_field[:label].value}
                      />
                      <input
                        type="hidden"
                        name={col_field[:property_id].name}
                        value={col_field[:property_id].value}
                      /> {col_field[:property_id].value}
                      <input
                        type="hidden"
                        name={col_field[:name].name}
                        value={col_field[:name].value}
                      />
                      <input
                        type="hidden"
                        name={col_field[:sort_order].name}
                        value={col_field[:sort_order].value || col_field.index + 1}
                      />
                      <input
                        type="hidden"
                        name={col_field[:type_value].name}
                        value={col_field[:type_value].value}
                      />
                      <div class="grid grid-cols-5 items-start gap-2 -mt-6">
                        <.input
                          field={col_field[:value_lang]}
                          type="select"
                          label="Language"
                          options={[
                            {"Indonesia", "id"},
                            {"English", "en"}
                          ]}
                        />
                        <div class="col-span-4">
                          <.input
                            field={col_field[:value]}
                            type={col_field[:type_value].value}
                            label="Value"
                          />
                        </div>
                      </div>
                      
                      <div class="w-full flex items-center gap-3 mt-2">
                        <%= if col_field[:id].value != nil do %>
                          <.button
                            type="button"
                            phx-click={
                              JS.push("delete_confirmation")
                              |> show_modal("col_field_delete_confirmation")
                            }
                            phx-target={@myself}
                            phx-value-id={col_field[:id].value}
                            class="warning-btn w-full"
                          >
                            <.icon name="hero-trash-solid" class="w-4 h-4" /> Delete Property
                          </.button>
                        <% else %>
                          <.button
                            type="button"
                            phx-click="delete_unsaved_field"
                            phx-target={@myself}
                            phx-value-index={col_field.index}
                            class="warning-btn w-full"
                          >
                            <.icon name="hero-x-circle-solid" class="w-4 h-4" /> Remove Field
                          </.button>
                        <% end %>
                      </div>
                    </div>
                  </.inputs_for>
                </div>
              <% end %>
            </div>
          </div>
        <% end %>
        
        <:actions>
          <div class="mt-12 w-full flex justify-between items-center gap-5">
            <%= if @step > 1 do %>
              <.button type="button" phx-click="prev_step" phx-target={@myself} class="w-full">
                &leftarrow; Back
              </.button>
            <% end %>
            
            <%= if @step == 2 do %>
              <.button type="submit" phx-disable-with="Saving..." class="success-btn w-full">
                Save
              </.button>
            <% else %>
              <.button type="button" phx-click="next_step" phx-target={@myself} class="w-full">
                Next &rightarrow;
              </.button>
            <% end %>
          </div>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{collection: collection} = assigns, socket) do
    type_options =
      assigns.collection_type
      |> Enum.map(fn type -> {type.label, type.id} end)

    {original_collection, changeset} =
      case assigns.action do
        :edit ->
          # Fetch fresh collection with preloads
          coll = Catalog.get_collection!(collection.id) |> Voile.Repo.preload(:collection_fields)
          {coll, Catalog.change_collection(coll)}

        :new ->
          {nil, Catalog.change_collection(%Catalog.Collection{})}
      end

    seed_source = if assigns.action == :edit, do: original_collection, else: collection

    seed_params =
      (seed_source.collection_fields || [])
      |> Enum.with_index()
      |> Enum.into(%{}, fn {field, idx} ->
        {to_string(idx),
         %{
           "id" => field.id,
           "label" => field.label,
           "information" => nil,
           "type_value" => field.type_value,
           "value_lang" => field.value_lang,
           "value" => field.value,
           "sort_order" => field.sort_order
         }}
      end)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:original_collection, original_collection)
     |> assign(:creator_input, nil)
     |> assign(:creator_list, assigns.creator_list)
     |> assign(:creator_suggestions, [])
     |> assign(:step1_params, nil)
     |> assign(:type_options, type_options)
     |> assign(:uploaded_files, [])
     |> assign(:delete_confirmation_id, nil)
     |> assign(:chosen_collection_field, nil)
     |> assign(:property_search, "")
     |> assign(:filtered_properties, assigns.collection_properties)
     |> allow_upload(:thumbnail,
       accept: ~w(.jpg .jpeg .png .webp),
       max_entries: 1,
       auto_upload: true,
       progress: &handle_progress/3
     )
     |> assign_new(:form, fn ->
       to_form(changeset)
     end)
     |> assign(:form_params, %{"collection_fields" => seed_params})}
  end

  @impl true
  def handle_event(
        "validate",
        %{"collection" => collection_params, "creator" => creator_input},
        socket
      ) do
    suggestions =
      Enum.filter(socket.assigns.creator_list, fn creator ->
        String.contains?(String.downcase(creator.creator_name), String.downcase(creator_input))
      end)

    changeset = Catalog.change_collection(socket.assigns.collection, collection_params)

    socket =
      socket
      |> assign(:creator_input, creator_input)
      |> assign(:creator_suggestions, suggestions)
      |> assign(:form, to_form(changeset, action: :validate))

    {:noreply, socket}
  end

  def handle_event("validate", %{"collection" => collection_params}, socket) do
    changeset =
      socket.assigns.collection
      |> Catalog.change_collection(collection_params)
      |> Map.put(:action, :validate)

    socket =
      socket
      |> assign(:form, to_form(changeset, action: :validate))

    {:noreply, socket}
  end

  def handle_event("validate", %{"property_search" => _value}, socket) do
    # Update assigns or do something with `value`
    {:noreply, socket}
  end

  def handle_event("select_creator", %{"id" => id}, socket) do
    selected =
      Enum.find(socket.assigns.creator_list, fn c -> to_string(c.id) == id end)

    socket =
      socket
      |> assign(:creator_input, selected.creator_name)
      |> assign(:creator_suggestions, [])
      |> assign(:collection, %{
        socket.assigns.collection
        | creator_id: selected.id
      })

    {:noreply, socket}
  end

  def handle_event("create_new_creator", %{"creator" => creator}, socket) do
    case Master.get_or_create_creator(%{creator_name: creator}) do
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

        {:noreply, socket}

      {:error, _} ->
        socket =
          socket
          |> put_flash(:error, "Failed to create new creator.")
          |> assign(:creator_suggestions, [])
          |> assign(:collection, socket.assigns.collection)

        {:noreply, socket}
    end
  end

  def handle_event("delete_creator", _params, socket) do
    socket =
      socket
      |> assign(:creator_input, nil)
      |> assign(:collection, %{socket.assigns.collection | creator_id: nil})

    {:noreply, socket}
  end

  def handle_event("next_step", _params, socket) do
    params = socket.assigns.form.params

    changeset =
      Catalog.change_collection(socket.assigns.collection, params) |> Map.put(:action, :validate)

    if changeset.valid? do
      socket =
        socket
        |> assign(:step, socket.assigns.step + 1)
        |> assign(:collection, Changeset.apply_changes(changeset))
        |> assign(:changeset, changeset)
        |> assign(:step1_params, params)

      {:noreply, socket}
    else
      socket =
        socket
        |> put_flash(:error, "Please fill in all required fields.")
        |> assign(:form, to_form(changeset, action: :validate))

      {:noreply, socket}
    end
  end

  def handle_event("prev_step", _params, socket) do
    socket =
      socket
      |> assign(:step, socket.assigns.step - 1)

    {:noreply, socket}
  end

  def handle_event("select_props", %{"id" => prop_id}, socket) do
    # Retrieve the current form parameters from the socket assigns or initialize an empty map if nil
    params =
      case socket.assigns.form.params do
        nil ->
          socket.assigns.form_params

        _ ->
          Map.update(socket.assigns.form_params, "collection_fields", %{}, fn existing_fields ->
            Map.merge(existing_fields, socket.assigns.form.params["collection_fields"] || %{})
          end)
      end

    # Extract the "collection_fields" map from the parameters, defaulting to an empty map if not present
    raw_fields = Map.get(params, "collection_fields", %{})

    # Convert the map of fields into a list of entries
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

    # Append the new field to the existing list of fields
    updated_list = existing ++ [new_field]

    # Convert the updated list back into a map with sequential keys
    updated_map =
      updated_list
      |> Enum.with_index()
      |> Enum.into(%{}, fn {entry, idx} -> {to_string(idx), entry} end)

    # Update the form parameters with the modified "collection_fields" map
    new_params = Map.put(params, "collection_fields", updated_map)

    # Create a new changeset for the collection using the updated parameters
    changeset = Catalog.change_collection(socket.assigns.collection, new_params)

    socket =
      socket
      |> assign(form: to_form(changeset, action: :validate))

    {:noreply, socket}
  end

  def handle_event("delete_unsaved_field", %{"index" => idx_str}, socket) do
    # Retrieve the current form parameters from the socket assigns or initialize an empty map if nil
    params =
      case socket.assigns.form.params do
        nil ->
          socket.assigns.form_params

        _ ->
          Map.update(socket.assigns.form_params, "collection_fields", %{}, fn existing_fields ->
            Map.merge(existing_fields, socket.assigns.form.params["collection_fields"] || %{})
          end)
      end

    # Extract the "collection_fields" map from the parameters, defaulting to an empty map if not present
    raw_fields = Map.get(params, "collection_fields", %{})

    # Convert the map of fields into a list of entries
    entries = Map.values(raw_fields)

    # Convert the index string from the event parameters to an integer
    idx = String.to_integer(idx_str)

    # Remove the field at the specified index from the list of entries
    new_list = List.delete_at(entries, idx)

    # Convert the updated list back into a map with sequential keys
    new_map =
      new_list
      |> Enum.with_index()
      |> Enum.into(%{}, fn {entry, i} -> {to_string(i), entry} end)

    # Update the form parameters with the modified "collection_fields" map
    new_params = Map.put(params, "collection_fields", new_map)

    # Create a new changeset for the collection using the updated parameters
    changeset = Catalog.change_collection(socket.assigns.collection, new_params)

    # Update the socket assigns with the new form changeset for validation
    {:noreply,
     socket
     |> assign(form: to_form(changeset, action: :validate))}
  end

  def handle_event("delete_existed_field", %{"id" => id}, socket) do
    # Attempt to fetch and delete the collection field
    case Catalog.get_collection_field!(id) do
      nil ->
        :ok

      collection_field ->
        Catalog.delete_collection_field(collection_field)
    end

    # Refresh the collection fields from the database
    updated_collection =
      Catalog.get_collection!(socket.assigns.collection.id)
      |> Voile.Repo.preload(:collection_fields)

    # Update the form parameters with the refreshed collection fields
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

    # Create a new changeset with the updated parameters
    changeset = Catalog.change_collection(updated_collection, new_params)

    # Update the socket assigns with the new form, collection, and form_params
    socket =
      socket
      |> assign(:collection, updated_collection)
      |> assign(:form, to_form(changeset, action: :validate))
      |> assign(:form_params, new_params)

    {:noreply, socket}
  end

  def handle_event("delete_confirmation", %{"id" => id}, socket) do
    # Handle the delete confirmation logic here
    # You can use the id to identify which item to delete
    # For example, you can send a message to the parent LiveView or perform an action directly

    # Notify the parent LiveView about the deletion
    chosen_collection_field =
      Catalog.get_collection_field!(id)

    socket =
      socket
      |> assign(:delete_confirmation_id, id)
      |> assign(:chosen_collection_field, chosen_collection_field)

    {:noreply, socket}
  end

  def handle_event("search_properties", %{"value" => query}, socket) do
    filtered = filter_properties(socket.assigns.collection_properties, query)

    socket =
      socket
      |> assign(:property_search, query)
      |> assign(:filtered_properties, filtered)

    {:noreply, socket}
  end

  def handle_event("save", params, socket) do
    collection = socket.assigns.collection

    collection_params =
      collection
      |> Map.from_struct()
      |> Map.put(:collection_fields, params["collection"]["collection_fields"])

    save_collection(socket, socket.assigns.action, collection_params)
  end

  def handle_event("delete_thumbnail", %{"thumbnail" => thumbnail_path}, socket) do
    action = socket.assigns.action

    uploads = socket.assigns.uploads

    for entry <- uploads.thumbnail.entries do
      cancel_upload(socket, :thumbnail, entry.ref)
    end

    case action do
      :new ->
        handle_delete_thumbnail_new(thumbnail_path, socket)

      :edit ->
        handle_delete_thumbnail_edit(thumbnail_path, socket)

      _ ->
        # Fallback for any other action
        handle_delete_thumbnail_new(thumbnail_path, socket)
        dbg("fall here")
    end
  end

  # Handle thumbnail deletion for new collection (not yet saved to DB)
  defp handle_delete_thumbnail_new(thumbnail_path, socket) do
    # Create fresh changeset without thumbnail
    collection_attrs = Map.put(socket.assigns.form.params, "thumbnail", nil)
    changeset = Catalog.change_collection(%Catalog.Collection{}, collection_attrs)

    # Delete the uploaded file
    delete_thumbnail_file(thumbnail_path)

    # Update socket - no database operation needed
    socket =
      socket
      |> assign(:form, to_form(changeset))
      |> put_flash(:info, "Thumbnail removed")

    {:noreply, socket}
  end

  # Handle thumbnail deletion for existing collection (update DB)
  defp handle_delete_thumbnail_edit(thumbnail_path, socket) do
    collection = socket.assigns.collection

    case Catalog.update_collection(collection, %{thumbnail: nil}) do
      {:ok, updated_collection} ->
        # Delete the physical file after successful DB update
        delete_thumbnail_file(thumbnail_path)

        # Update socket with fresh data
        socket =
          socket
          |> assign(:collection, updated_collection)
          |> assign(:form, to_form(Catalog.change_collection(updated_collection, %{})))
          |> put_flash(:info, "Thumbnail deleted successfully")

        {:noreply, socket}

      {:error, changeset} ->
        # Handle database update error
        socket =
          socket
          |> assign(:form, to_form(changeset))
          |> put_flash(:error, "Failed to delete thumbnail")

        {:noreply, socket}
    end
  end

  defp handle_progress(:thumbnail, entry, socket) do
    dbg(socket.assigns.form.params)

    if entry.done? do
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

      # Update the form field with the uploaded URL
      form_params = Map.put(socket.assigns.form.params || %{}, "thumbnail", url)
      changeset = Catalog.change_collection(socket.assigns.collection, form_params)

      {:noreply,
       socket
       |> assign(:form, to_form(changeset))
       |> assign(:collection, Changeset.apply_changes(changeset))}
    else
      {:noreply, socket}
    end
  end

  defp save_collection(socket, :edit, collection_params) do
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

  defp save_collection(socket, :new, collection_params) do
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

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
  # defp error_to_string(:too_large), do: "Too large"
  # defp error_to_string(:too_many_files), do: "You have selected too many files"
  # defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
