defmodule Rinshan.Repo.Migrations.CreateScores do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :points, :integer
      add :chombo, :integer
      add :player_id, references(:players, on_delete: :nothing)
      add :game_id, references(:games, on_delete: :nothing)
    end

    create index(:scores, [:player_id])
    create index(:scores, [:game_id])
  end
end
