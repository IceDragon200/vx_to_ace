#
# VX2Ace/src/rgss3-lib/graphics.rb
#
module Graphics

  extend MIgnoreFunc

  funcs = [:resize_screen, :width, :height, :update, :frames, :frame_rate]
  ignore_func *funcs
  module_function *funcs

end
