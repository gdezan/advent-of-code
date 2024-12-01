defmodule Day1 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      x
      |> String.split("   ", trim: true)
      |> Enum.map(fn x -> String.to_integer(x) end)
    end)
    |> Enum.reduce([[], []], fn [x, y], [acc_x, acc_y] ->
      [acc_x ++ [x], acc_y ++ [y]]
    end)
    |> Enum.map(&Enum.sort(&1))
    |> Enum.zip()
    |> Enum.map(fn {x, y} -> abs(y - x) end)
    |> Enum.sum()
  end

  def part2(input) do
    [list_left, list_right] =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn x ->
        x
        |> String.split("   ", trim: true)
        |> Enum.map(fn x -> String.to_integer(x) end)
      end)
      |> Enum.reduce([[], []], fn [x, y], [acc_x, acc_y] ->
        [acc_x ++ [x], acc_y ++ [y]]
      end)

    freqs =
      list_right
      |> Enum.reduce(Map.new(), fn x, acc ->
        {_, ret} =
          Map.get_and_update(acc, x, fn count ->
            if count == nil do
              {count, 1}
            else
              {count, count + 1}
            end
          end)

        ret
      end)

    list_left
    |> Enum.map(fn x ->
      freq = Map.get(freqs, x)

      if freq == nil do
        0
      else
        freq * x
      end
    end)
    |> Enum.sum()
  end
end

defmodule Mix.Tasks.Day1 do
  use Mix.Task

  @shortdoc "Day 1"
  def run(_) do
    input = File.read!("inputs/day1.txt")

    IO.puts("--- Part 1 ---")
    IO.inspect(Day1.part1(input))
    IO.puts("\n--- Part 2 ---")
    IO.inspect(Day1.part2(input))
  end
end
