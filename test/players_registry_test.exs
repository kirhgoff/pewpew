defmodule Pewpew.PlayerRegistryTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, registry} = Pewpew.PlayerRegistry.start_link
    {:ok, registry: registry}
  end

 	test "creates players", %{registry: registry} do
    assert Pewpew.PlayerRegistry.lookup(registry, "kirill") == nil

    Pewpew.PlayerRegistry.create(registry, %{name: "kirill", health: 100})
    player = Pewpew.PlayerRegistry.lookup(registry, "kirill")

    assert player != nil
    assert Pewpew.Player.is_alive?(player) == true
  end
end
