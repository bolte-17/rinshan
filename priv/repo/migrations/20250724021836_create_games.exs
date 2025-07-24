defmodule Rinshan.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :player_count, :integer
      add :rounds, :integer
      add :leftover_points, :integer
      add :played_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
