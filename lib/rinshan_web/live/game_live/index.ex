defmodule RinshanWeb.GameLive.Index do
  use RinshanWeb, :live_view

  import RinshanWeb.DisplayHelpers

  alias Rinshan.Games
  alias Rinshan.Games.{Game, Score}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :games, Games.list_games())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Game")
    |> assign(:game, Games.get_game!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Game")
    |> assign(:game, %Game{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Games")
    |> assign(:game, nil)
  end

  @impl true
  def handle_info({RinshanWeb.GameLive.FormComponent, {:saved, game}}, socket) do
    {:noreply, stream_insert(socket, :games, game)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    game = Games.get_game!(id)
    {:ok, _} = Games.delete_game(game)

    {:noreply, stream_delete(socket, :games, game)}
  end

  @impl true
  def handle_event("refresh_games", _, socket) do
    Rinshan.Imports.fetch_all_games()

    {:noreply, socket |> put_flash(:info, "Refreshing games...")}
  end

  defp display_game_mode(%{player_count: player_count, rounds: rounds}) do
    round_term =
      case rounds do
        1 -> "東 East-Only"
        2 -> "南 East-South"
      end

    player_count_str =
      case player_count do
        3 -> "三 3-Player"
        4 -> "四 4-Player"
      end
      

    "#{player_count_str} #{round_term}"
  end

  defp ordinal(i) do
    case i do
      1 -> "1st"
      2 -> "2nd"
      3 -> "3rd"
      4 -> "4th"
    end
  end
end
