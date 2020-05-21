extends KinematicBody
 
const MOVE_SPEED = 3
 
onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer
 
var player = null
var dead = false

var health := 100
 
func _ready():
	anim_player.play("walk")
	add_to_group("zombies")
 

func _physics_process(delta):
	if dead:
		return
	if player == null:
		anim_player.stop()
		$Sprite3D.frame = 0
		return
   
	var vec_to_player = player.translation - translation
	vec_to_player = vec_to_player.normalized()
	raycast.cast_to = vec_to_player * 1.5
	
	# Applying gravity to movement vector
	vec_to_player.y = -10
   
	move_and_collide(vec_to_player * MOVE_SPEED * delta)
   
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == "Player":
			coll.kill()


func damage():
	health -= 25
	if health <= 0:
		$DetectionArea.monitoring = false
		$DetectionArea/CollisionShape.disabled = true
		$CollisionShape.disabled = true
		anim_player.play("death")
		dead = true
		return
	
	anim_player.stop()
	anim_player.play("hit")
   
 
func kill():
	pass
 
func set_player(p):
	player = p
	print(player)
