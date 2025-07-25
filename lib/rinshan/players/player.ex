defmodule Rinshan.Players.Player do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Rinshan.Games.{Game, Score}

  schema "players" do
    field :name, :string
    field :discord_id, :string
    field :discord_uid, :integer
    field :paid_through, :date

    field :sanma_rating_sigma, :float, virtual: true
    field :sanma_rating_mu, :float, virtual: true
    field :yonma_rating_sigma, :float, virtual: true
    field :yonma_rating_mu, :float, virtual: true

    has_one :user, Rinshan.Accounts.User
    has_many :scores, Score
    many_to_many :games, Game, join_through: Score

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :discord_id, :discord_uid, :paid_through])
    |> validate_required([:name])
  end

  def ratings(query \\ __MODULE__) do
    last_score =
      from score in Score,
        join: game in assoc(score, :game),
        as: :game,
        where: parent_as(:player).id == score.player_id,
        order_by: [desc: game.played_at],
        select: [:player_id, :skill_sigma, :skill_mu],
        limit: 1

    sanma_rating_subquery = last_score |> where([game: g], g.player_count == 3)
    yonma_rating_subquery = last_score |> where([game: g], g.player_count == 4)

    from player in query,
      as: :player,
      left_lateral_join: sanma_rating in subquery(sanma_rating_subquery),
      left_lateral_join: yonma_rating in subquery(yonma_rating_subquery),
      select_merge: %{
        sanma_rating_sigma: sanma_rating.skill_sigma,
        sanma_rating_mu: sanma_rating.skill_mu,
        yonma_rating_sigma: yonma_rating.skill_sigma,
        yonma_rating_mu: yonma_rating.skill_mu
      }
  end
end
