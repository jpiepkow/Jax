defmodule JaxTest do
  use ExUnit.Case
  doctest Jax

  test "greets the world" do
    assert Jax.hello() == :world
  end
end
