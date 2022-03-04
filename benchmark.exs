Mix.install(
  [
    {:benchee, "~> 1.0"},
    {:inline_svg, "~> 0.1"},
    {:phoenix_inline_svg, "~> 1.4"},
    {:adept_svg, "~> 0.3.1"}
    # svg_icons - broken, ignore it.
  ],
  config: [
    phoenix_inline_svg: [
      dir: Path.expand("benchmark/icons", __DIR__),
      default_collection: "solid"
    ]
  ]
)

defmodule Data do
  def generate_attrs(num) do
    Enum.map(0..num, fn num -> {:"attr#{num}", num} end)
  end
end

defmodule SampleInlineSVG do
  use InlineSVG,
    root: Path.expand("benchmark/icons", __DIR__),
    default_collection: "solid"
end

defmodule SamplePhoenixInlineSVG do
  use PhoenixInlineSvg.Helpers
end

defmodule SampleAdeptSVG do
  @library "benchmark/icons"
           |> Path.expand(__DIR__)
           |> Adept.Svg.compile()

  defp library(), do: @library

  def render(key, opts \\ []) do
    Adept.Svg.render(library(), key, opts)
  end
end

Benchee.run(
  %{
    "inline_svg" => fn [collection, name, attrs] ->
      apply(SampleInlineSVG, :svg, [name, collection, attrs])
    end,
    "phoenix_inline_svg" => fn [collection, name, attrs] ->
      apply(SamplePhoenixInlineSVG, :svg_image, [name, collection, attrs])
    end,
    "adept_svg" => fn [collection, name, attrs] ->
      apply(SampleAdeptSVG, :render, ["#{collection}/#{name}", attrs])
    end
  },
  inputs: %{
    "1. small SVG without attrs" => ["solid", "small", []],
    "2. small SVG with 5 attrs (normal case)" => ["solid", "small", Data.generate_attrs(5)],
    "3. small SVG with 25 attrs" => ["solid", "small", Data.generate_attrs(25)],
    "4. small SVG with 100 attrs" => ["solid", "small", Data.generate_attrs(100)],
    "5. big SVG without attrs" => ["solid", "big", []],
    "6. big SVG with 5 attrs (normal case)" => ["solid", "big", Data.generate_attrs(5)],
    "7. big SVG with 25 attrs" => ["solid", "big", Data.generate_attrs(25)],
    "8. big SVG with 100 attrs" => ["solid", "big", Data.generate_attrs(100)]
  }
)
