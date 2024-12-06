defmodule Day5 do
  defp is_valid_page(rules, tail) do
    tail
    |> Enum.all?(fn page ->
      !Enum.member?(rules, page)
    end)
  end

  defp is_valid_update([], _rule_map), do: true

  defp is_valid_update([page | tail], rule_map) do
    valid_page =
      case Map.get(rule_map, page) do
        nil -> true
        rules -> is_valid_page(rules, tail)
      end

    valid_page && is_valid_update(tail, rule_map)
  end

  def part1(input) do
    [rules, updates] =
      input
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    rule_map =
      rules
      |> Enum.reduce(%{}, fn rule, acc ->
        [prev, aft] = String.split(rule, "|")

        Map.update(acc, aft, [prev], fn curr -> [prev | curr] end)
      end)

    updates
    |> Enum.map(&String.split(&1, ","))
    |> Enum.filter(&is_valid_update(&1, rule_map))
    |> Enum.map(fn x ->
      x |> Enum.at(round((Enum.count(x) + 1) / 2 - 1)) |> String.to_integer()
    end)
    |> Enum.sum()
  end

  def part2(input) do
    [rules, updates] =
      input
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    rule_map =
      rules
      |> Enum.reduce(%{}, fn rule, acc ->
        [prev, aft] = String.split(rule, "|")

        Map.update(acc, aft, [prev], fn curr -> [prev | curr] end)
      end)

    updates
    |> Enum.map(&String.split(&1, ","))
    |> Enum.filter(&(!is_valid_update(&1, rule_map)))
    |> Enum.map(fn x ->
      x
      |> Enum.sort(fn a, b ->
        rules = Map.get(rule_map, a)
        rules_b = Map.get(rule_map, b)

        cond do
          rules == nil && rules_b == nil -> true
          rules == nil -> true
          rules_b == nil -> false
          true -> !Enum.member?(rules, b)
        end
      end)
    end)
    |> Enum.map(fn x ->
      x |> Enum.at(round((Enum.count(x) + 1) / 2 - 1)) |> String.to_integer()
    end)
    |> Enum.sum()
  end
end

defmodule Mix.Tasks.Day5 do
  use Mix.Task

  @shortdoc "Day 5"
  def run(args) do
    filename =
      case args do
        ["--test" | _] -> "inputs/day5-test.txt"
        _ -> "inputs/day5.txt"
      end

    input = File.read!(filename)

    IO.puts("--- Part 1 ---")
    IO.inspect(Day5.part1(input), charlists: :as_lists)

    IO.puts("--- Part 2 ---")
    IO.inspect(Day5.part2(input), charlists: :as_lists)
  end
end
