defmodule Day4 do
  def get_wins_arr(input) do
    input
    |> String.split("\r\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("\: ", trim: true)
      |> List.last()
      |> String.split(" | ", trim: true)
      |> Enum.map(fn x ->
        x
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
    end)
    |> Enum.map(fn [winning, played] ->
      played
      |> Enum.reduce(0, fn x, acc ->
        if Enum.member?(winning, x), do: acc + 1, else: acc
      end)
    end)
  end

  def distribute_cards(wins_arr) do
    wins_and_cards =
      wins_arr
      |> Enum.map(fn wins ->
        %{wins: wins, cards: 1}
      end)

    wins_and_cards
    |> Enum.with_index()
    |> Enum.reduce(wins_and_cards, fn {card, index}, acc ->
      acc_card = Enum.at(acc, index)

      acc =
        case card.wins do
          0 ->
            acc

          _ ->
            Enum.reduce((index + 1)..(index + card.wins), acc, fn i, curr_acc ->
              case Enum.at(curr_acc, i) do
                nil ->
                  curr_acc

                _ ->
                  List.update_at(curr_acc, i, fn curr_card ->
                    Map.put(curr_card, :cards, curr_card.cards + acc_card.cards)
                  end)
              end
            end)
        end

      acc
    end)
  end

  def part1(input) do
    input
    |> get_wins_arr()
    |> Enum.map(fn wins ->
      if wins == 0, do: 0, else: 2 ** (wins - 1)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> get_wins_arr()
    |> distribute_cards()
    |> Enum.map(fn card ->
      card.cards
    end)
    |> Enum.sum()
  end
end

defmodule Mix.Tasks.Day4 do
  use Mix.Task

  @shortdoc "Day 4"
  def run(_) do
    input = File.read!("inputs/day4.txt")

    IO.puts("--- Part 1 ---")
    IO.inspect(Day4.part1(input))
    IO.puts("\n--- Part 2 ---")
    IO.inspect(Day4.part2(input))
  end
end
