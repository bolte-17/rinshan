defmodule Rinshan.ImportsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rinshan.Imports` context.
  """

  @doc """
  Generate a sheet_source.
  """
  def sheet_source_fixture(attrs \\ %{}) do
    {:ok, sheet_source} =
      attrs
      |> Enum.into(%{
        games_range: "some games_range",
        registry_range: "some registry_range",
        sheet_id: "some sheet_id",
        tags: ["option1", "option2"],
        year: 42
      })
      |> Rinshan.Imports.create_sheet_source()

    sheet_source
  end
end
