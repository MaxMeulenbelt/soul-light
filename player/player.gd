extends CharacterBody2D

@onready var timer = $Timer
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var lanternPos = Vector2(0,0)
@onready var animationState = animationTree.get("parameters/playback")

enum {MOVE,DASH,ATTACK}
var state = MOVE

enum TimerMode {DASH_DURATION, DASH_COOLDOWN}
var timer_mode = DASH_DURATION
const DASH_SPEED = 350
const DASH_DURATION = 0.1
const DASH_COOLDOWN = 4.0

const ACCELERATION = 600
const MAX_SPEED = 150
const FRICTION = 500
const ACTIVE_DECELERATION = 600

func _ready():
	#animationTree.active = true
	timer.one_shot = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		DASH:
			dash_state(delta)
		ATTACK:
			attack_state(delta)

func move(delta):
	var inputDirection = Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	
	if inputDirection:
		if inputDirection.dot(velocity) > 0:
			velocity = velocity.move_toward(inputDirection*MAX_SPEED, ACCELERATION*delta)
		else:
			velocity = velocity.move_toward(inputDirection*MAX_SPEED, ACTIVE_DECELERATION*delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
	move_and_slide()

func move_state(delta):
	#animationState.travel("Run")
	animationPlayer.play("Run")
	move(delta)
	if Input.is_action_just_pressed("ui_accept") and timer.is_stopped():
		state = DASH
		timer_mode = TimerMode.DASH_DURATION
		timer.wait_time = DASH_DURATION
		timer.start()
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		state = ATTACK
	
func dash_state(delta):
	animationState.travel("Dash")
	var inputDirection = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	if inputDirection:
		velocity = inputDirection * DASH_SPEED
	move_and_slide()

func attack_state(delta):
	move(delta)
	create_ice_shard_effect()
	state = MOVE
	
func create_ice_shard_effect():
	var IceShard = load("res://spells/ice_shard/ice_shard.tscn")
	var iceShard = IceShard.instantiate()
	var main = get_tree().current_scene
	main.add_child(iceShard)
	iceShard.position = get_global_mouse_position()

func _on_timer_timeout() -> void:
	print(timer_mode)
	if timer_mode == TimerMode.DASH_DURATION:
		timer_mode = TimerMode.DASH_COOLDOWN  # Switch mode to cooldown
		timer.wait_time = DASH_COOLDOWN
		timer.start()  # Start cooldown timer
		state = MOVE  # End dash and return to move state

	elif timer_mode == TimerMode.DASH_COOLDOWN:
		pass
