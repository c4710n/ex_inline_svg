defmodule InlineSVG.HTML do
  def parse_html!(content) do
    Floki.parse_fragment!(content)
  end

  def insert_attrs(parsed_html, attrs) do
    Enum.reduce(attrs, parsed_html, fn {attr, new_value}, acc ->
      attr =
        attr
        |> to_string
        |> String.replace("_", "-")

      Floki.attr(acc, "svg", attr, fn existing_values ->
        String.trim("#{existing_values} #{new_value}")
      end)
    end)
  end

  def to_html(content) do
    Floki.raw_html(content, encode: false, pretty: false)
  end
end
