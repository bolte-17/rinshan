defmodule RinshanWeb.Components do
  use RinshanWeb, :html

  embed_templates "*", root: Application.app_dir(:rinshan, "priv/static_pages")

  @site_data Application.get_env(:rinshan, :site).data

  def logo(assigns) do
    ~H"""
    <img src={~p"/images/logo.svg"} width="36" {assigns} />
    """
  end

  def social_link(assigns) do
    assigns = assign(assigns, :socials, @site_data.socials)

    ~H"""
    <.link
      href={@socials[String.to_existing_atom(@social)].url}
      phx-no-format
      {assigns_to_attributes(assigns, [:socials, :social])}
    >{render_slot(@inner_block)}</.link>
    """
  end

  def leaderboard_embeds(assigns) do
    assigns = assign(assigns, :links, @site_data.links)

    ~H"""
    <iframe
      src={@links.club_leaderboard_embed_src}
      style="width: 100%; height: 350px; margin: 10px 0 "
    >
    </iframe>
    <iframe
      src={@links.friendly_leaderboard_embed_src}
      style="width: 100%; height: 350px; margin: 10px 0 "
    >
    </iframe>
    """
  end

  def calendar_embed(assigns) do
    assigns = assign(assigns, :links, @site_data.links)

    ~H"""
    <iframe
      src={@links.calendar_embed_src}
      style="border-width:0"
      width="100%"
      height="350px"
      frameborder="0"
      scrolling="no"
    >
    </iframe>
    """
  end
end
