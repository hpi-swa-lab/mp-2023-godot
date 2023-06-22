@tool
extends Label3D
class_name Label3DDMM

const PIXEL_SIZE_1_DMM = 0.001 # one milimeter viewed at one meter distance

## set the viewing distance in m. scales the pixel_size such that
## texts of the same font size are equally easy to read from 
## differing viewing distances.
@export 
var intended_viewing_distance = 1.0:
	set(new_intended_viewing_distance_m):
		intended_viewing_distance = new_intended_viewing_distance_m
		self.pixel_size = new_intended_viewing_distance_m * PIXEL_SIZE_1_DMM
