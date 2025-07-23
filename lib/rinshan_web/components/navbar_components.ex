defmodule RinshanWeb.Components.NavbarComponents do
  use RinshanWeb, :html

  def navbar(assigns) do
    ~H"""
    <nav class="flex items-center w-full justify-between flex-wrap p-6">
      <div class="flex items-center gap-4">
        <a href="/">
          <img src={~p"/images/logo.svg"} width="36" />
        </a>
        <p class="bg-brand/5 text-brand rounded-full px-2 font-medium leading-6">
          Queen City Riichi
        </p>
        <.link href={~p"/players"}>
          Players
        </.link>
      </div>
      <div class="flex flex-initial gap-4">
        <%= if @current_user do %>
          <.dropdown js_lib="live_view_js" trigger_class="inline-flex gap-1" menu_items_wrapper_class="w-auto text-nowrap">
            <:trigger_element>
                <HeroiconsV1.Solid.user class="flex-none w-4"/>
                <span class="flex-none">{user_display_name(@current_user)}</span>
                <HeroiconsV1.Solid.chevron_down class="flex-none w-4"/>
            </:trigger_element>
            <.dropdown_menu_item link_type="live_redirect" to={~p"/users/settings"} label="Account Settings" />
            <.dropdown_menu_item link_type="live_redirect" to={~p"/profile"} label="Player Profile" />
            <.dropdown_menu_item>
              <.logout_link />
            </.dropdown_menu_item>
          </.dropdown>
        <% else %>
          <.register_link />
          <.login_link />
        <% end %>
      </div>
    </nav>
    """
  end

  def user_display_name(%{player: %{name: name }}), do: name
  def user_display_name(%{name: name}), do: name
  def user_display_name(%{email: email}), do: email

  def logout_link(assigns) do
    ~H"""
    <.link
      href={~p"/users/log_out"}
      method="delete"
    >
      Log out
    </.link>
    """
  end

  def register_link(assigns) do
    ~H"""
    <.link
      href={~p"/users/register"}
      class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
    >
      Register
    </.link>
    """
  end

  def login_link(assigns) do
    ~H"""
    <.link
      href={~p"/users/log_in"}
      class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
    >
      Log in
    </.link>
    """
  end
end
