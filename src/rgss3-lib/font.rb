#
# VX2Ace/src/src/rgss3-lib/font.rb
#
class Font

  def self.attr_caccessor *syms
    syms.each do |sym| 
      module_eval(%Q(def self.#{sym}; @@sym; end)) 
      module_eval(%Q(def self.#{sym}=(arg); @@sym = arg; end)) 
    end
  end

  # // Array or String
  @@default_name      = ['Arial']
  @@default_size      = 20
  @@default_color     = Color.new( 255, 255, 255, 255) # // RGSS2
  @@default_out_color = Color.new(  24,  24,  24,  96) # // RGSS3

  # // Booleans
  @@default_bold      = false
  @@default_italic    = false
  @@default_shadow    = false # // RGSS2
  @@default_outline   = false # // RGSS3

  # // Class Variable Accessors
  attr_caccessor :default_name, :default_size  , :default_color , :default_out_color,
                 :default_bold, :default_italic, :default_shadow, :default_outline

  # // Instance Variable Accessors 
  attr_accessor :name, :size, :bold, :italic, :shadow, :outline, :out_color, :color

  def initialize
    @name = ['Arial']
    @size = 20
    @bold, @italic, @shadow, @outline = [false] * 4
    @color = Color.new 255, 255, 255, 255
    @out_color = Color.new 0, 0, 0, 48 
  end

  class << self

    undef attr_caccessor
    
  end

end
