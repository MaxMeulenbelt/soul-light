extends CharacterBody2D

const MAX_SPEED = 10
var reach = 100

@onready var animationPlayer = $AnimationPlayer
@onready var playerPos = Vector2(0,0)
@onready var cursorPos = Vector2(0,0)

func _ready():
	animationPlayer.play("idlePink")
	
func _physics_process(delta):
	
	var playerToCursor : Vector2 = cursorPos - playerPos
	
	var playerCursorDistance = playerToCursor.length()
	
	var distance = min(reach,playerCursorDistance)
	
	var target = playerToCursor.normalized() * distance + playerPos
	
	var targetDistance : Vector2 = target - position
	#calculates the speed based on the distance to the edge of the reach that intersects the player to mouse vector
	var speed = tanh(0.02 * targetDistance.length()) * MAX_SPEED
	velocity = targetDistance * speed
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
	
	
