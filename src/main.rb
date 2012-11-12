#
# src/main.rb
#

# Core 
require_relative 'core/array-ex'
require_relative 'core/console'

# Mixins
require_relative 'mixin/mixin-routecommands'
require_relative 'mixin/mixin-tableexpansion'

# Modules
require_relative 'mixin/base'
require_relative 'mixin/mkeffect'
require_relative 'mixin/mkfeature'

def main_vx
  $LOAD_PATH << Dir.getwd + "/src/" 

require 'rgss2in3'
require 'mixin-tableexpansion'
require 'vx2hash'
begin
  Graphics.resize_screen(128, 128)
  VX2Hash.run!()
end

end

def main_vxa
  $LOAD_PATH << Dir.getwd + "/src/"


module Mixin;end
require 'array-ex'
require 'console'
require 'mkfeature'
require 'mkeffect'
require 'vxdump2ace'
begin
  Graphics.resize_screen(128, 128)
  VXDump2Ace.run!()
end 

end
