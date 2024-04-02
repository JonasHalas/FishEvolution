extends Sprite2D


@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	 # Get a reference to the AnimationPlayer node
	animation_player.play("base")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
# send a ress:// path to this body part
func change_texture(texture_path: String):
	# Load a new texture
	var new_texture = load(texture_path)
	
	# Set the new texture
	texture = new_texture
