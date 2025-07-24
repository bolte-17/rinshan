defmodule Rinshan.Games.Score do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "scores" do
    field :points, :integer
    field :rank, :integer, virtual: true
    field :chombo, :integer, default: 0
    field :skill_mu, :float
    field :skill_sigma, :float

    belongs_to :player, Rinshan.Players.Player
    belongs_to :game, Rinshan.Games.Game
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:points, :chombo])
    |> validate_required([:points, :chombo])
  end

  def with_rank(query \\ __MODULE__) do
    from score in query,
      select_merge: %{rank: rank() |> over(partition_by: :game_id, order_by: [desc: :points])}
  end

  @umas %{
    4 => [8, 3, -3, -8],
    3 => [8, 0, -8]
  }
  @paybacks %{
    4 => 25000,
    3 => 35000
  }
  @chombo_penalty -10
  def score_with_uma(%__MODULE__{
        points: points,
        rank: rank,
        chombo: chombo,
        game: %{player_count: player_count, rounds: rounds}
      }) do
    Float.round(
      (points - @paybacks[player_count]) / 1000 + chombo * @chombo_penalty +
        Enum.at(@umas[player_count], rank - 1) * rounds,
      1
    )
  end
end
