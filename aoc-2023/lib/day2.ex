defmodule Day2 do
  def parse_game(game_line) do
    game_line
    |> String.split(": ", trim: true)
    |> List.last()
    |> String.split("; ", trim: true)
    |> Enum.map(fn set_line ->
      picks =
        set_line
        |> String.split(", ", trim: true)

      picks
      |> Enum.reduce(%{}, fn pick, acc ->
        [count, color] =
          pick
          |> String.split(" ", trim: true)

        Map.put(acc, color, String.to_integer(count))
      end)
    end)
  end

  def part1(input) do
    limits = %{
      "red" => 12,
      "green" => 13,
      "blue" => 14
    }

    input
    |> String.split("\r\n", trim: true)
    |> Enum.map(&Day2.parse_game/1)
    |> Enum.with_index()
    |> Enum.filter(fn {game, _} ->
      Enum.all?(Map.keys(limits), fn color ->
        Enum.all?(game, fn set ->
          Map.get(set, color, 0) <= Map.get(limits, color)
        end)
      end)
    end)
    |> Enum.map(fn {_game, index} ->
      index + 1
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split("\r\n", trim: true)
    |> Enum.map(&Day2.parse_game/1)
    |> Enum.map(fn game ->
      game
      |> Enum.reduce(%{}, fn set, acc ->
        Map.merge(acc, set, fn _key, count1, count2 ->
          max(count1, count2)
        end)
      end)
      |> Map.values()
      |> Enum.reduce(1, &(&1 * &2))
    end)
    |> Enum.sum()
  end
end

defmodule Mix.Tasks.Day2 do
  use Mix.Task

  @shortdoc "Day 2"
  def run(_) do
    input = File.read!("inputs/day2.txt")

    IO.puts("--- Part 1 ---")
    IO.puts(Day2.part1(input))
    IO.puts("\n--- Part 2 ---")
    IO.puts(Day2.part2(input))
  end
end
