defmodule Rinshan.Repo.Migrations.CreateSources do
  use Ecto.Migration

  def change do
    create table(:sources) do
      add :sheet_id, :string
      add :year, :integer
      add :tags, {:array, :string}
      add :registry_range, :string
      add :games_range, :string

      timestamps(type: :utc_datetime)
    end
  end
end
