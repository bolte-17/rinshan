defmodule Rinshan.Repo.Migrations.AddUserPlayerAssoc do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :player_id, references(:players, on_delete: :nothing)
    end
  end
end
