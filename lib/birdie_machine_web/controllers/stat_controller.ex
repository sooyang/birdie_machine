defmodule BirdieMachineWeb.StatController do
  use BirdieMachineWeb, :controller

  def index(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    File.stream!(Path.join(:code.priv_dir(:birdie_machine), "repo/raw_data.csv"))
    |> CSV.decode()
    |> Enum.to_list
    |> IO.inspect

    render(conn, :index, layout: false)
  end
end
