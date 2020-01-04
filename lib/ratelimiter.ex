defmodule Ratelimiter do
  def start() do
    {:ok, pid} = DynamicSupervisor.start_child(Ratelimiter.DynamicSupervisor, Ratelimiter.Server)
    pid
  end

  def make_request(pid) do
    GenServer.call(pid, :update)
  end

  def make_request_ets(uid) do
    Ratelimiter.ServerEts.log(uid)
  end
end
