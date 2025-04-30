defmodule VoileWeb.Dashboard.Catalog.CollectionLive.FormComponent do
  alias Voile.Catalog.CollectionFieldValue
  use VoileWeb, :live_component

  alias Voile.Catalog
  alias Voile.Catalog.CollectionField
  alias Voile.Repo
  alias Ecto.Changeset
  import Ecto.Query

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
        phx-submit="save"
      >
        <%= if @step == 1 do %>
          <.input field={@form[:title]} type="text" label="Title" />
          <.input field={@form[:description]} type="text" label="Description" />
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
          /> <.input field={@form[:thumbnail]} type="text" label="Thumbnail" />
          <.input field={@form[:access_level]} type="text" label="Access Level" />
        <% end %>
        
        <%= if @step == 2 do %>
          <.inputs_for :let={col_field} field={@form[:collection_fields]}>
            <div class="grid grid-cols-4 gap-2">
              <.input field={col_field[:label]} type="text" label="Label" />
              <.input field={col_field[:name]} type="text" label="Name" />
              <.input field={col_field[:field_type]} type="text" label="Field Type" />
              <.input field={col_field[:sort_order]} type="number" label="Order Sort" />
              <.input field={col_field[:required]} type="checkbox" label="Required" />
            </div>
            <!-- Add input for collection_field_value -->
            <.input field={col_field[:col_field_values]} label="Field Value" />
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
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Catalog.change_collection(collection))
     end)}
  end

  @impl true
  def handle_event("validate", %{"collection" => collection_params}, socket) do
    changeset = Catalog.change_collection(socket.assigns.collection, collection_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("next_step", _params, socket) do
    changeset = Catalog.change_collection(socket.assigns.collection, socket.assigns.form.params)

    if changeset.valid? do
      socket =
        socket
        |> assign(:step, socket.assigns.step + 1)
        |> assign(:collection, Changeset.apply_changes(changeset))
        |> assign(:changeset, changeset)

      dbg(socket)

      {:noreply, socket}
    else
      socket =
        socket
        |> put_flash(:info, "Harap isi data dengan benar!")
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
      |> assign(collection_field_values: %CollectionFieldValue{})
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

  def handle_event("save", _params, socket) do
    collection = socket.assigns.collection

    # Convert nested structs to plain maps for create/update
    collection_params = %{
      "title" => collection.title,
      "description" => collection.description,
      "status" => collection.status,
      "thumbnail" => collection.thumbnail,
      "access_level" => collection.access_level,
      "collection_fields" =>
        Enum.with_index(collection.collection_fields)
        |> Enum.reduce(%{}, fn {field, idx}, acc ->
          Map.put(acc, "#{idx}", %{
            "label" => field.label,
            "name" => field.name,
            "field_type" => field.field_type,
            "sort_order" => field.sort_order,
            "required" => field.required,
            "col_field_values" => field.col_field_values || ""
          })
        end)
    }

    dbg(collection_params)

    save_collection(socket, socket.assigns.action, collection_params)
    {:noreply, socket}
  end

  defp save_collection(socket, action, params) do
    Repo.transaction(fn ->
      case action do
        :new ->
          with {:ok, collection} <- Catalog.create_collection(params) do
            save_collection_fields(params["collection_fields"] || %{}, collection.id)
            {:ok, collection}
          end

        :edit ->
          with {:ok, collection} <- Catalog.update_collection(socket.assigns.collection, params) do
            # Remove old fields if necessary (simpler: delete and re-insert all for now)
            from(cf in CollectionField, where: cf.collection_id == ^collection.id)
            |> Repo.delete_all()

            save_collection_fields(params["collection_fields"] || %{}, collection.id)
            {:ok, collection}
          end
      end
    end)
    |> case do
      {:ok, collection} ->
        notify_parent({:saved, collection})

        {:noreply,
         socket
         |> put_flash(:info, "Collection saved successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}

      {:error, reason} ->
        dbg(reason)
        {:noreply, put_flash(socket, :error, "Failed to save collection")}
    end
  end

  # defp save_collection(socket, :edit, collection_params) do
  #   case Catalog.update_collection(socket.assigns.collection, collection_params) do
  #     {:ok, collection} ->
  #       notify_parent({:saved, collection})

  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Collection updated successfully")
  #        |> push_patch(to: socket.assigns.patch)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, form: to_form(changeset))}
  #   end
  # end

  # defp save_collection(socket, :new, collection_params) do
  #   case Catalog.create_collection(collection_params) do
  #     {:ok, collection} ->
  #       notify_parent({:saved, collection})

  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Collection created successfully")
  #        |> push_patch(to: socket.assigns.patch)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, form: to_form(changeset))}
  #   end
  # end

  defp save_collection_fields(fields_params, collection_id) do
    Enum.each(fields_params, fn {_idx, field_params} ->
      full_field_params = Map.put(field_params, "collection_id", collection_id)

      with {:ok, field} <- Catalog.create_collection_field(full_field_params) do
        (field_params["col_field_values"] || "")
        |> String.split(",", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.each(fn val ->
          CollectionFieldValue.changeset(%CollectionFieldValue{}, %{
            value: val,
            # Adjust locale dynamically if needed
            locale: "en",
            collection_field_id: field.id
          })
          |> Repo.insert!()
        end)
      end
    end)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
