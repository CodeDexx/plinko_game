extends Node2D


# Score
@onready var scoreLabel = %ScoreLabel
var score_count := 0


var current_ball: RigidBody2D

# Pegs
@onready var peg_scene = preload("res://Scenes/peg.tscn")
@export var rows = 5
@export var pegs_per_row = 9
@export var spacing_x = 70.0
@export var spacing_y = 50.0
@export var start_pos = Vector2(100, 300)

# Ball
@onready var ball_scene = preload("res://Scenes/ball.tscn")
var spawn = Vector2(404, 60)

@export var launch_strength = 600

# func _process(delta: float) -> void:
	#print(current_ball)

func _ready(): 
	for row in range(rows):
		for col in range(pegs_per_row):
			var peg = peg_scene.instantiate()
			
			var offset_x = ((row + 1) % 2) * (spacing_x / 2.0)
			
			peg.position = Vector2(
				start_pos.x + col * spacing_x + offset_x,
				start_pos.y + row * spacing_y
			)
			add_child(peg)
			
	current_ball = ball_scene.instantiate() as RigidBody2D
	#print("Start: " + current_ball.to_string())
	add_child(current_ball)
	current_ball.global_position = spawn
	current_ball.freeze = true
	

# Controls red area2D
func _on_red_block_left_body_entered(body: Node2D) -> void:
	set_score(score_count - 1)
	reset_ball()

# Controls red area2D
func _on_red_block_right_body_entered(body: Node2D) -> void:
	set_score(score_count - 1)
	reset_ball()
	
# Controls green area2D
func _on_green_block_body_entered(body: Node2D) -> void:
	set_score(score_count + 3)
	reset_ball()

# Modifies the label that displays the points.
func set_score(new_score_count: int) -> void:
	score_count = new_score_count
	scoreLabel.text = "Score: " + str(score_count)
	
# Receives position of mouse click of user and determines vector.
func _input(event):
	var mouse_position : Vector2
	if event is InputEventMouseButton and event.pressed:
		mouse_position = get_global_mouse_position()
		# print("Mouse clicked at: ", mouse_position)
		if current_ball.freeze == true:
			launch(mouse_position)

# Launches the ball
func launch (mouse_position: Vector2):
	current_ball.freeze = false
	var direction = (mouse_position - current_ball.global_position).normalized()
	var force = direction * launch_strength
	current_ball.apply_impulse(force)

# Resets ball at the top after it enters a zone.
func reset_ball ():
	current_ball = ball_scene.instantiate() as RigidBody2D
	current_ball.global_position = spawn
	current_ball.set_freeze_enabled(true)
	add_child(current_ball)
