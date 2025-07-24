defmodule Rinshan.Games.SkillCalculator do
  use Oban.Worker,
    queue: :skill

  import Ecto.Query

  alias Rinshan.Repo
  alias Rinshan.Games.Game
  alias Openskill

  @impl true
  def perform(%Oban.Job{args: %{"player_count" => player_count}}) do
    Game
    |> where([g], g.player_count == ^player_count)
    |> order_by(:played_at)
    |> preload(:scores)
    |> Repo.all()
    |> Enum.reduce(%{}, fn game, player_skills ->
      player_scores =
        game.scores
        |> Enum.sort_by(& &1.points, :desc)
        |> Enum.map(&{&1.player_id, [Map.get(player_skills, &1.player_id, Openskill.rating())]})

      new_ratings =
        player_scores
        |> Enum.map(&elem(&1, 0))
        |> Enum.zip(Openskill.rate(Enum.map(player_scores, &elem(&1, 1))))
        |> Map.new(fn {id, [rating]} -> {id, rating} end)

      for score <- game.scores do
        {mu, sigma} = Map.get(new_ratings, score.player_id)

        score
        |> Ecto.Changeset.change(skill_mu: mu, skill_sigma: sigma)
        |> Repo.update!()
      end

      Map.merge(player_skills, new_ratings)
    end)

    :ok
  end
end
