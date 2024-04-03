extends CharacterBody2D

@export var sizeSpecific: float = 0
@export var sizeMin: float = .05
@export var sizeMax: float = .15
@export var movementSpeed: float = 70
#random starting movement direction 
var movementDirection: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1))

var size: float = 0

func _ready():
	
	# sets the size of the enemy, if no specific size is set, it will be within the range of sinzeMin and sizeMax
	if sizeSpecific == 0:
		size = randf_range(sizeMin, sizeMax)
	else:
		size = sizeSpecific
	scale = Vector2(size, size)
	
func _physics_process(_delta):
	
	#updates rotation
	rotate_character_body(movementDirection)
	#updates velocity
	velocity = movementDirection.normalized() * movementSpeed


	move_and_slide()



# Rotate a CharacterBody2D node based on its velocity vector
func rotate_character_body(velocity2: Vector2) -> void:
	#if fish is moving right and is not flipped, flip it
	if velocity2.x < 0 && scale.y > 0:
		scale.y = -scale.y
	#if fish is moving right and is not flipped, flip it
	elif velocity2.x > 0 && scale.y < 0:
		scale.y = -scale.y
	
		# rotates character according to direction. This can be simplified without degreeconversion, but in case i need the degrees in the future, im leavin as is
	if velocity2 != Vector2.ZERO:  # Ensure velocity is non-zero to avoid division by zero
		#calculates the radan
		var angle = atan2(velocity2.y, velocity2.x)
		# converts radan to degrees because radans are hard :(
		var degrees = rad_to_deg(angle)
		# Apply the rotation to the character body
		rotation_degrees = degrees

