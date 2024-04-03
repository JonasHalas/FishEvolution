extends CharacterBody2D

@export var size: float = .1
@export var movementSpeed: float = 70
#random starting movement direction 
var movementDirection: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1))

func _physics_process(_delta):
	
	#updates velocity
	velocity = movementDirection.normalized() * movementSpeed


	move_and_slide()
