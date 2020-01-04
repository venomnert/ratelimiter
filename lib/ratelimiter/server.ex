defmodule Ratelimiter.Server do
  use GenServer

  @max_per_minute 5
  @sweep_after :timer.seconds(60)

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    reset_requests()
    {:ok, %{requests: 0}}
  end

  def handle_call(:update, _from, state) do
    case state.requests do
      count when count < @max_per_minute ->
        {:reply, {:ok, :updated}, %{state | requests: state.requests + 1}}

      count when count >= @max_per_minute ->
        {:reply, {:error, :limit_reached}, state}
    end
  end

  def handle_info(:reset, state) do
    reset_requests()
    {:noreply, %{state | requests: 0}}
  end

  def reset_requests() do
    Process.send_after(self(), :reset, @sweep_after)
  end
end
