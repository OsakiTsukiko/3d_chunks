extends Node

const VIEW_DISTANCE = 5
const CHUNK_SIZE = 10

var chunk = preload("res://chunk.tscn")
var actor = preload("res://actor.tscn")

onready var chunk_cont = $chunks
onready var actor_cont = $actor

var player: KinematicBody

func coords_to_chk_coords ( coord: int ) -> int:
	return int(floor(coord/CHUNK_SIZE))

func coords_to_chk_coords_v2 ( coords: Vector2 ) -> Vector2:
	return Vector2(floor(coords.x/CHUNK_SIZE), floor(coords.y/CHUNK_SIZE))
	
func coords_to_chk_coords_v3 ( coords: Vector3 ) -> Vector3:
	return Vector3(floor(coords.x/CHUNK_SIZE), floor(coords.y/CHUNK_SIZE), floor(coords.z/CHUNK_SIZE))

func handle_chunks ():
	var player_pos = Vector3(floor(player.global_transform.origin.x), floor(player.global_transform.origin.y), floor(player.global_transform.origin.z))
	player_pos = coords_to_chk_coords_v3(player_pos)
	var good_idx = []
	var good_coords = []
	var bad_idx = []
	var idx = 0
	for chk in chunk_cont.get_children():
		var chk_off: Vector3 = coords_to_chk_coords_v3(chk.global_transform.origin)
		if (
			chk_off.x >= player_pos.x - VIEW_DISTANCE &&
			chk_off.x <= player_pos.x + VIEW_DISTANCE &&
			chk_off.z >= player_pos.z - VIEW_DISTANCE &&
			chk_off.z <= player_pos.z + VIEW_DISTANCE
		):
			good_idx.push_back(idx)
			good_coords.push_back(Vector2(chk_off.x, chk_off.z))
		else: 
			bad_idx.push_back(idx)
		idx += 1
#	print(good_idx.size(), " ", bad_idx.size())
	for x in range(player_pos.x - VIEW_DISTANCE, player_pos.x + VIEW_DISTANCE + 1):
		for z in range(player_pos.z - VIEW_DISTANCE, player_pos.z + VIEW_DISTANCE + 1):
			if !(good_coords.has(Vector2(x, z))):
				var local_idx = bad_idx.pop_front()
				chunk_cont.get_child(local_idx).set_translation(Vector3(x, 0, z) * CHUNK_SIZE)
	pass

func _ready():
	for x in range(-VIEW_DISTANCE, VIEW_DISTANCE + 1):
		for z in range(-VIEW_DISTANCE, VIEW_DISTANCE + 1):
			var chunk_instance = chunk.instance()
			chunk_instance.set_translation(Vector3(x, 0, z) * CHUNK_SIZE)
			chunk_cont.add_child(chunk_instance)
	
	player = actor.instance()
	player.set_translation(Vector3(0, 3, 0))
	actor_cont.add_child(player)
	pass

func _process(delta):
	handle_chunks()
