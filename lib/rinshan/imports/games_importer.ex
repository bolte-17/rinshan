defmodule Rinshan.Imports.GamesImporter do
  use Oban.Worker,
    queue: :imports,
    unique: [
      states: Oban.Job.states() -- [:cancelled, :discarded, :completed]
    ]

  alias Rinshan.Repo
  alias Rinshan.Games.Game

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"sheet_id" => sheet_id, "games_range" => range}}) do
    with {:ok, pid} <- GSS.Spreadsheet.Supervisor.spreadsheet(sheet_id),
         {:ok, games_import_rows} <- GSS.Spreadsheet.read_rows(pid, [range]) do
      Repo.transact(fn ->
        games =
          for row <- games_import_rows do
            game_attrs = parse_game_attrs(row)

            case Repo.all_by(Game, played_at: game_attrs["played_at"]) do
              [existing_game] -> existing_game
              [] -> %Game{}
            end
            |> Game.import_changeset(game_attrs)
            |> Repo.insert!()
          end

        {:ok, games}
      end)
    end
  end

  defp parse_game_attrs(row) do
    row = if length(row) == 15, do: List.insert_at(row, -4, ""), else: row

    [
      timestamp,
      game_mode,
      _irl,
      player_1,
      score_1,
      player_2,
      score_2,
      player_3,
      score_3,
      player_4,
      score_4,
      leftover_points,
      chombo_1,
      chombo_2,
      chombo_3,
      chombo_4
    ] = row

    [players_count_str, game_length_str] = String.split(game_mode)

    player_count =
      case players_count_str do
        "Sanma" -> 3
        "Yonma" -> 4
      end

    rounds =
      case game_length_str do
        "Hanchan" -> 2
        "Tonpuu" -> 1
      end

    %{
      "player_count" => player_count,
      "rounds" => rounds,
      "played_at" => timestamp,
      "leftover_points" => leftover_points,
      "scores" =>
        [
          %{
            "player_discord_id" => player_1,
            "points" => score_1,
            "chombo" => chombo_1
          },
          %{
            "player_discord_id" => player_2,
            "points" => score_2,
            "chombo" => chombo_2
          },
          %{
            "player_discord_id" => player_3,
            "points" => score_3,
            "chombo" => chombo_3
          },
          %{
            "player_discord_id" => player_4,
            "points" => score_4,
            "chombo" => chombo_4
          }
        ]
        |> Enum.take(player_count)
    }
  end
end
