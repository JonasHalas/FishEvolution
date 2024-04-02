extends CharacterBody2D

@export var size: float = 100
@export var movementSpeed: float = 100
#just to keep track of what direction the sprite should be when moving straight up or down
var lastDirectionRight: bool = true

var inputDirection: Vector2 = Vector2(0,0)

func _ready():
	inputDirection = Vector2.ZERO

func _physics_process(_delta):
	
	#sets direction of character based on input
	inputDirection = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	)
#updates velocity
	velocity = inputDirection.normalized() * movementSpeed
	#allows us to move
	move_and_slide()

