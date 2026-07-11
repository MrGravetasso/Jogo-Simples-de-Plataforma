extends CharacterBody2D

const CoinRigid := preload("res://prefabs/coin-rigid.tscn")

@onready var Animator := $Animator as AnimationPlayer
@onready var SpawnCoin := $Marker2D as Marker2D
@export var hitpoints := 3


func break_sprite():
	queue_free()

func spawn_coin():
	var Coin = CoinRigid.instantiate()
	get_parent().call_deferred("add_child", Coin)
	Coin.global_position = SpawnCoin.global_position
	Coin.apply_impulse(Vector2(randi_range(-50, 50), -150))
	
