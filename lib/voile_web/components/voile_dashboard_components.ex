defmodule VoileWeb.VoileDashboardComponents do
  use Phoenix.Component
  use Phoenix.LiveComponent
  use Gettext, backend: VoileWeb.Gettext

  alias Phoenix.LiveView.JS

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
        name: "Katalog",
        url: "/manage/catalog"
      },
      %{
        name: "Sirkulasi",
        url: "/manage/circulation"
      },
      %{
        name: "Pengaturan",
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
          
          <p>Data Koleksi bisa kamu cek disini</p>
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

  @doc """
  Renders a collection modal.

  ## Examples

      <.collection_modal id="confirm-modal">
        This is a collection modal.
      </.collection_modal>

  JS commands may be passed to the `:on_cancel` to configure
  the closing/cancel event, for example:

      <.collection_modal id="confirm" on_cancel={JS.navigate(~p"/posts")}>
        This is another collection modal.
      </.collection_modal>

  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def collection_modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_collection_modal(@id)}
      phx-remove={hide_collection_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden"
    >
      <div id={"#{@id}-bg"} class="bg-zinc-50/90 fixed inset-0 transition-opacity" aria-hidden="true" />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex w-full h-full items-center justify-center">
          <div class="w-full h-full p-1">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
              phx-key="escape"
              phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
              class="shadow-zinc-700/10 min-h-full ring-zinc-700/10 relative hidden rounded-2xl bg-white p-14 shadow-lg ring-1 transition"
            >
              <div class="absolute top-6 right-5">
                <button
                  phx-click={JS.exec("data-cancel", to: "##{@id}")}
                  type="button"
                  class="-m-3 flex-none p-3 opacity-40 hover:opacity-60"
                  aria-label={gettext("close")}
                >
                  <.icon name="hero-x-mark-solid" class="h-5 w-5" />
                </button>
              </div>
              
              <div id={"#{@id}-content"}>
                {render_slot(@inner_block)}
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def collection_show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      time: 300,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def collection_hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show_collection_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      time: 300,
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> collection_show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_collection_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> collection_hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end
end
