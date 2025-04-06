extends Node2D

@onready var animatedSprite = $AnimatedSprite2D

var health = 100
var max_hp = 100
var hp_regen = 10

func _ready():
	animatedSprite.frame = 0
	animatedSprite.play("default")
	
func _process(delta):
	health = min(health + hp_regen * delta, max_hp)
	$Label.text = str(round(health))
	
func _on_Hurtbox_area_entered(area):
	health -= area.get_parent().get("damage")
	if health > 0:
		$AnimationPlayer.play("Hit")
	else:
		queue_free()

func _on_AnimatedSprite_animation_finished():
	pass # Replace with function body.
