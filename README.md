Puzzle creator Library 1.0
==========================


This Library creates a puzzle using ImageMagick from an image. It create as set of transperant gif's for you to use to create so that you can change any picture into a puzzle. Enjoy!

Test include a Cutter library written in TDD, image_handler which actually creates that image using ImageMagick, but could be swapped out with another image library.


Example of usage:


```ruby
img_handle = ImageHandler.new

# set the where the puzzle images should be stored.
img_handle.folder_location = "./puzzle_created/made/"

# set the source file
img_handle.source("simple_sample.jpg")

# generate your pieces.
img_handle.all_piece
```

To get a visual representation of how this puzzle creator library works, have a look [here](https://github.com/ziemekwolski/Puzzle-Maker/blob/master/test/puzzle_creator_explained.jpg)
