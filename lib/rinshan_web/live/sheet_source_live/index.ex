defmodule RinshanWeb.SheetSourceLive.Index do
  use RinshanWeb, :live_view

  alias Rinshan.Imports
  alias Rinshan.Imports.SheetSource
  import RinshanWeb.Live.SheetSourceLive.Utils

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :sources, Imports.list_sources())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Sheet source")
    |> assign(:sheet_source, Imports.get_sheet_source!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Sheet source")
    |> assign(:sheet_source, %SheetSource{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sources")
    |> assign(:sheet_source, nil)
  end

  @impl true
  def handle_info({RinshanWeb.SheetSourceLive.FormComponent, {:saved, sheet_source}}, socket) do
    {:noreply, stream_insert(socket, :sources, sheet_source)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    sheet_source = Imports.get_sheet_source!(id)
    {:ok, _} = Imports.delete_sheet_source(sheet_source)

    {:noreply, stream_delete(socket, :sources, sheet_source)}
  end
end
