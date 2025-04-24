defmodule VoileWeb.VoileDashboardComponents do
  use Phoenix.Component
  use Phoenix.LiveComponent

  import VoileWeb.CoreComponents, only: [icon: 1]

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
        name: "Catalog",
        url: "/manage/catalog"
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
        <.link patch="/manage#">
          <img src="/images/v.png" class="w-10 h-8" alt="Voile Logo" />
        </.link>
      </div>
      
      <div class="w-full text-blue-500 flex gap-4">
        <.link patch="/manage" class={["default-menu", @active_nav == "/manage" && "active-menu"]}>
          Dashboard
        </.link>
        
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
  slot :inner_block

  def side_bar_dashboard(assigns) do
    ~H"""
    <section class="bg-white rounded-xl p-5 max-w-64 w-full h-full mr-5">
      <div class="flex flex-col gap-2">
        {render_slot(@inner_block)}
      </div>
    </section>
    """
  end

  attr :active_menu, :string, default: ""

  def dashboard_menu_bar(assigns) do
    ~H"""
    <div class="bg-white rounded-xl p-5 w-full h-full flex items-center justify-between">
      <div class="flex flex-col items-start justify-between gap-10 w-full">
        <div>
          <h5>Halo, Admin!</h5>
          
          <p>Data Katalog bisa kamu cek disini</p>
        </div>
        
        <div class="flex gap-2">
          <.link
            patch="/manage/catalog/collections"
            class={[
              "dashboard-menu-btn",
              @active_menu |> String.starts_with?("/manage/catalog/collections") &&
                "dashboard-menu-btn-active"
            ]}
          >
            Collections
          </.link>
          
          <.link
            patch="/manage/catalog/items"
            class={[
              "dashboard-menu-btn",
              @active_menu |> String.starts_with?("/manage/catalog/items") &&
                "dashboard-menu-btn-active"
            ]}
          >
            Items
          </.link>
        </div>
      </div>
      
      <div>
        <.icon name="hero-document-magnifying-glass" class="w-32 h-32 voile-gradient" />
      </div>
    </div>
    """
  end
end
