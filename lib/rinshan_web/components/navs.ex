defmodule RinshanWeb.Navs do
  alias RinshanWeb.Components

  use RinshanWeb, :html
  use Gettext, backend: RinshanWeb.Gettext

  def navbar(assigns) do
    ~H"""
    <div class="navbar text-primary">
      <div class="navbar-start">
        <div class="dropdown">
          <div tabindex="0" role="button" class="btn btn-ghost lg:hidden">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-5 w-5"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M4 6h16M4 12h8m-8 6h16"
              />
            </svg>
          </div>
          <ul
            tabindex="-1"
            class="menu menu-sm dropdown-content bg-base-100 rounded-box z-1 mt-3 w-52 p-2 shadow"
          >
            <.nav_links />
          </ul>
        </div>
        <a href="/" class="flex-1 flex w-fit items-center gap-2">
          <img src={~p"/images/logo.svg"} width="36" />
        </a>
      </div>
      <div class="navbar-end hidden lg:flex">
        <ul class="flex flex-column px-1 space-x-5 items-center">
          <.nav_links />
        </ul>
      </div>
    </div>
    """
  end

  defp nav_links(assigns) do
    ~H"""
    <li><.link navigate="/" class="link link-hover">Home</.link></li>
    <%!-- <li><.link to="/leaderboard" class="link link-hover">Leaderboard</.link></li> --%>
    <li :for={page <- RinshanWeb.StaticPages.all_pages()} :if={page.navlink > 0}>
      <.link navigate={"/#{page.route}"} class="link link-hover capitalize">{page.title}</.link>
    </li>
    <li>
      <Components.social_link social="discord" class="link link-hover">
        Join Us
      </Components.social_link>
    </li>
    """
  end

  def footer(assigns) do
    assigns =
      assigns
      |> Map.put_new_lazy(:socials, fn ->
        Application.get_env(:rinshan, :site).data.socials |> Map.values()
      end)

    ~H"""
    <footer class="footer footer-horizontal footer-center bg-primary text-primary-content rounded p-4 gap-y-2">
      <nav class="grid grid-flow-col gap-4 text-base">
        <.link navigate={~p"/events"} class="link link-hover">{gettext("Events")}</.link>
        <.link navigate={~p"/membership"} class="link link-hover">{gettext("Membership")}</.link>
        <.link navigate={~p"/events"} class="link link-hover">{gettext("Join Us")}</.link>
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
