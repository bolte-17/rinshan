defmodule Rinshan.Imports.PlayerImporter do
  use Oban.Worker, 
    queue: :imports,
    unique: [
      states: Oban.Job.states() -- [:cancelled, :discarded, :completed]
    ]
  alias Rinshan.Repo
  alias Rinshan.Players
  alias Rinshan.Players.Player

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"sheet_id" => sheet_id, "registry_range" => registry_range}}) do
    with {:ok, pid} <- GSS.Spreadsheet.Supervisor.spreadsheet(sheet_id),
         {:ok, players_import_rows} <- GSS.Spreadsheet.read_rows(pid, [registry_range]) do
      for [name, discord_id | _] <- players_import_rows do
        player_attrs = %{"name" => name, "discord_id" => discord_id}

        case Repo.get_by(Player, discord_id: discord_id) do
          nil ->
            Players.create_player(player_attrs)

          %Player{} = existing_player ->
            Players.update_player(existing_player, player_attrs)
        end
      end

      :ok
    end
  end
end
