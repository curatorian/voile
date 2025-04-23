defmodule VoileWeb.Utils.SideBarMenuMaster do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    master_menu = master_menu()
    metaresource_menu = metaresource_menu()

    conn
    |> assign(:metaresource_menu, metaresource_menu)
    |> assign(:master_menu, master_menu)
  end

  def on_mount(:master_menu, _params, _session, socket) do
    master_menu = master_menu()
    metaresource_menu = metaresource_menu()

    socket =
      socket
      |> Phoenix.Component.assign(:master_menu, master_menu)
      |> Phoenix.Component.assign(:metaresource_menu, metaresource_menu)

    {:cont, socket}
  end

  defp master_menu do
    [
      %{
        name: "Creator",
        url: "/manage/master/creator"
      },
      %{
        name: "Frequency",
        url: "/manage/master/frequency"
      },
      %{
        name: "Locations",
        url: "/manage/master/locations"
      },
      %{
        name: "Member Type",
        url: "/manage/master/member_type"
      },
      %{
        name: "Places",
        url: "/manage/master/places"
      },
      %{
        name: "Publisher",
        url: "/manage/master/publisher"
      },
      %{
        name: "Topic",
        url: "/manage/master/topic"
      }
    ]
  end

  defp metaresource_menu do
    [
      %{
        name: "Metadata Vocabularies",
        url: "/manage/metaresource/metadata_vocabularies"
      },
      %{
        name: "Metadata Properties",
        url: "/manage/metaresource/metadata_properties"
      },
      %{
        name: "Resource Class",
        url: "/manage/metaresource/resource_class"
      },
      %{
        name: "Resource Template",
        url: "/manage/metaresource/resource_template"
      },
      %{
        name: "Resource Template Property",
        url: "/manage/metaresource/resource_template_property"
      }
    ]
  end
end
