defmodule VoileWeb.Dashboard.MetaResource.ResourceTemplateLive.Edit do
  use VoileWeb, :live_view_dashboard

  alias Voile.Schema.Metadata

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    resource_template = Metadata.get_resource_template!(id)

    {:ok,
     socket
     |> assign(:resource_template, resource_template)
     |> assign(:page_title, "Edit Resource Template")
     |> assign(:live_action, :edit)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Resource Template")
    |> assign(:resource_template, Metadata.get_resource_template!(id))
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.live_component
      module={VoileWeb.Dashboard.MetaResource.ResourceTemplateLive.FormComponent}
      id={:edit}
      current_user={@current_user}
      resource_template={@resource_template}
      patch={~p"/manage/metaresource/resource_template/#{@resource_template.id}"}
      return_to={~p"/manage/metaresource/resource_template/#{@resource_template.id}"}
    />
    """
  end
end
