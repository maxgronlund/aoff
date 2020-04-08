defmodule AOFF.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      AOFF.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: AOFF.Supervisor)
  end
end
