defmodule BirdieMachineWeb.StatController do
  use BirdieMachineWeb, :controller

  def index(conn, _params) do
    BirdieMachine.load_data()

    render(conn, :index, layout: false)
  end
end
