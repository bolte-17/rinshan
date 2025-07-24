defmodule Rinshan.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rinshan.Repo
  alias Rinshan.Players.Player

  schema "games" do
    field :player_count, :integer
    field :rounds, :integer
    field :leftover_points, :integer
    field :played_at, :utc_datetime

    has_many :scores, Rinshan.Games.Score
    many_to_many :players, Rinshan.Players.Player, join_through: Rinshan.Games.Score

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:player_count, :rounds, :leftover_points, :played_at])
    |> validate_required([:player_count, :rounds, :leftover_points, :played_at])
  end

  def import_changeset(game, attrs) do
    changeset(game, attrs)
    |> cast_assoc(:scores,
      with: fn data, attrs ->
        changeset = Rinshan.Games.Score.changeset(data, attrs)

        with discord_id when not is_nil(discord_id) <- Map.get(attrs, "player_discord_id") do
          player = 
            case Repo.get_by(Player, discord_id: discord_id) do
              nil -> %Player{name: discord_id, discord_id: discord_id}
              player -> player
            end

          changeset
          |> put_assoc(:player, player)
        else
          x -> 
            IO.inspect(x)
            changeset |> add_error(:player_id, "required")
        end
      end
    )
  end
end
