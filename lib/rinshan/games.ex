defmodule Rinshan.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias Rinshan.Repo

  alias Rinshan.Games.{Game, Score}

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games(opts \\ []) do
    query =
      Game
      |> order_by(desc: :played_at)
      |> preload(scores: ^{Score.with_rank(), [:player]})

    query =
      if player_count = Keyword.get(opts, :player_count) do
        query |> where(player_count: ^player_count)
      else
        query
      end

    query =
      if since = Keyword.get(opts, :since) do
        query |> where([g], g.played_at > ^since)
      else
        query
      end

    Repo.all(query)
  end

  def leaderboard(opts \\ []) do
    Rinshan.Games.list_games(opts)
    |> Enum.flat_map(&(&1.scores |> Enum.map(fn score -> %{score | game: &1} end)))
    |> Enum.group_by(&{&1.player.id, &1.player.name}, &{Score.score_with_uma(&1), &1.game.rounds})
    |> Enum.map(fn {{_, name}, scores} ->
      {
        name,
        scores |> Enum.sum_by(&elem(&1, 0)) |> Float.round(1),
        (scores |> Enum.sum_by(&elem(&1, 1))) / 2
      }
    end)
    |> Enum.sort_by(&elem(&1, 1), :desc)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  def recalculate_skill_ratings(player_count) do
    %{player_count: player_count}
    |> Rinshan.Games.SkillCalculator.new()
    |> Oban.insert!()
  end
end
