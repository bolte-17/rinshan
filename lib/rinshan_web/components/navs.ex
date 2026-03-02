defmodule RinshanWeb.Navs do
  alias RinshanWeb.Components
  alias Phoenix.LiveView.JS

  use RinshanWeb, :html
  use Gettext, backend: RinshanWeb.Gettext

  def navbar(assigns) do
    ~H"""
    <header class="navbar text-primary xl:px-8">
      <div class="flex-1">
        <a href="/" class="flex-1 flex w-fit items-center gap-2">
          <img src={~p"/images/logo.svg"} width="36" />
        </a>
      </div>
      <div class="flex-none">
        <ul class="flex flex-column px-1 space-x-5 items-center">
          <li><.link to="/" class="link link-hover">Home</.link></li>
          <li><.link to="/events" class="link link-hover">Events</.link></li>
          <li><.link to="/tournaments" class="link link-hover">Tournaments</.link></li>
          <li><.link to="/ruleset" class="link link-hover">Ruleset</.link></li>
          <li><.link to="/leaderboard" class="link link-hover">Leaderboard</.link></li>
          <li><.link to="/membership" class="link link-hover">Membership</.link></li>
          <li>
            <.link
              href={Application.get_env(:rinshan, :socials) |> Kernel.get_in([:discord, :url])}
              class="link link-hover"
            >
              Join Us
            </.link>
          </li>
        </ul>
      </div>
    </header>
    """
  end

  def footer(assigns) do
    assigns =
      assigns
      |> Map.put_new_lazy(:socials, fn ->
        Application.get_env(:rinshan, :socials, []) |> Keyword.values()
      end)

    ~H"""
    <footer class="footer footer-horizontal footer-center bg-primary text-primary-content rounded p-4 gap-y-2">
      <nav class="grid grid-flow-col gap-4 text-base">
        <.link to={~p"/events"} class="link link-hover">{gettext("Events")}</.link>
        <.link to={~p"/membership"} class="link link-hover">{gettext("Membership")}</.link>
        <.link to={~p"/events"} class="link link-hover">{gettext("Join Us")}</.link>
      </nav>
      <nav class="grid grid-flow-col gap-4 text-2xl">
        <.link
          :for={%{url: url, icon: icon} <- @socials}
          href={url}
        >
          <i class={icon} />
        </.link>
      </nav>
      <aside class="grid-flow-col items-center">
        <Components.logo class="bg-white rounded-full" />
        <.copyright_notice />
      </aside>
    </footer>
    """
  end

  defp copyright_notice(assigns) do
    ~H"""
    <p>&copy; 2024 - {Date.utc_today().year} {gettext("Queen City Riichi")}</p>
    """
  end
end
