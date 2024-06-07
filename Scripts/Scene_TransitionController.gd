extends CanvasLayer


func changeScene(target):
	$fillRect/AnimationPlayer.play("Dissolve")
	await $fillRect/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$fillRect/AnimationPlayer.play_backwards("Dissolve")
