defmodule RinshanWeb.Components do
  use RinshanWeb, :html

  def logo(assigns) do
    ~H"""
    <img src={~p"/images/logo.svg"} width="36" {assigns} />
    """
  end
end
