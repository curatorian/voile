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
          <%= if @form[:thumbnail].value === nil or @form[:thumbnail].value == "" do %>
            <.live_file_input upload={@uploads.thumbnail} />
          <% end %>
          
          <%= for {_msg, _opts} <- Keyword.get_values(@form.errors, :thumbnail) do %>
            <p class="text-red-500 text-sm mt-2">Thumbnail is mandatory! Please upload thumbnail.</p>
          <% end %>
          
          <%= for entry <- @uploads.thumbnail.entries do %>
            <p class="text-sm text-gray-500 mt-2">
              Uploading {entry.client_name}... {entry.progress}%
            </p>
          <% end %>
          
          <%= if @form[:thumbnail].value != nil and @form[:thumbnail].value != "" do %>
            <div class="flex items-center gap-5">
              <img src={@form[:thumbnail].value} class="h-32 mt-2" />
              <.button
                type="button"
                phx-click="delete_thumbnail"
                phx-target={@myself}
                class="btn bg-red-500 text-white"
                phx-disable-with="Deleting..."
              >
                Delete Thumbnail
              </.button>
            </div>
          <% end %>
        <% end %>
        
        <%= if @step == 2 do %>
          <div class="flex items-start gap-5">
            <div class="sticky top-0">
              <p>Collection Properties</p>
              
              <div class="h-full max-h-[400px] overflow-y-auto overflow-x-hidden rounded p-2">
                <%= for {id, props} <- @collection_properties do %>
                  <div>
                    <h5>{id}</h5>
                    
                    <div class="flex flex-col gap-3">
                      <%= for prop <- props do %>
                        <button
                          type="button"
                          phx-click="select_props"
                          phx-value-id={prop.id}
                          phx-target={@myself}
                          class="btn text-left bg-violet-100 border border-violet-100 text-violet-600 hover:bg-violet-500 hover:text-white transition-all duration-500"
                        >
                          {prop.label}
                        </button>
                      <% end %>
                    </div>
                  </div>
                <% end %>
              </div>
            </div>
            
            <div class="w-full">
              <%= if @form[:collection_fields] == nil or Enum.empty?(@form[:collection_fields].value || []) do %>
                <p class="text-red-500 text-sm mt-2">No collection fields added yet.</p>
              <% else %>
                <div>
                  <.inputs_for :let={col_field} field={@form[:collection_fields]}>
                    <div class="flex flex-col w-full bg-gray-100 p-4 rounded-xl mb-4">
                      <p>{col_field[:label].value}</p>
                      
                      <input
                        type="hidden"
                        name={col_field[:label].name}
                        value={col_field[:label].value}
                      />
                      <input
                        field={col_field[:sort_order].name}
                        value={col_field[:sort_order].value || col_field.index + 1}
                        type="hidden"
                      />
                      <div class="grid grid-cols-5 items-center gap-2">
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
                          <.input field={col_field[:value]} type="text" label="Value" />
                        </div>
                      </div>
                      
                      <.button
                        type="button"
                        phx-click="delete_unsaved_field"
                        phx-target={@myself}
                        phx-value-index={col_field.index}
                      >
                        Remove Field {col_field.index}
                      </.button>
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

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:creator_input, nil)
     |> assign(:creator_list, assigns.creator_list)
     |> assign(:creator_suggestions, [])
     |> assign(:type_options, type_options)
     |> assign(:uploaded_files, [])
     |> allow_upload(:thumbnail,
       accept: ~w(.jpg .jpeg .png .webp),
       max_entries: 1,
       auto_upload: true,
       progress: &handle_progress/3
     )
     |> assign_new(:form, fn ->
       to_form(Catalog.change_collection(collection))
     end)}
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

    dbg(socket.assigns.collection.creator_id)

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
    params = socket.assigns.form.params || %{}

    # Output: params = %{"collection_fields" => %{"0" => %{"id" => "uuid1", "label" => "Field 1"}, "1" => %{"id" => "uuid2", "label" => "Field 2"}}}

    # Extract the "collection_fields" map from the parameters, defaulting to an empty map if not present
    raw_fields = Map.get(params, "collection_fields", %{})

    # Output: raw_fields = %{"0" => %{"id" => "uuid1", "label" => "Field 1"}, "1" => %{"id" => "uuid2", "label" => "Field 2"}}

    # Convert the map of fields into a list of entries
    existing = Map.values(raw_fields)

    # Output: existing = [%{"id" => "uuid1", "label" => "Field 1"}, %{"id" => "uuid2", "label" => "Field 2"}]

    new_field = %{
      "id" => Ecto.UUID.generate(),
      "label" => Metadata.get_property!(prop_id).label,
      "value_lang" => nil,
      "value" => nil,
      "sort_order" => length(existing) + 1
    }

    # Append the new field to the existing list of fields
    updated_list = existing ++ [new_field]

    # Output: updated_list = [%{"id" => "uuid1", "label" => "Field 1"}, %{"id" => "uuid2", "label" => "Field 2"}, %{"id" => "new-uuid", "label" => "New Field Label", "value_lang" => nil, "value" => nil, "sort_order" => 3}]

    # Convert the updated list back into a map with sequential keys
    updated_map =
      updated_list
      |> Enum.with_index()
      |> Enum.into(%{}, fn {entry, idx} -> {to_string(idx), entry} end)

    # Output: updated_map = %{"0" => %{"id" => "uuid1", "label" => "Field 1"}, "1" => %{"id" => "uuid2", "label" => "Field 2"}, "2" => %{"id" => "new-uuid", "label" => "New Field Label", "value_lang" => nil, "value" => nil, "sort_order" => 3}}

    # Update the form parameters with the modified "collection_fields" map
    new_params = Map.put(params, "collection_fields", updated_map)

    # Output: new_params = %{"collection_fields" => %{"0" => %{"id" => "uuid1", "label" => "Field 1"}, "1" => %{"id" => "uuid2", "label" => "Field 2"}, "2" => %{"id" => "new-uuid", "label" => "New Field Label", "value_lang" => nil, "value" => nil, "sort_order" => 3}}}

    # Create a new changeset for the collection using the updated parameters
    changeset = Catalog.change_collection(socket.assigns.collection, new_params)

    # Output: changeset = #Ecto.Changeset<action: :validate, changes: %{collection_fields: [%{"id" => "uuid1", "label" => "Field 1"}, %{"id" => "uuid2", "label" => "Field 2"}, %{"id" => "new-uuid", "label" => "New Field Label", "value_lang" => nil, "value" => nil, "sort_order" => 3}]}, ...>

    socket =
      socket
      |> assign(form: to_form(changeset, action: :validate))

    {:noreply, socket}
  end

  def handle_event("delete_unsaved_field", %{"index" => idx_str}, socket) do
    # Retrieve the current form parameters from the socket assigns or initialize an empty map if nil
    params = socket.assigns.form.params || %{}

    # Output: params = %{"collection_fields" => %{"0" => %{"id" => "uuid1", "label" => "Field 1"}, "1" => %{"id" => "uuid2", "label" => "Field 2"}}}

    # Extract the "collection_fields" map from the parameters, defaulting to an empty map if not present
    raw_fields = Map.get(params, "collection_fields", %{})

    # Output: raw_fields = %{"0" => %{"id" => "uuid1", "label" => "Field 1"}, "1" => %{"id" => "uuid2", "label" => "Field 2"}}

    # Convert the map of fields into a list of entries
    entries = Map.values(raw_fields)

    # Output: entries = [%{"id" => "uuid1", "label" => "Field 1"}, %{"id" => "uuid2", "label" => "Field 2"}]

    # Convert the index string from the event parameters to an integer
    idx = String.to_integer(idx_str)
    # Output: idx = 1

    # Remove the field at the specified index from the list of entries
    new_list = List.delete_at(entries, idx)
    # Output: new_list = [%{"id" => "uuid1", "label" => "Field 1"}]

    # Convert the updated list back into a map with sequential keys
    new_map =
      new_list
      |> Enum.with_index()
      |> Enum.into(%{}, fn {entry, i} -> {to_string(i), entry} end)

    # Output: new_map = %{"0" => %{"id" => "uuid1", "label" => "Field 1"}}

    # Update the form parameters with the modified "collection_fields" map
    new_params = Map.put(params, "collection_fields", new_map)

    # Output: new_params = %{"collection_fields" => %{"0" => %{"id" => "uuid1", "label" => "Field 1"}}}

    # Create a new changeset for the collection using the updated parameters
    changeset = Catalog.change_collection(socket.assigns.collection, new_params)

    # Output: changeset = #Ecto.Changeset<action: :validate, changes: %{collection_fields: [%{"id" => "uuid1", "label" => "Field 1"}]}, ...>

    # Update the socket assigns with the new form changeset for validation
    {:noreply,
     socket
     |> assign(form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", params, socket) do
    collection = socket.assigns.collection

    collection_params =
      collection
      |> Map.from_struct()
      |> Map.put(:collection_fields, params["collection"]["collection_fields"])
      |> Map.drop([:__meta__, :__struct__, :id, :inserted_at, :updated_at])

    save_collection(socket, socket.assigns.action, collection_params)
  end

  def handle_event("delete_thumbnail", _params, socket) do
    # Update the form field to remove the thumbnail URL
    form_params = Map.put(socket.assigns.form.params, "thumbnail", "")

    changeset =
      Catalog.change_collection(%{socket.assigns.collection | thumbnail: nil}, form_params)

    file_path =
      Path.join([
        :code.priv_dir(:voile),
        "static",
        socket.assigns.form.params["thumbnail"]
      ])

    if File.exists?(file_path), do: File.rm(file_path)

    socket =
      socket
      |> assign(:form, to_form(changeset))
      |> assign(:collection, Changeset.apply_changes(changeset))
      |> put_flash(:info, "Thumbnail deleted successfully")

    {:noreply, socket}
  end

  defp handle_progress(:thumbnail, entry, socket) do
    if entry.done? do
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
    case Catalog.update_collection(socket.assigns.collection, collection_params) do
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

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
  # defp error_to_string(:too_large), do: "Too large"
  # defp error_to_string(:too_many_files), do: "You have selected too many files"
  # defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
