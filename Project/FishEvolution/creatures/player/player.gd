extends CharacterBody2D

@export var size: float = 100
@export var movementSpeed: float = 100


#just to keep track of what direction the sprite should be when moving straight up or down
@onready var camera_2d = $Camera2D

# Get a reference to the body parts
@onready var head = get_node("CollisionShape2D/entireFish/head")
@onready var body = get_node("CollisionShape2D/entireFish/body")
@onready var tail = get_node("CollisionShape2D/entireFish/tail")
@onready var eye = get_node("CollisionShape2D/entireFish/eye")
@onready var finFront = get_node("CollisionShape2D/entireFish/finFront")
@onready var finBot = get_node("CollisionShape2D/entireFish/finBot")
@onready var finTop = get_node("CollisionShape2D/entireFish/finTop")
@onready var collision_shape_2d = $CollisionShape2D

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
	
	updateAnimationDirection()


func _unhandled_input(_event: InputEvent) -> void:
	# zoom for testing
	if Input.is_action_just_pressed("Zoom In"):
		zoom_player_camera()
	if Input.is_action_just_pressed("Zoom Out"):
		zoom_player_camera_out()
	# Buttons for testing
	if Input.is_action_just_pressed("Test Button"):
		finFront.change_texture("res://art/fishParts/finFront/claw1.png")
	
	if Input.is_action_just_pressed("Test Button 2"):
		finTop.change_texture("res://art/fishParts/finTop/lightAntenna1.png")
	
	if Input.is_action_just_pressed("Test Button 3"):
		finBot.change_texture("res://art/fishParts/finBot/legs1.png")


func updateAnimationDirection() -> void:
	# Rotating and flipping sprites so that if you go directly up or down, fish is still flipped towards your last direction. Had to brute force this math ;(
	
	if inputDirection.x == 1: #Right
		collision_shape_2d.scale = Vector2(1, 1)
		collision_shape_2d.rotation = 3.6 - rad_to_deg(atan2(inputDirection.x,inputDirection.y))
	
	if inputDirection.x == -1: #Left
		collision_shape_2d.scale = Vector2(1, -1)
		collision_shape_2d.rotation = -(.4 + rad_to_deg(atan2(inputDirection.x,inputDirection.y)))
		
	if inputDirection == Vector2(0, 1): #Straight Down
		if collision_shape_2d.scale == Vector2(1, 1):# and is allready Right
			collision_shape_2d.set_rotation(3.2)
		if collision_shape_2d.scale == Vector2(1, -1):# and is allready Left
			collision_shape_2d.set_rotation(0)
		
	if inputDirection == Vector2(0, -1): #Straigth Up
		if collision_shape_2d.scale == Vector2(1, 1):# and is allready Right
			collision_shape_2d.set_rotation(0)
		if collision_shape_2d.scale == Vector2(1, -1):# and is allready Left
			collision_shape_2d.set_rotation(3.2)


func zoom_player_camera() -> void:
	camera_2d.zoom = camera_2d.zoom + Vector2(0.1,0.1)


func zoom_player_camera_out() -> void:
	camera_2d.zoom = camera_2d.zoom - Vector2(0.1,0.1)
