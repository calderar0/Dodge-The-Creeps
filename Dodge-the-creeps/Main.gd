extends Node

@export var mob_scene: PackedScene
var score


func game_over():
	get_tree().call_group("mobs", "queue_free")
	$ScoreTimer.stop()
	$StartTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()
	

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()

	# chose a random place of mobpath
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# set the mob direction
	var direction = mob_spawn_location.rotation + PI / 2

	# make the mob spawn in random location
	mob.position = mob_spawn_location.position

	# make it even more random
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# randomize the mob speed
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# spawn the mob
	add_child(mob)
