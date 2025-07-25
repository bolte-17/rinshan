defmodule RinshanWeb.LeaderboardLive do
  use RinshanWeb, :live_view
  alias Rinshan.Games
  alias Rinshan.Players

  import RinshanWeb.DisplayHelpers

  def mount(_params, _url, socket) do
    yonma_leaderboard = Games.leaderboard(player_count: 4, since: ~U[2025-04-27 00:00:00Z])
    sanma_leaderboard = Games.leaderboard(player_count: 3, since: ~U[2025-04-27 00:00:00Z])
    players = Players.list_players() |> Map.new(&{&1.name, &1})

    socket =
      socket
      |> assign(
        leaderboards: %{sanma: sanma_leaderboard, yonma: yonma_leaderboard},
        players: players
      )

    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.header class="text-center pb-4">2025 Leaderboards</.header>
    <.container max_width="full">
      <.tabs class="grid grid-cols-2 gap-0">
        <.tab
          class="justify-center"
          link_type="live_patch"
          is_active={@live_action == :yonma}
          to={~p"/leaderboard/yonma"}
        >
          四 4-Player
        </.tab>
        <.tab
          class="justify-center"
          link_type="live_patch"
          is_active={@live_action == :sanma}
          to={~p"/leaderboard/sanma"}
        >
          三 3-Player
        </.tab>
      </.tabs>
      <.table id="leaderboard" rows={@leaderboards[@live_action] |> Enum.with_index(1)}>
        <:col :let={{{_, _, _}, i}} class="w-0 px-2" row_class="w-0 px-2">
          <.icon
            :if={i <= 3}
            name="hero-trophy-solid"
            class={
              case i do
                1 -> "text-amber-500"
                2 -> "text-zinc-500"
                3 -> "text-yellow-800"
              end
            }
          />
        </:col>
        <:col :let={{{player_name, _, _}, _}} class="pl-0" row_class="pl-0" label="Name">
          {player_name}
        </:col>
        <:col :let={{{player_name, _, _}, _}} class="text-right" row_class="text-right" label="Rating">
          {display_skill(@players[player_name], @live_action)}
        </:col>
        <:col :let={{{_, score, _}, _}} class="text-right" row_class="text-right" label="Total Score">
          {score}
        </:col>
        <:col :let={{{_, _, rounds}, _}} class="text-right" row_class="text-right" label="Hanchans">
          {rounds}
        </:col>
        <:col
          :let={{{_, score, rounds}, _}}
          class="text-right"
          row_class="text-right"
          label="Avg Score"
        >
          {Float.round(score / rounds, 1)}
        </:col>
      </.table>
    </.container>
    """
  end
end
