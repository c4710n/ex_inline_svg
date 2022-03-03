import Config

if Mix.env() == :test do
  config :inline_svg, dir: "test/svg_icons"
end
