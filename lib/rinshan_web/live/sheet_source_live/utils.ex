defmodule RinshanWeb.Live.SheetSourceLive.Utils do
  use RinshanWeb, :html

  def google_sheets_link(assigns) do
    ~H"""
    <.a
      link_type="a"
      to={"https://docs.google.com/spreadsheets/d/#{@source.sheet_id}"}
      class="capitalize text-gray-700 dark:text-gray-400 hover:text-gray-900 hover:underline"
      label={source_title(@source)}
    />
    """
  end

  def source_title(source) do
    "#{source.tags |> Enum.map(&Atom.to_string/1) |> Enum.join()} Leaderboard #{source.year}"
  end
end
