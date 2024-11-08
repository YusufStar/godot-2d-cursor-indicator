extends Node2D

var initial_speed: float
var throw_angle_degrees: float
const gravity: float = 9.8
var time: float = 0.0

var initial_position: Vector2
var throw_direction: Vector2

var z_axis: float = 10.0
var is_launch: bool = false
var has_reached_target: bool = false

var time_mult: float = 7.0
var radius: float = 70.0

@onready var projectile_sprite = $Projectile

# Obje sahneye yüklendiğinde tetiklenecek
func _ready():
	var target_position = get_random_position_within_radius(radius)
	print("Target Position:", target_position)
	
	# Yönü hesapla
	var direction = (target_position - projectile_sprite.position).normalized()
	print("Direction:", direction)
	
	var distance = projectile_sprite.position.distance_to(target_position)
	LaunchProjectile(projectile_sprite.position, direction, distance, 45)

func _process(delta):
	if is_launch:
		time += delta * time_mult
		
		# Z eksenindeki hareketi hesapla
		z_axis = initial_speed * sin(deg_to_rad(throw_angle_degrees)) * time - 0.5 * gravity * pow(time, 2)
		
		if z_axis > 0:
			# X ve Y eksenlerindeki hareketi hesapla
			var x_axis: float = initial_speed * cos(deg_to_rad(throw_angle_degrees)) * time
			var new_position = initial_position + throw_direction * x_axis
			
			# Projectile'ın pozisyonunu ayarla (hem X hem Y ekseninde)
			projectile_sprite.position = Vector2(new_position.x, new_position.y - z_axis)
		else:
			# Hareket sona erdiğinde
			if not has_reached_target:
				has_reached_target = true
				is_launch = false

# Fırlatma fonksiyonu
func LaunchProjectile(initial_pos: Vector2, direction: Vector2, desired_distance: float, desired_angle_deg: float):
	initial_position = initial_pos
	throw_direction = direction.normalized()
	
	throw_angle_degrees = desired_angle_deg
	initial_speed = pow(desired_distance * gravity / sin(2 * deg_to_rad(desired_angle_deg)), 0.5)
	
	time = 0.0
	z_axis = 0.0
	is_launch = true
	has_reached_target = false

func get_random_position_within_radius(radius: float) -> Vector2:
	# 0 ile 360 derece arasında rastgele bir açı seç
	var angle = randf_range(0, 2 * PI)
	# X ekseni için radius, Y ekseni için radius / 2 mesafesi seç
	var distance_x = randf_range(0, radius)
	var distance_y = randf_range(0, radius / 2)
	
	# Yeni X ve Y koordinatlarını döndür
	return Vector2(cos(angle) * distance_x, sin(angle) * distance_y)
