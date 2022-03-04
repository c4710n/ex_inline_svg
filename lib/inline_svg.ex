defmodule InlineSVG do
  @moduledoc """
  Render inline SVG.

  > The core code is borrowed from [nikkomiu/phoenix_inline_svg](https://github.com/nikkomiu/phoenix_inline_svg).

  ## Import Helpers for Phoenix

  Add the following to the quoted `view` in your `my_app_web.ex` file.

      def view do
        quote do
          use InlineSVG
        end
      end

  This will generate functions for each SVG file, effectively caching them at compile time.

  ## Usage

  ### render SVG from default collection

  ```eex
  <%= svg("home") %>
  ```

  It will load the SVG file from `assets/static/svg/generic/home.svg`, and inject
  the content of SVG file to HTML:

  ```html
  <svg>...</svg>
  ```

  ### render SVG from other collections

  You can break up SVG files into collections, and use the second argument of
  `svg/2` to specify the name of collection:

  ```eex
  <%= svg_image("user", "fontawesome") %>
  ```

  It will load the SVG file from `assets/static/svg/fontawesome/user.svg`, and
  inject the content of SVG file to HTML:

  ```html
  <svg>...</svg>
  ```

  ### render SVG with custom HTML attributes

  You can also pass optional HTML attributes into the function to set those
  attributes on the SVG:

  ```eex
  <%= svg("home", class: "logo", id: "bounce-animation") %>
  <%= svg("home", "fontawesome", class: "logo", id: "bounce-animation") %>
  ```

  It will output:

  ```html
  <svg class="logo" id="bounce-animation">...</svg>
  <svg class="logo" id="bounce-animation">...</svg>
  ```

  ## Configuration Options

  There are several configuration options for meeting your needs.

  ### `:dir`

  Specify the directory from which to load SVG files.

  The default value for standard way is `assets/static/svg/`.

  ```elixir
  config :inline_svg,
    dir: "relative/path/to/the/root/of/project"
  ```

  ### `:default_collection`

  Specify the default collection to use.

  The deafult value is `generic`.

  ```elixir
  config :inline_svg,
    default_collection: "fontawesome"
  ```

  """

  alias InlineSVG.HTML

  @doc """
  The macro precompiles the SVG files into functions.
  """
  defmacro __using__(_) do
    get_config(:dir, "assets/static/svg/")
    |> scan_svgs()
    |> Enum.map(&cache_svg/1)
  end

  def scan_svgs(root) do
    root
    |> Path.join("**/*.svg")
    |> Path.wildcard()
    |> Stream.filter(&File.regular?(&1))
    |> Enum.map(fn svg_path ->
      [collection_name, svg_name] =
        svg_path
        |> Path.relative_to(root)
        |> Path.rootname()
        |> String.split("/", parts: 2)

      {collection_name, svg_name, svg_path}
    end)
  end

  defp cache_svg({collection, name, path}) do
    content = read_svg(path)

    # parse HTML at compile time.
    parsed_html =
      content
      |> HTML.parse_html!()
      |> Macro.escape()

    generic_functions =
      if collection == get_config(:default_collection, "generic") do
        quote do
          def svg(unquote(name)) do
            svg(unquote(name), unquote(collection), [])
          end

          def svg(unquote(name), opts) when is_list(opts) do
            svg(unquote(name), unquote(collection), opts)
          end
        end
      end

    explicit_functions =
      quote do
        def svg(unquote(name), unquote(collection)) do
          svg(unquote(name), unquote(collection), [])
        end

        def svg(unquote(name), unquote(collection), []) do
          unquote(content)
        end

        def svg(unquote(name), unquote(collection), opts) do
          unquote(parsed_html)
          |> HTML.insert_attrs(opts)
          |> HTML.to_html()
        end
      end

    [generic_functions, explicit_functions]
  end

  defp read_svg(path) do
    path
    |> File.read!()
    |> String.trim()
  end

  defp get_config(key, default) do
    Application.get_env(:inline_svg, key, default)
  end
end
