extends Node2D
@onready var animatedSprite = $AnimatedSprite2D
var damage = 80

func _ready():
	animatedSprite.frame = 0
	animatedSprite.play("cast")


func _on_AnimatedSprite_animation_finished():
	queue_free()
