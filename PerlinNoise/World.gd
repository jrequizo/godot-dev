extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var canvas_size

export var perlin_grid_x = 1
export var perlin_grid_y = 1


# Fractal Brownian Motion Controls
export var octaves = 8
export var lacunarity = 3
export var gain = 0.5
export var amplitude = 0.5

var offset_x = 0
var offset_y = 0

onready var generator_seed

export var max_threads = 4
var current_threads = 0
var threads = []

# Called when the node enters the scene tree for the first time.
func _ready():
	canvas_size = get_viewport().size
	
	# Populate the thread pool
	for i in max_threads:
		threads.append(Thread.new())
	
	randomize()
	generator_seed = randi()
	
	_perlin_noise()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_pressed("keyboard_enter")):
		print("generating...")
		_perlin_noise()


func _perlin_noise():
	randomize()
	generator_seed = randi()
	var result = _generate_perlin_noise_texture()
	$Output.texture = result


func _generate_perlin_noise_texture():	
	# Generate the noise on the specific pixel
	var image = Image.new()
	image.create(canvas_size.x, canvas_size.y, false, Image.FORMAT_RGB8)
	
	image.lock()
	
	for _y in canvas_size.y:
		for _x in canvas_size.x:
			var has_found_thread = false
			while !has_found_thread:
				for i in max_threads:
					if !threads[i].is_active():
						var params = {
							"i": i,
							"x": _x,
							"y": _y,
							"canvas_size": canvas_size,
							"image": image
						}
						
						threads[i].start(self, "_create_thread_worker", params)
						current_threads += 1
						has_found_thread = true
						break
						
				if (!has_found_thread):
					_wait_for_threads()
	
	_wait_for_threads()
	image.unlock()
	
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	
	return texture


func _create_thread_worker(params):
	var index = params["i"]
	
	var value = 0.0
	
	var st = Vector2(params["x"], params["y"])
	
	var c_amplitude = amplitude
	
	for i in octaves:
		value += c_amplitude * _get_noise(st.x, st.y, params["canvas_size"])
		st *= lacunarity
		c_amplitude *= gain
	
	var noise_shifted = round(((value * 0.5) + 0.5) * 255)
	
	var color = Color8(noise_shifted, noise_shifted, noise_shifted)
	
	params["image"].set_pixel(params["x"], params["y"], color)
#	print("finished thread %s" % index)
	return index

func _on_thread_worker_finished(index):
	threads[index].wait_to_finish()

# Returns a value between the range of [-1, 1]
func _get_noise(x, y, size: Vector2):
	# Normalize the coordinate values to a value in the range of [0, 1]
	var x_normalised = x / size.x
	var y_normalised = y / size.y
	
	# Scale the [x, y] to the perlin grid size we are using
	var vx = x_normalised * perlin_grid_x
	var vy = y_normalised * perlin_grid_y
	var v = Vector2(vx, vy)
	
	# Determine the corner points of the grid section
	var xf = floor(v.x)
	var yf = floor(v.y)
	var xc = xf + 1
	var yc = yf + 1
	
	# Co-ordinates of the four corner points bounding (vx, vy)
	var top_left = Vector2(xf, yf)
	var bottom_left = Vector2(xf, yc)
	
	var top_right = Vector2(xc, yf)
	var bottom_right = Vector2(xc, yc)
	
	# Retrieve the gradient vectors for each corner
	var top_left_gradient = _get_gradient_vector(top_left.x, top_left.y)
	var bottom_left_gradient = _get_gradient_vector(bottom_left.x, bottom_left.y)

	var top_right_gradient = _get_gradient_vector(top_right.x, top_right.y)
	var bottom_right_gradient = _get_gradient_vector(bottom_right.x, bottom_right.y)
	
	# Calculate the offset vector from each corner to vx, vy
	var top_left_offset = _dist(top_left, v)
	var bottom_left_offset = _dist(bottom_left, v)
	var top_right_offset = _dist(top_right, v)
	var bottom_right_offset = _dist(bottom_right, v)
	
	# Calculate the dot product of the gradient vector and offset vector for each corner
	var top_left_dp = top_left_offset.dot(top_left_gradient)
	var bottom_left_dp = bottom_left_offset.dot(bottom_left_gradient)
	
	var top_right_dp = top_right_offset.dot(top_right_gradient)
	var bottom_right_dp = bottom_right_offset.dot(bottom_right_gradient)
	
	# Interpolate the left and right dot products 
	var i = vx - xf
	var j = vy - yf

	var noise = _lerp(i, 
		_lerp(j, top_left_dp, bottom_left_dp),
		_lerp(j, top_right_dp, bottom_right_dp)
	)

	return clamp(noise, -1, 1)


# Calculate the offset/displacement vector from p2 to p1
func _dist(p1: Vector2, p2: Vector2):
	return Vector2(
		p2.x - p1.x,
		p2.y - p1.y
	)


# Returns a pseudo-randomly generated Vector2
func _get_gradient_vector(x, y):
	var generator = RandomNumberGenerator.new()
	generator.set_seed(hash("%s %s %s" % [x, y, generator_seed]))
	return Vector2(
		cos(generator.randf_range(0, 2 * PI)), 
		sin(generator.randf_range(0, 2 * PI))
	).normalized()


func _lerp(w, a0, a1):
	return (a1 - a0) * ((w * (w * 6.0 - 15.0) + 10.0) * w * w * w) + a0;


func _exit_tree():
	_wait_for_threads()
	

func _wait_for_threads():
	for x in current_threads:
		if threads[x].is_active():
			threads[x].wait_to_finish()
			current_threads -= 1
