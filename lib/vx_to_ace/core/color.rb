class Color
  def vx_to_dump
    {
      _header: [self.class.name],
      red: red,
      green: green,
      blue: blue,
      alpha: alpha,
    }
  end
end
