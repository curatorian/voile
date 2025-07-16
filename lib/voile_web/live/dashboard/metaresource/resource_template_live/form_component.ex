defmodule VoileWeb.Dashboard.Metaresource.ResourceTemplateLive.FormComponent do
  use VoileWeb, :live_component

  alias Voile.Schema.Metadata

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage resource template records in your database.</:subtitle>
      </.header>
      
      <.simple_form
        for={@form}
        id="resource_template-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.error :if={@form.errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>
         <.input field={@form[:label]} type="text" label="Label" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Resource Template</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{resource_template: resource_template} = assigns, socket) do
    changeset = Metadata.change_resource_template(resource_template)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"resource_template" => resource_template_params}, socket) do
    changeset =
      socket.assigns.resource_template
      |> Metadata.change_resource_template(resource_template_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"resource_template" => resource_template_params}, socket) do
    save_resource_template(socket, socket.assigns.action, resource_template_params)
  end

  defp save_resource_template(socket, :edit, resource_template_params) do
    case Metadata.update_resource_template(
           socket.assigns.resource_template,
           resource_template_params
         ) do
      {:ok, _resource_template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Resource template updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_resource_template(socket, :new, resource_template_params) do
    case Metadata.create_resource_template(resource_template_params) do
      {:ok, _resource_template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Resource template created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
