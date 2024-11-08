extends AnimatedSprite2D

@export var tilemap_dual: TileMapLayer = null
@export var item_scene: PackedScene

var cell: Vector2i
var tile_size: Vector2
var sprite_size: Vector2
var atlas_id = 0

# Hareket geçiş hızı için bir katsayı (yavaşlatmak için küçük bir değer seçin)
@export var move_speed: float = 15.0 

func _ready() -> void:
	if tilemap_dual != null:
		tile_size = tilemap_dual.tile_set.tile_size
		scale = Vector2(tile_size.y, tile_size.y) / 17
		self.set_scale(scale)

func _process(_delta: float) -> void:
	if tilemap_dual == null:
		return
	
	if Input.is_action_just_released("click"):
		spawn_item()

	# Fare pozisyonunu haritaya göre al
	var target_position = tilemap_dual.map_to_local(tilemap_dual.local_to_map(get_global_mouse_position()))

	# Lerp ile yumuşatılmış hareket geçişi
	global_position = global_position.lerp(target_position, move_speed * _delta)

func spawn_item():
	if item_scene == null:
		return
	
	# Yeni item instance oluştur
	var item_instance = item_scene.instantiate()
	get_tree().current_scene.add_child(item_instance)
	
	# Mouse pozisyonuna göre item'i yerleştir
	item_instance.global_position = get_global_mouse_position()
