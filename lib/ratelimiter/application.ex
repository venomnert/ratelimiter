defmodule Ratelimiter.Application do
  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Ratelimiter.DynamicSupervisor},
      {Ratelimiter.ServerEts, []}
    ]

    opts = [strategy: :one_for_one, name: Ratelimiter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
