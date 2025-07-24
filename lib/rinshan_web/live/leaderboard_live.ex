defmodule RinshanWeb.LeaderboardLive do
  use RinshanWeb, :live_view
  alias Rinshan.Games

  def mount(_params, _url, socket) do
    yonma_leaderboard = Games.leaderboard(player_count: 4, since: ~U[2025-04-27 00:00:00Z])
    sanma_leaderboard = Games.leaderboard(player_count: 3, since: ~U[2025-04-27 00:00:00Z])
    {:ok, socket |> assign(leaderboards: %{sanma: sanma_leaderboard, yonma: yonma_leaderboard})}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.tabs class="grid grid-cols-2">
      <.tab
        class="justify-center"
        link_type="live_patch"
        is_active={@live_action == :yonma}
        to={~p"/leaderboard/yonma"}
      >
        4-Player Leaderboard
      </.tab>
      <.tab
        class="justify-center"
        link_type="live_patch"
        is_active={@live_action == :sanma}
        to={~p"/leaderboard/sanma"}
      >
        3-Player Leaderboard
      </.tab>
    </.tabs>
    <.container max_width="full">
      <.core_table id="leaderboard" rows={@leaderboards[@live_action]}>
        <:col :let={{player_name, _, _}} label="Name">{player_name}</:col>
        <:col :let={{_, score, _}} label="Total Score">{score}</:col>
        <:col :let={{_, _, rounds}} label="Hanchans">{rounds}</:col>
        <:col :let={{_, score, rounds}} label="Avg Score">{Float.round(score / rounds, 2)}</:col>
      </.core_table>
    </.container>
    """
  end
end
