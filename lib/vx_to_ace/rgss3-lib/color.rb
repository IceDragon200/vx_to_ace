class Color

  attr_reader :red, :green, :blue, :alpha

  def red=(n)
    @red = n < 0 ? 0 : n > 255 ? 255 : n
  end

  def green=(n)
    @green = n < 0 ? 0 : n > 255 ? 255 : n
  end

  def blue=(n)
    @blue = n < 0 ? 0 : n > 255 ? 255 : n
  end

  def alpha=(n)
    @alpha = n < 0 ? 0 : n > 255 ? 255 : n
  end

  def initialize(r=0, g=0, b=0, a=255)
    self.red, self.green, self.blue, self.alpha = 0, 0, 0, 255
    _set(r,g,b,a)
  end

  def set(r=0, g=0, b=0, a=255)
    r,g,b,a = r.red,r.green,r.blue,r.alpha if r.is_a?(Color)
    self.red, self.green, self.blue, self.alpha = r||@red, g||@green, b||@blue, a||@alpha
  end

  alias :_set :set

  def to_gosu
    Gosu::Color.rgba(red, green, blue, alpha)#(alpha + (blue << 4) + (green << 8) + (red << 12))
  end

end
