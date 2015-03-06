class Tone
  def vx_to_dump
    {
      _header: [self.class.name],
      red: red,
      green: green,
      blue: blue,
      gray: gray,
    }
  end
end
