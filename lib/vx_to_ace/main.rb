# Mixins
require_relative 'mixin/mixin-base'
require_relative 'mixin/mignorefunc'
require_relative 'mixin/mixin-routecommands'
require_relative 'mixin/mtable-ex'
#puts '>> Required Mixins'
#puts Mixin.constants

# Core
require 'vx_to_ace/core/array'
require 'vx_to_ace/core/hash'
require 'vx_to_ace/core/kernel'
require 'vx_to_ace/core/table'
require 'vx_to_ace/core/rect'
require 'vx_to_ace/core/color'
require 'vx_to_ace/core/tone'
#puts '>> Required Core'

# Modules
module RPG ; end
require_relative 'module/mkeffect'
require_relative 'module/mkfeature'
require_relative 'module/eventcommand-codes'

# Helper
require_relative 'helper/coutput'

def mk_vx2ace_dirs(*dirs)
  dirs.each do |s|
    unless Dir.exist?(s)
      puts fmsg("Making Directory: #{s}")
      Dir.mkdir(s)
    end
  end
end

def main_vx(settings)
  require 'rgss_tk/rgss2'
  require_relative 'vx2hash'

  VX2Hash.main(settings)
end

def main_vxa(settings)
  require 'rgss_tk/rgss3'
  require_relative 'hash2ace'

  Hash2Ace.main(settings)
end
