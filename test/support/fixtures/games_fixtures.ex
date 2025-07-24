defmodule Rinshan.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rinshan.Games` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        leftover_points: 42,
        player_count: 42,
        rounds: 42
      })
      |> Rinshan.Games.create_game()

    game
  end
end
