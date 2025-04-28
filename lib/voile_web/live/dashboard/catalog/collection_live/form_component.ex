defmodule VoileWeb.Dashboard.Catalog.CollectionLive.FormComponent do
  alias Voile.Catalog.CollectionFieldValue
  use VoileWeb, :live_component

  alias Voile.Catalog
  alias Voile.Catalog.CollectionField
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
        phx-submit="next_step"
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
            <.inputs_for :let={col_field_value} field={col_field[:collection_field_values]}>
              <div class="field-value">
                <.input field={col_field_value[:value]} label="Field Value" />
              </div>
            </.inputs_for>
            
            <%= if col_field.data.id do %>
              <.button type="button" phx-click="add_collection_field" phx-target={@myself}>
                Add Field
              </.button>
            <% else %>
              <.button type="button" phx-click="remove_collection_field" phx-target={@myself}>
                Remove Field
              </.button>
            <% end %>
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
          
          <.button phx-disable-with="Saving...">Next</.button>
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

  def handle_event("next_step", %{"collection" => collection_params}, socket) do
    changeset = Catalog.change_collection(socket.assigns.collection, collection_params)

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

  def handle_event("save", %{"collection" => collection_field}, socket) do
    final_params = Map.merge(Map.from_struct(socket.assigns.collection), collection_field)
    dbg(collection_field)
    dbg(socket.assigns.collection)

    save_collection(socket, socket.assigns.action, final_params)
    {:noreply, socket}
  end

  def handle_event("save", %{}, socket) do
    dbg(socket.assigns.collection)

    socket =
      socket
      |> put_flash(:error, "Form tidak valid!")

    {:noreply, socket}
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
end
