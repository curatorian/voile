defmodule VoileWeb.Dashboard.Catalog.CollectionLive.FormComponent do
  use VoileWeb, :live_component

  alias Voile.Catalog
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
      <%= if @step == 1 do %>
        <.simple_form
          for={@form}
          id="collection-form-1"
          phx-target={@myself}
          phx-change="validate"
          phx-submit="next_step"
        >
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
          <:actions>
            <.button phx-disable-with="Saving...">Next</.button>
          </:actions>
        </.simple_form>
      <% end %>
      
      <%= if @step == 2 do %>
        <.simple_form
          for={@form}
          id="collection-form-2"
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
        >
          <.inputs_for :let={col_field} field={@form[:collection_fields]}>
            <.input field={col_field[:label]} type="text" label="Label" />
            <.input field={col_field[:name]} type="text" label="Name" />
            <.input field={col_field[:field_type]} type="text" label="Name" />
            <.input field={col_field[:required]} type="checkbox" />
            <.input field={col_field[:sort_order]} type="number" />
          </.inputs_for>
          
          <%!-- <.button phx-click="add_collection_field" phx-target={@myself}>Tambah Field</.button> --%>
          <.button phx-click="prev_step" phx-target={@myself}>Back</.button>
          
          <:actions>
            <.button phx-disable-with="Saving...">Save Collection</.button>
          </:actions>
        </.simple_form>
      <% end %>
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
      socket
      |> put_flash(:info, "Harap isi data dengan benar!")
      |> assign(:form, to_form(changeset))

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
    dbg(socket)
    {:noreply, socket}
  end

  def handle_event("save", %{"collection" => collection_field}, socket) do
    # final_params = Map.merge(Map.from_struct(socket.assigns.collection), collection_params)
    dbg(collection_field)
    dbg(socket.assigns.collection)

    # save_collection(socket, socket.assigns.action, final_params)
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
