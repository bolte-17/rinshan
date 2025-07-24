defmodule Rinshan.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :discord_id, :string
      add :discord_uid, :integer
      add :paid_through, :date

      timestamps(type: :utc_datetime)
    end

    create unique_index(:players, [:discord_id])
  end
end
