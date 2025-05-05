defmodule VoileWeb.Dashboard.Catalog.CollectionLive.FormComponent do
  use VoileWeb, :live_component

  alias Voile.Catalog
  alias Voile.Catalog.CollectionField
  alias Voile.Schema.Master

  alias Ecto.Changeset

  @impl true
  def render(assigns) do
    ~H"""
    <div>
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
          <.input field={@form[:title]} type="text" label="Title" />
          <.input type="text" name="creator" value={@creator_input} label="Creator" />
          <%= if @creator_input != "" and @creator_suggestions != [] and @form[:creator_id] != nil and @collection.creator_id == nil do %>
            <ul class="absolute z-10 bg-white border -mt-6 rounded shadow h-full max-h-64 overflow-y-auto max-w-full">
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
          <% end %>
          
          <%= if @collection.creator_id != nil do %>
            <.button phx-click="delete_creator" phx-target={@myself}>
              Delete Author
            </.button>
          <% end %>
           <.input field={@form[:description]} type="textarea" label="Description" />
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
          /> <.input field={@form[:thumbnail]} type="text" label="Thumbnail" disabled="true" />
          <%= if @form[:thumbnail].value === nil or @form[:thumbnail].value == "" do %>
            <.live_file_input upload={@uploads.thumbnail} />
          <% end %>
          
          <%= for entry <- @uploads.thumbnail.entries do %>
            <p class="text-sm text-gray-500 mt-2">
              Uploading {entry.client_name}... {entry.progress}%
            </p>
          <% end %>
          
          <%= if @form[:thumbnail].value != nil and @form[:thumbnail].value != "" do %>
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
          <% end %>
        <% end %>
        
        <%= if @step == 2 do %>
          <.inputs_for :let={col_field} field={@form[:collection_fields]}>
            <div class="grid grid-cols-4 gap-2">
              <.input field={col_field[:label]} type="text" label="Label" />
              <.input field={col_field[:name]} type="text" label="Name" />
              <.input field={col_field[:value]} type="text" label="Value" />
              <.input field={col_field[:value_lang]} type="text" label="Language" />
              <.input
                field={col_field[:sort_order]}
                value={col_field[:sort_order].value || col_field.index + 1}
                type="number"
                label="Order Sort"
              />
            </div>
            
            <.button
              type="button"
              phx-click="delete_unsaved_field"
              phx-target={@myself}
              phx-value-index={col_field.index}
            >
              Remove Field {col_field.index}
            </.button>
          </.inputs_for>
          
          <%= if @show_add_collection_field do %>
            <.button type="button" phx-click="add_collection_field" phx-target={@myself}>
              Add Field
            </.button>
          <% end %>
        <% end %>
        
        <:actions>
          <%= if @step > 1 do %>
            <.button type="button" phx-click="prev_step" phx-target={@myself}>Back</.button>
          <% end %>
          
          <%= if @step == 2 do %>
            <.button type="submit" phx-disable-with="Saving...">
              Save
            </.button>
          <% else %>
            <.button type="button" phx-click="next_step" phx-target={@myself}>Next</.button>
          <% end %>
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

    dbg(changeset)

    socket =
      socket
      |> assign(:creator_input, creator_input)
      |> assign(:creator_suggestions, suggestions)
      |> assign(:form, to_form(changeset, action: :validate))

    {:noreply, socket}
  end

  def handle_event("validate", _params, socket) do
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

  def handle_event("add_collection_field", _params, socket) do
    collection_params = socket.assigns.form.params
    changeset = Catalog.change_collection(socket.assigns.collection, collection_params)

    updated_collection = Changeset.apply_changes(changeset)

    updated_collection = %{
      updated_collection
      | collection_fields:
          updated_collection.collection_fields ++ [%CollectionField{id: Ecto.UUID.generate()}]
    }

    new_changeset = Catalog.change_collection(updated_collection)

    socket =
      socket
      |> assign(collection: updated_collection)
      |> assign(form: to_form(new_changeset))

    {:noreply, socket}
  end

  def handle_event("delete_unsaved_field", %{"index" => index_str}, socket) do
    index = String.to_integer(index_str)

    # 1. Get current user-typed form values
    collection_params = socket.assigns.form.params

    # 2. Start with the changeset using current user input
    changeset = Catalog.change_collection(socket.assigns.collection, collection_params)

    # 3. Apply the changes so we can work with up-to-date data
    updated_collection = Ecto.Changeset.apply_changes(changeset)

    # 4. Remove the field at index
    updated_collection_fields =
      List.delete_at(updated_collection.collection_fields, index)

    # 5. Replace fields in struct
    updated_collection = %{updated_collection | collection_fields: updated_collection_fields}

    # 6. Rebuild the changeset and reapply the old form params to preserve user input
    new_changeset =
      updated_collection
      |> Catalog.change_collection()
      |> Map.put(:params, collection_params)

    # 7. Assign everything back
    socket =
      socket
      |> assign(collection: updated_collection)
      |> assign(form: to_form(new_changeset))

    {:noreply, socket}
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
    dbg(collection_params)

    case Catalog.create_collection(collection_params) do
      {:ok, collection} ->
        notify_parent({:saved, collection})

        {:noreply,
         socket
         |> put_flash(:info, "Collection created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        dbg(changeset)
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
  # defp error_to_string(:too_large), do: "Too large"
  # defp error_to_string(:too_many_files), do: "You have selected too many files"
  # defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
