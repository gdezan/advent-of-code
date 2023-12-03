defmodule Day3 do
  def get_nums_and_coords(line) do
    coords = Regex.scan(~r/\d+/, line, return: :index)
    nums = Regex.scan(~r/\d+/, line)

    nums
    |> Enum.with_index()
    |> Enum.map(fn {x, i} ->
      value = List.first(x) |> String.to_integer()
      {index, len} = Enum.at(coords, i) |> List.first()
      {index, len, value}
    end)
  end

  def add_gear_if_exists(gears, line, line_index, left_pad) do
    line_gears =
      Regex.scan(~r/\*/, line, return: :index)
      |> List.flatten()
      |> Enum.map(fn {index, _len} -> "#{line_index},#{index + left_pad}" end)

    gears ++ line_gears
  end

  def build_adj_chars_str({line, index, len}, lines) do
    substr_start = if index == 0, do: 0, else: index - 1
    scan_len = if index == 0, do: len + 1, else: len + 2

    top_str =
      if line == 0, do: "", else: String.slice(Enum.at(lines, line - 1), substr_start, scan_len)

    gears = add_gear_if_exists([], top_str, line - 1, substr_start)

    left_str = if index == 0, do: "", else: String.slice(Enum.at(lines, line), substr_start, 1)
    gears = add_gear_if_exists(gears, left_str, line, substr_start)

    right_str = String.slice(Enum.at(lines, line), index + len, 1)
    gears = add_gear_if_exists(gears, right_str, line, index + len)

    bottom_str =
      if line == Enum.count(lines) - 1,
        do: "",
        else: String.slice(Enum.at(lines, line + 1), substr_start, scan_len)

    gears = add_gear_if_exists(gears, bottom_str, line + 1, substr_start)

    {top_str <> left_str <> right_str <> bottom_str, gears}
  end

  def part1(input) do
    lines = String.split(input, "\r\n", trim: true)

    coords =
      lines
      |> Enum.map(&get_nums_and_coords/1)
      |> Enum.with_index()
      |> Enum.map(fn {line, line_index} ->
        line
        |> Enum.map(fn x -> Tuple.insert_at(x, 0, line_index) end)
      end)
      |> List.flatten()

    coords
    |> Enum.filter(fn {line, index, len, _} ->
      {scan_str, _gears} = build_adj_chars_str({line, index, len}, lines)
      Regex.match?(~r/[^\.\d]/, scan_str)
    end)
    |> Enum.map(fn {_line, _index, _len, value} -> value end)
    |> Enum.sum()
  end

  def part2(input) do
    lines = String.split(input, "\r\n", trim: true)

    coords =
      lines
      |> Enum.map(&get_nums_and_coords/1)
      |> Enum.with_index()
      |> Enum.map(fn {line, line_index} ->
        line
        |> Enum.map(fn x -> Tuple.insert_at(x, 0, line_index) end)
      end)
      |> List.flatten()

    coords
    |> Enum.map(fn {line, index, len, value} ->
      {_scan_str, gears} = build_adj_chars_str({line, index, len}, lines)
      {value, gears}
    end)
    |> Enum.filter(fn {_value, gears} -> length(gears) > 0 end)
    |> Enum.reduce(%{}, fn {value, gears}, values_per_gear ->
      gear_map =
        Enum.reduce(gears, %{}, fn gear, acc ->
          Map.update(acc, gear, [value], fn old_val -> [value | old_val] end)
        end)

      Map.merge(values_per_gear, gear_map, fn _key, old_val, new_val -> old_val ++ new_val end)
    end)
    |> Enum.filter(fn {_gear, values} -> length(values) == 2 end)
    |> Enum.map(fn {_gear, [value1, value2]} -> value1 * value2 end)
    |> Enum.sum()
  end
end

defmodule Mix.Tasks.Day3 do
  use Mix.Task

  @shortdoc "Day 3"
  def run(_) do
    input = File.read!("inputs/day3.txt")

    IO.puts("--- Part 1 ---")
    IO.inspect(Day3.part1(input))
    IO.puts("\n--- Part 2 ---")
    IO.inspect(Day3.part2(input))
  end
end
