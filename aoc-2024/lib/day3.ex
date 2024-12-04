defmodule Day3 do
  def part1(input) do
    pattern = ~r/mul\((\d{1,3}),(\d{1,3})\)/

    Regex.scan(pattern, input)
    |> Enum.map(fn [_, a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
  end

  def part2(input) do
    pattern = ~r/mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don\'t\(\)/

    Regex.scan(pattern, input)
    |> Enum.reduce(%{do: true, sum: 0}, fn
      ["do()"], %{do: _, sum: sum} ->
        %{do: true, sum: sum}

      ["don't()"], %{do: _, sum: sum} ->
        %{do: false, sum: sum}

      [_, a, b], %{do: true, sum: sum} ->
        %{do: true, sum: sum + String.to_integer(a) * String.to_integer(b)}

      _, %{do: false, sum: sum} ->
        %{do: false, sum: sum}
    end)
    |> Map.get(:sum)
  end
end

defmodule Mix.Tasks.Day3 do
  use Mix.Task

  @shortdoc "Day 3"
  def run(args) do
    filename =
      case args do
        ["--test" | _] -> "inputs/day3-test.txt"
        _ -> "inputs/day3.txt"
      end

    input = File.read!(filename)

    IO.puts("--- Part 1 ---")
    IO.inspect(Day3.part1(input))

    IO.puts("--- Part 2 ---")
    IO.inspect(Day3.part2(input))
  end
end
