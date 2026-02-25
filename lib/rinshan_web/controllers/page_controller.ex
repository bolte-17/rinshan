defmodule RinshanWeb.PageController do
  use RinshanWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
