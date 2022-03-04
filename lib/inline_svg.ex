defmodule InlineSVG do
  @moduledoc """
  Render inline SVG.


  ## Initialization

  ```ex
  def SVGHelper do
    use InlineSVG, root: "assets/static/svg", default_collection: "generic"
  end
  ```

  This will generate functions for each SVG file, effectively caching them at
  compile time.


  ## Usage

  ### render SVG from default collection

  ```ex
  svg("home")
  ```

  It will load the SVG file from `assets/static/svg/generic/home.svg`:

  ```html
  <svg>...</svg>
  ```

  ### render SVG from other collections

  You can break up SVG files into collections, and use the second argument of
  `svg/2` to specify the name of collection:

  ```ex
  svg("user", "fontawesome")
  ```

  It will load the SVG file from `assets/static/svg/fontawesome/user.svg`:

  ```html
  <svg>...</svg>
  ```

  ### render SVG with custom HTML attributes

  You can also pass optional HTML attributes into the function to set those
  attributes on the SVG:

  ```ex
  svg("home", class: "logo", id: "bounce-animation")
  svg("home", "fontawesome", class: "logo", id: "bounce-animation")
  ```

  It will output:

  ```html
  <svg class="logo" id="bounce-animation">...</svg>
  <svg class="logo" id="bounce-animation">...</svg>
  ```


  ## Options

  There are several configuration options for meeting your needs.

  ### `:root`

  Specify the directory from which to load SVG files.

  You must specify it by your own.

  ### `:default_collection`

  Specify the default collection to use.

  The deafult value is `generic`.


  ## Use in Phoenix

  An example:

  ```ex
  def DemoWeb.SVGHelper do
    use InlineSVG,
      root: "assets/static/svg",
      default_collection: "generic",
      function_prefix: "_"

    def svg(arg1) do
      Phoenix.HTML.raw(_svg(arg1))
    end

    def svg(arg1, arg2) do
      Phoenix.HTML.raw(_svg(arg1, arg2))
    end

    def svg(arg1, arg2, arg3) do
      Phoenix.HTML.raw(_svg(arg1, arg2, arg3))
    end
  end
  ```
  """

  alias InlineSVG.HTML

  @doc """
  The macro precompiles the SVG files into functions.
  """
  defmacro __using__(opts \\ []) do
    root = Keyword.fetch!(opts, :root)
    {root, _} = Code.eval_quoted(root)

    if !File.dir?(root) do
      raise "invalid :root option"
    end

    function_prefix = Keyword.get(opts, :function_prefix, "")
    default_collection = Keyword.get(opts, :default_collection, "generic")

    [recompile_hooks(root) | generate_svg_fns(root, function_prefix, default_collection)]
  end

  # Trigger recompile when SVG files change.
  # Read more at https://hexdocs.pm/mix/1.13/Mix.Tasks.Compile.Elixir.html
  defp recompile_hooks(root) do
    quote bind_quoted: [root: root] do
      @root root

      paths =
        @root
        |> Path.join("**/*.svg")
        |> Path.wildcard()
        |> Enum.filter(&File.regular?(&1))

      @paths_hash :erlang.md5(paths)

      for path <- paths do
        @external_resource path
      end

      def __mix_recompile__?() do
        @root
        |> Path.join("**/*.svg")
        |> Path.wildcard()
        |> Enum.filter(&File.regular?(&1))
        |> :erlang.md5() != @paths_hash
      end
    end
  end

  defp generate_svg_fns(root, function_prefix, default_collection) do
    root
    |> scan_svgs()
    |> Enum.flat_map(&cache_svg(&1, function_prefix, default_collection))
  end

  defp scan_svgs(root) do
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

  defp cache_svg({collection, name, path}, function_prefix, default_collection) do
    content = read_svg(path)

    # parse HTML at compile time.
    parsed_html =
      content
      |> HTML.parse_html!()
      |> Macro.escape()

    generic_functions =
      if collection == default_collection do
        quote do
          def unquote(:"#{function_prefix}svg")(unquote(name)) do
            unquote(:"#{function_prefix}svg")(unquote(name), unquote(collection), [])
          end

          def unquote(:"#{function_prefix}svg")(unquote(name), opts) when is_list(opts) do
            unquote(:"#{function_prefix}svg")(unquote(name), unquote(collection), opts)
          end
        end
      end

    explicit_functions =
      quote do
        def unquote(:"#{function_prefix}svg")(unquote(name), unquote(collection)) do
          unquote(:"#{function_prefix}svg")(unquote(name), unquote(collection), [])
        end

        def unquote(:"#{function_prefix}svg")(unquote(name), unquote(collection), []) do
          unquote(content)
        end

        def unquote(:"#{function_prefix}svg")(unquote(name), unquote(collection), opts) do
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
end
