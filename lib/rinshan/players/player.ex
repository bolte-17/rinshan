defmodule Rinshan.Players.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :name, :string
    field :discord_id, :string
    field :discord_uid, :integer
    field :paid_through, :date

    has_one :user, Rinshan.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :discord_id, :discord_uid, :paid_through])
    |> validate_required([:name])
  end
end
