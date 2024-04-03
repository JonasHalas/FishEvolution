extends CharacterBody2D



@export var sizeSpecific: float = 0
@export var sizeMin: float = .05
@export var sizeMax: float = .15
@export var movementSpeed: float = 70
@export var visionRange: int = 200
@export var fleesFromPlayer: bool = true
@export var chasesPlayer: bool = true
@export var rotationSpeed: float = 0.5
	
@onready var player = $"../Player"
@onready var timer = $Timer
var isBiggerThanPlayer: bool = false
var turnTimerMin: float = 2
var turnTimerMax: float = 4
# visionRange scales with size
var trueVisionRange: float = visionRange * scale.x * 10

#random starting movement direction 
var movementDirection: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1))
var newMovementDirection: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1))
var isNotInRangeOfPlayer: bool = true


var size: float = 0

func _ready():
	
	# sets the size of the enemy, if no specific size is set, it will be within the range of sinzeMin and sizeMax
	if sizeSpecific == 0:
		size = randf_range(sizeMin, sizeMax)
	else:
		size = sizeSpecific
	scale = Vector2(size, size)
	
	trueVisionRange = visionRange * scale.x * 10
	isBiggerThanPlayer = player.scale < scale
	
	#starts time for random movement
	timer.start(randf_range(turnTimerMin, turnTimerMax))
	
func _physics_process(delta):
	
	if playerNearby():
		chaseOrFlee()
		isNotInRangeOfPlayer = false
		movementDirection = movementDirection.lerp(newMovementDirection, (rotationSpeed + rotationSpeed) * delta)
	else:
		$ColorRect.color = Color(1, 1, 1)
		isNotInRangeOfPlayer= true
		movementDirection = movementDirection.lerp(newMovementDirection, rotationSpeed * delta)
	
	
	
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
		
#returns true if player is within "trueVisionRange"
func playerNearby() -> bool:
	return position.distance_to(player.global_position) <= trueVisionRange
	
	#flees if smaller than player, chases if larger than player. TODO add a middle ground where fish ignores player?
func chaseOrFlee():
	if fleesFromPlayer && !isBiggerThanPlayer:
		$ColorRect.color = Color(0.792, 0.141, 1) # just to indicate if chasing. remove later	
		newMovementDirection = -(player.global_position - global_position).normalized()
		
	if chasesPlayer && isBiggerThanPlayer:
		$ColorRect.color = Color(0.843, 0, 0.11) # just to indicate if chasing. remove later	
		newMovementDirection = (player.global_position - global_position).normalized()
		
		
#fish changes direction here and there if not chased or chasing
func _on_timer_timeout():
	if isNotInRangeOfPlayer:
		newMovementDirection = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	timer.start(randf_range(turnTimerMin, turnTimerMax))
