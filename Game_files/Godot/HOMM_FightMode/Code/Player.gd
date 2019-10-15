extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2()
var speed  = 200
var init = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	vel.x = 0
	if Input.is_action_pressed("ui_right"):
		vel.x += speed
	if Input.is_action_pressed("ui_left"):
		vel.x -= speed

	move_and_slide(vel)