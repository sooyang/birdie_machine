defmodule BirdieMachine.Repo do
  use Ecto.Repo,
    otp_app: :birdie_machine,
    adapter: Ecto.Adapters.Postgres
end
