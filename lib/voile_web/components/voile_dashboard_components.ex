defmodule VoileWeb.VoileDashboardComponents do
  use Phoenix.Component
  use Phoenix.LiveComponent

  @doc """
  Navigation Bar Component for GLAM (Gallery, Library, Archive, Museum)

  ## Examples

    <.nav_bar />
  This component need :active menu and :list_menu props.
  """
  attr :active_nav, :string, default: "home"

  attr :list_menu, :list,
    default: [
      %{
        name: "Home",
        url: "/manage/"
      },
      %{
        name: "Master",
        url: "/manage/master"
      },
      %{
        name: "Metadata",
        url: "/manage/metaresource"
      },
      %{
        name: "Settings",
        url: "/users/settings"
      }
    ]

  def nav_bar(assigns) do
    ~H"""
    <div class="w-full bg-white flex items-center my-5 p-5 rounded-lg gap-6">
      <div class="nav-bar-logo">
        <.link patch="/manage">
          <img src="/images/v.png" class="w-10 h-8" alt="GLAM Logo" />
        </.link>
      </div>
      
      <div class="w-full text-blue-500 flex gap-4">
        <%= for menu <- @list_menu do %>
          <.link
            patch={menu.url}
            class={["default-menu", @active_nav |> String.starts_with?(menu.url) && "active-menu"]}
          >
            {menu.name}
          </.link>
        <% end %>
      </div>
      
      <div class="w-full max-w-36">
        <.link href="/" class="default-menu bg-red-400 hover:bg-red-500 text-white">Exit</.link>
        <.link
          href="/users/log_out"
          method="delete"
          class="default-menu bg-red-400 hover:bg-red-500 text-white"
        >
          Log out
        </.link>
      </div>
    </div>
    """
  end

  @doc """
  Component for Side Bar Menu
  """
  attr :active_side, :string, default: "no value"
  attr :menu_name, :string, default: "Sidebar Menu"
  slot :inner_block

  def side_bar_dashboard(assigns) do
    ~H"""
    <section class="bg-white rounded-xl p-5 max-w-64 w-full h-full mr-5">
      <div class="flex flex-col gap-2">
        <h5>{@menu_name}</h5>
         {render_slot(@inner_block)}
      </div>
    </section>
    """
  end
end
