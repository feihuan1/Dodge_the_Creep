extends Area2D

signal hit

@export var speed: float = 400

var screen_size: Vector2
var velocity: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

func _process(delta: float) -> void:
	get_input()
	player_movement(delta)
	update_animation()


func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if(Input.is_action_pressed("ui_accept")):
		start(Vector2.ZERO)

func player_movement(delta):
	if(velocity.length() > 0):
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func update_animation():
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y !=0:
		$AnimatedSprite2D.animation = 'up'
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(_body: Node2D) -> void:
	hide()
	hit.emit()
	
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos: Vector2):
	position = pos
	show()
	$CollisionShape2D.disabled = false
