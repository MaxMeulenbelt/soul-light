extends Node2D

func _physics_process(delta):
	$Lantern.playerPos = $Player.global_position
	$Lantern.cursorPos = $Player.get_global_mouse_position()
	$Player.lanternPos = $Lantern.global_position

func _on_Button_pressed():
	get_tree().reload_current_scene()
