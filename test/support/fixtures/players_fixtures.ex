defmodule Rinshan.PlayersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rinshan.Players` context.
  """

  @doc """
  Generate a player.
  """
  def player_fixture(attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{
        discord_id: "some discord_id",
        discord_uid: 42,
        name: "some name",
        paid_through: ~D[2025-07-21]
      })
      |> Rinshan.Players.create_player()

    player
  end
end
