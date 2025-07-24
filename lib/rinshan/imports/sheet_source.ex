defmodule Rinshan.Imports.SheetSource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sources" do
    field :sheet_id, :string
    field :year, :integer
    field :tags, {:array, Ecto.Enum}, values: [:friendly, :club, :preseason]
    field :registry_range, :string
    field :games_range, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(sheet_source, attrs) do
    sheet_source
    |> cast(attrs, [:sheet_id, :year, :tags, :registry_range, :games_range])
    |> validate_required([:sheet_id, :year, :tags, :registry_range, :games_range])
  end
end
