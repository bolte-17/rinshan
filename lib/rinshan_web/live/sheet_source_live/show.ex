defmodule RinshanWeb.SheetSourceLive.Show do
  use RinshanWeb, :live_view

  alias Rinshan.Imports
  import RinshanWeb.Live.SheetSourceLive.Utils

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:sheet_source, Imports.get_sheet_source!(id))}
  end

  defp page_title(:show), do: "Show Sheet source"
  defp page_title(:edit), do: "Edit Sheet source"
end
