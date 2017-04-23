defmodule Pewpew.PlayerRegistryTest do
  use ExUnit.Case, async: true

  setup context do
    {:ok, registry} = Pewpew.PlayerRegistry.start_link(context.test)
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

  test "removes player on crash", %{registry: registry} do
    player = create_fixture(registry)
    ref = Process.monitor(player)
    Process.exit(player, :shutdown)

    assert_receive {:DOWN, ^ref, _, _, _}

    assert Pewpew.PlayerRegistry.lookup(registry, "kirill") == nil
  end

  def create_fixture(registry) do
    Pewpew.PlayerRegistry.create(registry, %{name: "kirill", health: 100})
    assert (player = Pewpew.PlayerRegistry.lookup(registry, "kirill")) != nil

    player
  end

end
