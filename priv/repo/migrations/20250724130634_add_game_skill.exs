defmodule Rinshan.Repo.Migrations.AddGameSkill do
  use Ecto.Migration

  def change do
    alter table("scores") do
      add :skill_mu, :float
      add :skill_sigma, :float
    end
  end
end
