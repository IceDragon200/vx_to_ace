class Rect

  def to_a();[self.x,self.y,self.width,self.height];end

  def vx2dump()
    (hsh = {})[:_header]=[self.class.name];hsh[:data]=to_a();return hsh
  end  

end  
