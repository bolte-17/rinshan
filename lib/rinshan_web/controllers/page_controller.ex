defmodule RinshanWeb.PageController do
  use RinshanWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def static_page(conn, _params) do
    conn
    |> assign(:site, Application.get_env(:rinshan, :site))
    |> render()
  end
end
