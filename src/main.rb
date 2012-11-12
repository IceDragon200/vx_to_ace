#
# src/main.rb
#

# Mixins
require_relative 'mixin/mixin-base'
require_relative 'mixin/mignorefunc'
require_relative 'mixin/mixin-routecommands'
require_relative 'mixin/mtable-ex.rb'
#puts '>> Required Mixins'
#puts Mixin.constants

# Core 
require_relative 'core/array-ex'
require_relative 'core/hash-ex'
require_relative 'core/kernel-ex'
require_relative 'core/vxconsole'
require_relative 'core/table-ex'
require_relative 'core/rect-ex'
#puts '>> Required Core'

# Modules
module RPG ; end
require_relative 'module/mkeffect'
require_relative 'module/mkfeature'
require_relative 'module/eventcommand-codes.rb'
#puts '>> Required Modules'

# Helper
require_relative 'helper/coutput'
#puts '>> Required Helpers'

# Config
require_relative '../vx2ace-conf.rb'
#puts '>> Required Config'

def mk_vx2ace_dirs(*dirs)
  dirs.each do |s|
    unless Dir.exist?(s)
      puts fmsg("Making Directory: #{s}")
      Dir.mkdir(s) 
    end  
  end
end

def main_vx(settings)   
  require_relative 'rgss2in3'
  require_relative 'vx2hash'

  Graphics.resize_screen(128, 128)
  VX2Hash.main(settings)   
end

def main_vxa(settings)   
  require_relative 'hash2ace'
  require_relative 'rgss3-lib/rpg' if settings[:console]

  Graphics.resize_screen(128, 128)
  Hash2Ace.main(settings)   
end
