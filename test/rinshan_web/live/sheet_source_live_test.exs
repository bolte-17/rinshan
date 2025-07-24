defmodule RinshanWeb.SheetSourceLiveTest do
  use RinshanWeb.ConnCase

  import Phoenix.LiveViewTest
  import Rinshan.ImportsFixtures

  @create_attrs %{
    year: 42,
    sheet_id: "some sheet_id",
    tags: ["option1", "option2"],
    registry_range: "some registry_range",
    games_range: "some games_range"
  }
  @update_attrs %{
    year: 43,
    sheet_id: "some updated sheet_id",
    tags: ["option1"],
    registry_range: "some updated registry_range",
    games_range: "some updated games_range"
  }
  @invalid_attrs %{year: nil, sheet_id: nil, tags: [], registry_range: nil, games_range: nil}

  defp create_sheet_source(_) do
    sheet_source = sheet_source_fixture()
    %{sheet_source: sheet_source}
  end

  describe "Index" do
    setup [:create_sheet_source]

    test "lists all sources", %{conn: conn, sheet_source: sheet_source} do
      {:ok, _index_live, html} = live(conn, ~p"/sources")

      assert html =~ "Listing Sources"
      assert html =~ sheet_source.sheet_id
    end

    test "saves new sheet_source", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sources")

      assert index_live |> element("a", "New Sheet source") |> render_click() =~
               "New Sheet source"

      assert_patch(index_live, ~p"/sources/new")

      assert index_live
             |> form("#sheet_source-form", sheet_source: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#sheet_source-form", sheet_source: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sources")

      html = render(index_live)
      assert html =~ "Sheet source created successfully"
      assert html =~ "some sheet_id"
    end

    test "updates sheet_source in listing", %{conn: conn, sheet_source: sheet_source} do
      {:ok, index_live, _html} = live(conn, ~p"/sources")

      assert index_live |> element("#sources-#{sheet_source.id} a", "Edit") |> render_click() =~
               "Edit Sheet source"

      assert_patch(index_live, ~p"/sources/#{sheet_source}/edit")

      assert index_live
             |> form("#sheet_source-form", sheet_source: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#sheet_source-form", sheet_source: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sources")

      html = render(index_live)
      assert html =~ "Sheet source updated successfully"
      assert html =~ "some updated sheet_id"
    end

    test "deletes sheet_source in listing", %{conn: conn, sheet_source: sheet_source} do
      {:ok, index_live, _html} = live(conn, ~p"/sources")

      assert index_live |> element("#sources-#{sheet_source.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#sources-#{sheet_source.id}")
    end
  end

  describe "Show" do
    setup [:create_sheet_source]

    test "displays sheet_source", %{conn: conn, sheet_source: sheet_source} do
      {:ok, _show_live, html} = live(conn, ~p"/sources/#{sheet_source}")

      assert html =~ "Show Sheet source"
      assert html =~ sheet_source.sheet_id
    end

    test "updates sheet_source within modal", %{conn: conn, sheet_source: sheet_source} do
      {:ok, show_live, _html} = live(conn, ~p"/sources/#{sheet_source}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Sheet source"

      assert_patch(show_live, ~p"/sources/#{sheet_source}/show/edit")

      assert show_live
             |> form("#sheet_source-form", sheet_source: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#sheet_source-form", sheet_source: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/sources/#{sheet_source}")

      html = render(show_live)
      assert html =~ "Sheet source updated successfully"
      assert html =~ "some updated sheet_id"
    end
  end
end
