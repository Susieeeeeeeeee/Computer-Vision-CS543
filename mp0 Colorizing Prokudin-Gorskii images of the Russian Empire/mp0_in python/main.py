from colorize import *
import datetime
def time_1():
 begin = datetime.datetime.now()

# Configurations
source_dir = 'data/'
dest_dir = 'results/'
extension = '.jpg'

#img_names = ['00125v.jpg', '00149v.jpg', '00153v.jpg', '00351v.jpg', '00398v.jpg', '01112v.jpg']
#high resolution pics
img_names = ['01047u.tif']
search_radius = 7

for img_name in img_names:

	# Load Image from File
	orig_img = sk.img_as_float(skio.imread(source_dir + img_name))

	# Split Image by Colors
	blue_img, green_img, red_img = map(crop, split(orig_img))

	# Align Colors
	# Naive Alignment (Uncomment to Run)	
	# displacement_green = naive_align(blue_img, green_img, search_radius)
	# aligned_green = align(green_img, displacement_green)
	# displacement_red = naive_align(blue_img, red_img, search_radius)
	# aligned_red = align(red_img, displacement_red)

	# Pyramid Alignment
	displacement_green = pyramid_align(blue_img, green_img, search_radius)
	aligned_green = align(green_img, displacement_green)
	displacement_red = pyramid_align(blue_img, red_img, search_radius)
	aligned_red = align(red_img, displacement_red)

	print("Displacing {0} (Green: {1}, Red: {2})".format((img_name[:-4]).capitalize(), displacement_green, displacement_red))
	
	# Compose into a Single Image
	color_img = stack_images(aligned_red, aligned_green, blue_img)

	# Write Image out to File
	write_image(dest_dir, img_name, color_img, extension)
