extends Node

@export var mob_scene: PackedScene
var score

const GET_READY_TEXT: String = "Get Ready"

func _ready() -> void:
	#new_game()
	pass

func game_over() -> void:
	$Timers/ScoreTimer.stop()
	%MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$Timers/StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_temp_message(GET_READY_TEXT)
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_mob_timer_timeout() -> void:
	
	var mob_spawn_location = $MobPath/MobSpawnPosition
	mob_spawn_location.progress_ratio = randf()
	
	var mob = mob_scene.instantiate()
	
	var direction = mob_spawn_location.rotation + PI/2
	add_child(mob)
	
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	%MobTimer.start()
	$Timers/ScoreTimer.start()
