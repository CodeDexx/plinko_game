extends AnimatableBody2D

@export var speed = 100
@export var left_threshold = 150
@export var right_threshold = 650

func _physics_process(delta: float) -> void:
	if position.x > right_threshold:
		speed = -speed
	if position.x < left_threshold: 
		speed = -speed
	
	position.x += speed * delta
