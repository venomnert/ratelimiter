defmodule RatelimiterTest do
  use ExUnit.Case
  doctest Ratelimiter

  test "greets the world" do
    assert Ratelimiter.hello() == :world
  end
end
