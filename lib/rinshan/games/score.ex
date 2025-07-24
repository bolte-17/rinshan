defmodule Rinshan.Games.Score do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scores" do
    field :points, :integer
    field :chombo, :integer, default: 0

    belongs_to :player, Rinshan.Players.Player
    belongs_to :game, Rinshan.Games.Game
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:points, :chombo])
    |> validate_required([:points, :chombo])
  end
end
