# lib/my_app_web/md_engine.ex
defmodule RinshanWeb.MdEngine do
  @behaviour Phoenix.Template.Engine

  # based on https://github.com/phoenixframework/phoenix_live_view/blob/main/lib/phoenix_live_view/html_engine.ex#L12

  def compile(path, _name) do
    quote do
      require RinshanWeb.MdEngine
      RinshanWeb.MdEngine.compile(unquote(path))
    end
  end

  # based on https://github.com/leandrocp/mdex/blob/main/examples/live_view.exs

  @doc false
  defmacro compile(path) do
    trim = Application.get_env(:phoenix, :trim_on_html_eex_engine, true)

    source =
      File.read!(path)

    mdex_opts = [
      extension: [
        strikethrough: true,
        tagfilter: true,
        table: true,
        tasklist: true,
        footnotes: true,
        shortcodes: true,
        header_ids: "",
        front_matter_delimiter: "---"
      ],
      parse: [
        relaxed_tasklist_matching: true
      ],
      render: [
        unsafe_: true
      ]
    ]

    md =
      source
      |> MDEx.to_html!(mdex_opts)
      |> RinshanWeb.MdEngine.unescape()
      |> IO.iodata_to_binary()

    eex_opts = [
      engine: Phoenix.LiveView.TagEngine,
      file: path,
      line: 1,
      trim: trim,
      caller: __CALLER__,
      source: md,
      tag_handler: Phoenix.LiveView.HTMLEngine
    ]

    EEx.compile_string(md, eex_opts)
  end

  def unescape(html) do
    ~r/(<pre.*?<\/pre>)/s
    |> Regex.split(html, include_captures: true)
    |> Enum.map(fn part ->
      if String.starts_with?(part, "<pre") do
        part
      else
        HtmlEntities.decode(part)
      end
    end)
    |> Enum.join()
  end
end
