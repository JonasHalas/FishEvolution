extends CharacterBody2D

@export var size: float = 100
@export var movementSpeed: float = 100
#just to keep track of what direction the sprite should be when moving straight up or down
var lastDirectionRight: bool = true

@onready var camera_2d = $Camera2D
# Get a reference to the body parts
@onready var head = get_node("entireFish/head")
@onready var body = get_node("entireFish/body")
@onready var tail = get_node("entireFish/tail")
@onready var eye = get_node("entireFish/eye")
@onready var finFront = get_node("entireFish/finFront")
@onready var finBot = get_node("entireFish/finBot")
@onready var finTop = get_node("entireFish/finTop")


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
	

func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("Test Button"):
		finFront.change_texture("res://art/fishParts/finFront/claw1.png")
		
	if Input.is_action_just_pressed("Test Button 2"):
		finTop.change_texture("res://art/fishParts/finTop/lightAntenna1.png")
		
	if Input.is_action_just_pressed("Test Button 3"):
		finBot.change_texture("res://art/fishParts/finBot/legs1.png")
		
	if Input.is_action_just_pressed("Zoom In"):
		zoom_player_camera()
	if Input.is_action_just_pressed("Zoom Out"):
		zoom_player_camera_out()

func zoom_player_camera() -> void:
	camera_2d.zoom = camera_2d.zoom + Vector2(0.1,0.1)
func zoom_player_camera_out() -> void:
	camera_2d.zoom = camera_2d.zoom - Vector2(0.1,0.1)

