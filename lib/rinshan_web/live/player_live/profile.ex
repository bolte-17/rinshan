defmodule RinshanWeb.PlayerLive.Profile do
  use RinshanWeb, :live_view

  alias Rinshan.Players

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    player_form =
      (user.player || Ecto.build_assoc(user, :player)) |> Players.change_player() |> to_form()

    socket = socket |> assign(:player_form, player_form)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
      <.header class="text-center">
        Player Profile
        <:subtitle>Manage how you appear on the leaderboard</:subtitle>
      </.header>
      <div class="space-y-12 divide-y">
        <div>
          <.simple_form
            for={@player_form}
            id="player_form"
            phx-submit="upsert_player"
          >
            <.input field={@player_form[:name]} label="Display Name" required />
            <.input
              field={@player_form[:discord_id]}
              label="Discord ID"
            />
            <:actions>
              <.button phx-disable-with="Changing...">Update Profile</.button>
            </:actions>
          </.simple_form>
        </div>
      </div>
    """
  end
  
  @impl true
  def handle_event("upsert_player", params, socket) do
    user = socket.assigns.current_user

    case Players.update_user_player(user, put_in(params, ["player", "id"], user.player && user.player.id)) do
      {:ok, %{player: player}} ->
        player_form =
          player
          |> Players.change_player()
          |> to_form()

        {:noreply,
         socket
         |> put_flash(:info, "Player profile updated")
         |> assign(player_form: player_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, player_form: to_form(changeset))}
    end
  end
end
