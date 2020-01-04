defmodule Ratelimiter.ServerEts do
  use GenServer

  @max_per_minute 5
  @sweep_after :timer.seconds(60)
  @ets_name :rate_limited

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    reset_requests()

    :ets.new(@ets_name, [
      :set,
      :named_table,
      :public,
      read_concurrency: true,
      write_concurrency: true
    ])

    {:ok, %{}}
  end

  def log(uid) do
    case :ets.update_counter(@ets_name, uid, {2, 1}, {uid, 0}) do
      count when count > @max_per_minute -> {:error, :rate_limited}
      _count -> :ok
    end
  end

  def handle_info(:reset, state) do
    :ets.delete_all_objects(@ets_name)
    reset_requests()
    {:noreply, state}
  end

  def reset_requests() do
    Process.send_after(self(), :reset, @sweep_after)
  end
end
