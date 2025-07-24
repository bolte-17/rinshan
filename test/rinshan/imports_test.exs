defmodule Rinshan.ImportsTest do
  use Rinshan.DataCase

  alias Rinshan.Imports

  describe "sources" do
    alias Rinshan.Imports.SheetSource

    import Rinshan.ImportsFixtures

    @invalid_attrs %{year: nil, sheet_id: nil, tags: nil, registry_range: nil, games_range: nil}

    test "list_sources/0 returns all sources" do
      sheet_source = sheet_source_fixture()
      assert Imports.list_sources() == [sheet_source]
    end

    test "get_sheet_source!/1 returns the sheet_source with given id" do
      sheet_source = sheet_source_fixture()
      assert Imports.get_sheet_source!(sheet_source.id) == sheet_source
    end

    test "create_sheet_source/1 with valid data creates a sheet_source" do
      valid_attrs = %{
        year: 42,
        sheet_id: "some sheet_id",
        tags: ["option1", "option2"],
        registry_range: "some registry_range",
        games_range: "some games_range"
      }

      assert {:ok, %SheetSource{} = sheet_source} = Imports.create_sheet_source(valid_attrs)
      assert sheet_source.year == 42
      assert sheet_source.sheet_id == "some sheet_id"
      assert sheet_source.tags == ["option1", "option2"]
      assert sheet_source.registry_range == "some registry_range"
      assert sheet_source.games_range == "some games_range"
    end

    test "create_sheet_source/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Imports.create_sheet_source(@invalid_attrs)
    end

    test "update_sheet_source/2 with valid data updates the sheet_source" do
      sheet_source = sheet_source_fixture()

      update_attrs = %{
        year: 43,
        sheet_id: "some updated sheet_id",
        tags: ["option1"],
        registry_range: "some updated registry_range",
        games_range: "some updated games_range"
      }

      assert {:ok, %SheetSource{} = sheet_source} =
               Imports.update_sheet_source(sheet_source, update_attrs)

      assert sheet_source.year == 43
      assert sheet_source.sheet_id == "some updated sheet_id"
      assert sheet_source.tags == ["option1"]
      assert sheet_source.registry_range == "some updated registry_range"
      assert sheet_source.games_range == "some updated games_range"
    end

    test "update_sheet_source/2 with invalid data returns error changeset" do
      sheet_source = sheet_source_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Imports.update_sheet_source(sheet_source, @invalid_attrs)

      assert sheet_source == Imports.get_sheet_source!(sheet_source.id)
    end

    test "delete_sheet_source/1 deletes the sheet_source" do
      sheet_source = sheet_source_fixture()
      assert {:ok, %SheetSource{}} = Imports.delete_sheet_source(sheet_source)
      assert_raise Ecto.NoResultsError, fn -> Imports.get_sheet_source!(sheet_source.id) end
    end

    test "change_sheet_source/1 returns a sheet_source changeset" do
      sheet_source = sheet_source_fixture()
      assert %Ecto.Changeset{} = Imports.change_sheet_source(sheet_source)
    end
  end
end
