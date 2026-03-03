defmodule RinshanWeb.StaticPages do
  defmodule Parser do
    def parse(path, contents) do
      [attrs, body] = String.split(contents, ~r/---\n/, trim: true)

      {attrs
       |> String.split("\n", trim: true)
       |> Enum.map(fn str ->
         String.split(str, ":", parts: 2)
         |> Enum.map(&String.trim/1)
         |> List.to_tuple()
       end)
       |> Map.new(), body}
    end
  end

  defmodule Page do
    @enforce_keys [:title, :body, :route]
    defstruct [:title, :show_title, :description, :show_description, :body, :route, :navlink]

    def build(filename, attrs, body) do
      basename = Path.basename(filename, ".md")

      %__MODULE__{
        title: Map.get(attrs, "title", basename),
        show_title: Map.get(attrs, "show_title", "true") == "true",
        description: Map.get(attrs, "description"),
        show_description: Map.get(attrs, "show_description", "true") == "true",
        body: body,
        route: String.to_atom(basename),
        navlink: Map.get(attrs, "navlink", "0") |> String.to_integer()
      }
    end
  end

  use NimblePublisher,
    build: __MODULE__.Page,
    from: Application.app_dir(:rinshan, "priv/static_pages/*.md"),
    as: :pages,
    parser: __MODULE__.Parser,
    highlighters: [:makeup_elixir, :makeup_erlang]

  @pages @pages |> Enum.sort_by(&(&1.navlink > 0 && &1.navlink))

  def all_pages(), do: @pages
  def routes(), do: Enum.map(@pages, & &1.route)
  def get_page(route), do: Enum.find(@pages, &(&1.route == route))
end
