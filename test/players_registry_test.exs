defmodule Pewpew.PlayerRegistryTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, registry} = Pewpew.PlayerRegistry.start_link
    {:ok, registry: registry}
  end

 	test "creates players", %{registry: registry} do
    assert Pewpew.PlayerRegistry.lookup(registry, "kirill") == nil
    assert Pewpew.Player.is_alive?(create_fixture(registry)) == true
  end

  test "removes player on exit", %{registry: registry} do
    GenServer.stop(create_fixture(registry))
    assert Pewpew.PlayerRegistry.lookup(registry, "kirill") == nil
  end

  def create_fixture(registry) do
    Pewpew.PlayerRegistry.create(registry, %{name: "kirill", health: 100})
    assert (player = Pewpew.PlayerRegistry.lookup(registry, "kirill")) != nil

    player
  end

end
