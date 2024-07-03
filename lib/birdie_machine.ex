defmodule BirdieMachine do
  @moduledoc """
  BirdieMachine keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def load_data() do
    rounds = File.stream!(
      Path.join(:code.priv_dir(:birdie_machine), "repo/raw_data.csv")
    )
    |> CSV.decode!(headers: true)
    |> Enum.to_list()
    |> Enum.group_by(fn data ->
      data["Date"]
    end)
    |> Enum.reject(fn data -> elem(data, 0) == ""
    end)
    # Stats per round
    |> Enum.map(fn {date, datas} ->
      {
        date,
        %{
          fairways: count_category_score("Fairways", datas),
          fairways_total: count_category_total("Fairways", datas),
          gir: count_category_score("GIR", datas),
          gir_total: count_category_total("GIR", datas),
          scrambling: count_category_score("U&D", datas),
          scrambling_total: count_category_total("U&D", datas),
          sand: count_category_score("Sand Save", datas),
          sand_total: count_category_total("Sand Save", datas),
          putts: count_category_score("Putts", datas),
        }
      }
    end)
    # Average per round
    |> Enum.map(fn {date, datas} ->
      {
        date,
        %{
          average_fairways: category_average("fairways", datas),
          average_gir: category_average("gir", datas),
          average_scrambling: category_average("scrambling", datas),
          average_sand: category_average("sand", datas),
          putts: datas[String.to_atom("putts")]
        }
      }
    end)

    season_rounds = rounds
    |> Enum.count()

    %{
      season_fairway: season_average("average_fairways", season_rounds, rounds),
      season_gir: season_average("average_gir", season_rounds, rounds),
      season_scrambling: season_average("average_scrambling", season_rounds, rounds),
      season_sands: season_average("average_sand", season_rounds, rounds),
      season_putts: season_average("putts", season_rounds, rounds),
    }

    # Average accross all rounds played
    |> IO.inspect
  end

  defp count_category_score(key, datas) do
    total = Enum.reduce(datas, 0, fn data, acc ->
      if data[key] == "" ||  data[key] == "-" do
        acc + 0
      else
        acc + String.to_integer(data[key])
      end
    end)

    total
  end

  defp count_category_total(key, datas) do
    total = Enum.reduce(datas, 0, fn data, acc ->
      if data[key] != "-"  do
        acc + 1
      else
        acc + 0
      end
    end)

    total
  end

  defp category_average(key, datas) do
    datas[String.to_atom(key)] / datas[String.to_atom(key <> "_total")]
  end

  defp season_average(key, season_rounds, datas) do
    sum = datas
    |> Enum.reduce( 0, fn { _, data }, acc ->
      acc + data[String.to_atom(key)]
    end)

    sum / season_rounds
  end
end
