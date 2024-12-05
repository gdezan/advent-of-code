defmodule Day4 do
  defp completes_word(_letter_matrix, _i, _j, word, curr_word, _dir)
       when curr_word == word do
    1
  end

  defp completes_word(letter_matrix, i, j, word, curr_word, nil) do
    next_letter = String.at(word, String.length(curr_word))

    Enum.reduce(-1..1, 0, fn x, acc ->
      Enum.reduce(-1..1, acc, fn y, acc ->
        if i + x >= 0 && i + x < Enum.count(letter_matrix) &&
             j + y >= 0 && j + y < Enum.count(Enum.at(letter_matrix, i + x)) &&
             Enum.at(Enum.at(letter_matrix, i + x), j + y) == next_letter do
          completes_word(letter_matrix, i + x, j + y, word, curr_word <> next_letter, [x, y]) +
            acc
        else
          acc
        end
      end)
    end)
  end

  defp completes_word(letter_matrix, i, j, word, curr_word, [x, y]) do
    next_letter = String.at(word, String.length(curr_word))

    if i + x >= 0 && i + x < Enum.count(letter_matrix) &&
         j + y >= 0 && j + y < Enum.count(Enum.at(letter_matrix, i + x)) &&
         Enum.at(Enum.at(letter_matrix, i + x), j + y) == next_letter do
      completes_word(letter_matrix, i + x, j + y, word, curr_word <> next_letter, [x, y])
    else
      0
    end
  end

  def part1(input) do
    word = "XMAS"

    letter_matrix =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    initial_letter = String.at(word, 0)

    letter_matrix
    |> Enum.with_index()
    |> Enum.map(fn {row, i} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn
        {letter, j}
        when letter == initial_letter ->
          completes_word(letter_matrix, i, j, word, initial_letter, nil)

        _ ->
          0
      end)
    end)
    |> Enum.map(fn x -> Enum.sum(x) end)
    |> Enum.sum()
  end

  defp completes_word_with_A(_letter_matrix, i, j, curr_word, [x, y])
       when curr_word == "MAS" do
    a_pos = {i - x, j - y}
    a_pos
  end

  defp completes_word_with_A(letter_matrix, i, j, curr_word, nil) do
    next_letter = String.at("MAS", String.length(curr_word))

    x_directions = [[-1, -1], [-1, 1], [1, -1], [1, 1]]

    Enum.reduce(x_directions, [], fn [x, y], acc ->
      if i + x >= 0 && i + x < Enum.count(letter_matrix) &&
           j + y >= 0 && j + y < Enum.count(Enum.at(letter_matrix, i + x)) &&
           Enum.at(Enum.at(letter_matrix, i + x), j + y) == next_letter do
        a_pos =
          completes_word_with_A(letter_matrix, i + x, j + y, curr_word <> next_letter, [x, y])

        [a_pos | acc]
      else
        acc
      end
    end)
  end

  defp completes_word_with_A(letter_matrix, i, j, curr_word, [x, y]) do
    next_letter = String.at("MAS", String.length(curr_word))

    if i + x >= 0 && i + x < Enum.count(letter_matrix) &&
         j + y >= 0 && j + y < Enum.count(Enum.at(letter_matrix, i + x)) &&
         Enum.at(Enum.at(letter_matrix, i + x), j + y) == next_letter do
      completes_word_with_A(letter_matrix, i + x, j + y, curr_word <> next_letter, [x, y])
    else
      []
    end
  end

  def part2(input) do
    word = "MAS"

    letter_matrix =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    initial_letter = String.at(word, 0)

    letter_matrix
    |> Enum.with_index()
    |> Enum.map(fn {row, i} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn
        {letter, j}
        when letter == initial_letter ->
          completes_word_with_A(letter_matrix, i, j, initial_letter, nil)

        _ ->
          []
      end)
    end)
    |> List.flatten()
    |> Enum.reduce(%{}, fn {i, j}, acc ->
      Map.update(acc, {i, j}, 1, &(&1 + 1))
    end)
    |> Map.values()
    |> Enum.filter(&(&1 >= 2))
    |> Enum.count()
  end
end

defmodule Mix.Tasks.Day4 do
  use Mix.Task

  @shortdoc "Day 4"
  def run(args) do
    filename =
      case args do
        ["--test" | _] -> "inputs/day4-test.txt"
        _ -> "inputs/day4.txt"
      end

    input = File.read!(filename)

    IO.puts("--- Part 1 ---")
    IO.inspect(Day4.part1(input))

    IO.puts("--- Part 2 ---")
    IO.inspect(Day4.part2(input))
  end
end
