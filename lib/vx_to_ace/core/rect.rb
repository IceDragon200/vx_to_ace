class Rect
  def to_a
    return x, y, width, height
  end

  def vx_to_dump
    {
      _header: [self.class.name],
      x: x,
      y: y,
      width: width,
      height: height,
    }
  end
end
