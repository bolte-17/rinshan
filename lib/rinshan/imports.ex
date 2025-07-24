defmodule Rinshan.Imports do
  @moduledoc """
  The Imports context.
  """

  import Ecto.Query, warn: false
  alias Rinshan.Repo

  alias Rinshan.Imports.{SheetSource, PlayerImporter, GamesImporter}

  def fetch_all_players() do
    SheetSource
    |> Repo.all()
    |> Enum.each(fn sheet_source ->
      sheet_source
      |> Map.take([:sheet_id, :registry_range])
      |> PlayerImporter.new()
      |> Oban.insert!()
    end)
  end

  def fetch_all_games() do
    SheetSource
    |> Repo.all()
    |> Enum.each(fn sheet_source ->
      sheet_source
      |> Map.take([:sheet_id, :games_range])
      |> GamesImporter.new()
      |> Oban.insert!()
    end)
  end

  @doc """
  Returns the list of sources.

  ## Examples

      iex> list_sources()
      [%SheetSource{}, ...]

  """
  def list_sources do
    Repo.all(SheetSource)
  end

  @doc """
  Gets a single sheet_source.

  Raises `Ecto.NoResultsError` if the Sheet source does not exist.

  ## Examples

      iex> get_sheet_source!(123)
      %SheetSource{}

      iex> get_sheet_source!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sheet_source!(id), do: Repo.get!(SheetSource, id)

  @doc """
  Creates a sheet_source.

  ## Examples

      iex> create_sheet_source(%{field: value})
      {:ok, %SheetSource{}}

      iex> create_sheet_source(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sheet_source(attrs \\ %{}) do
    %SheetSource{}
    |> SheetSource.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sheet_source.

  ## Examples

      iex> update_sheet_source(sheet_source, %{field: new_value})
      {:ok, %SheetSource{}}

      iex> update_sheet_source(sheet_source, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sheet_source(%SheetSource{} = sheet_source, attrs) do
    sheet_source
    |> SheetSource.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sheet_source.

  ## Examples

      iex> delete_sheet_source(sheet_source)
      {:ok, %SheetSource{}}

      iex> delete_sheet_source(sheet_source)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sheet_source(%SheetSource{} = sheet_source) do
    Repo.delete(sheet_source)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sheet_source changes.

  ## Examples

      iex> change_sheet_source(sheet_source)
      %Ecto.Changeset{data: %SheetSource{}}

  """
  def change_sheet_source(%SheetSource{} = sheet_source, attrs \\ %{}) do
    SheetSource.changeset(sheet_source, attrs)
  end
end
