defmodule RinshanWeb.Components.NavbarComponents do
  use RinshanWeb, :html

  def user_settings_link(assigns) do
    ~H"""
    <.link
      href={~p"/users/settings"}
      class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
    >
      {case @user do
        %{player: %{name: name}} -> name
        %{email: email} -> email
      end}
    </.link>
    """
  end
end
