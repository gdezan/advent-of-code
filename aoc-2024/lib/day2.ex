defmodule Day2 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      x
      |> String.split(" ", trim: true)
      |> Enum.map(fn x -> String.to_integer(x) end)
    end)
    |> Enum.filter(fn report ->
      diffs =
        report
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn [l, w] -> l - w end)

      diffs
      |> Enum.all?(fn x ->
        if hd(diffs) > 0 do
          x > 0 && abs(x) >= 1 && abs(x) <= 3
        else
          x < 0 && abs(x) <= 3 && abs(x) >= 1
        end
      end)
    end)
    |> Enum.count()
  end

  def part2(input) do
    reports =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn x ->
        x
        |> String.split(" ", trim: true)
        |> Enum.map(fn x -> String.to_integer(x) end)
      end)

    report_attempts =
      reports
      |> Enum.map(fn report ->
        report_with_index =
          report
          |> Enum.with_index()

        report_with_index
        |> Enum.map(fn {_x, i} ->
          report_with_index
          |> Enum.reject(fn {_, j} -> i == j end)
          |> Enum.map(fn {y, _} -> y end)
        end)
      end)

    report_attempts
    |> Enum.map(fn reports ->
      reports
      |> Enum.filter(fn report ->
        diffs =
          report
          |> Enum.chunk_every(2, 1, :discard)
          |> Enum.map(fn [l, w] -> l - w end)

        diffs
        |> Enum.all?(fn x ->
          if hd(diffs) > 0 do
            x > 0 && abs(x) >= 1 && abs(x) <= 3
          else
            x < 0 && abs(x) <= 3 && abs(x) >= 1
          end
        end)
      end)
    end)
    |> Enum.filter(fn x -> x != [] end)
    |> Enum.count()
  end
end

defmodule Mix.Tasks.Day2 do
  use Mix.Task

  @shortdoc "Day 2"
  def run(_) do
    input = File.read!("inputs/day2.txt")

    IO.puts("--- Part 1 ---")
    IO.inspect(Day2.part1(input))
    IO.puts("\n--- Part 2 ---")
    IO.inspect(Day2.part2(input))
  end
end
