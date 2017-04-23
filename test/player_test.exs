defmodule Pewpew.PlayerTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, player} = Pewpew.Player.start(%{name: "kirill", health: 100.0})
    {:ok, player: player}
  end

  test "player health", %{player: player} do
  	assert Pewpew.Player.health(player) == 100.0
  end

  test "player is_alive", %{player: player} do
  	assert Pewpew.Player.is_alive?(player) == true
  end

  test "player damage", %{player: player} do
  	Pewpew.Player.damage(player, 66.0)
  	assert Pewpew.Player.health(player) == 34.0
  end

  test "player dies", %{player: player} do
    Pewpew.Player.damage(player, 99.0)
    assert Pewpew.Player.is_alive?(player) == true

    Pewpew.Player.damage(player, 1.0)
    assert Pewpew.Player.is_alive?(player) == false
  end
end