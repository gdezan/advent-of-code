defmodule Day1 do
  def part1 do
    input = File.read!("lib/day1.txt")

    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      nums =
        x
        |> String.replace(~r/\D/, "")
        |> String.split("", trim: true)

      String.to_integer(List.first(nums) <> List.last(nums))
    end)
    |> Enum.sum()
  end

  def part2 do
    input = File.read!("lib/day1.txt")

    values = %{
      "one" => "1",
      "two" => "2",
      "three" => "3",
      "four" => "4",
      "five" => "5",
      "six" => "6",
      "seven" => "7",
      "eight" => "8",
      "nine" => "9"
    }

    regex = ~r/\d|one|two|three|four|five|six|seven|eight|nine/
    regex_inv = ~r/\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin/

    lines =
      input
      |> String.split("\n", trim: true)

    lines
    |> Enum.map(fn line ->
      [
        Regex.run(regex, line) |> List.first(),
        Regex.run(regex_inv, String.reverse(line)) |> List.first() |> String.reverse()
      ]
      |> Enum.map(fn x ->
        if x in Map.keys(values) do
          Map.get(values, x)
        else
          x
        end
      end)
      |> Enum.join("")
      |> String.to_integer()
    end)
    |> Enum.sum()
  end
end

IO.puts(Day1.part1())
IO.puts(Day1.part2())
