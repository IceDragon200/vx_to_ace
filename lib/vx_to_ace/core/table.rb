#
# VX2Ace/src/table-ex.rb
#
class Table
  include Mixin::TableEx

  def to_table_array
    arra = Array.new(2)
    arra[0] = [self.xsize,self.ysize,self.zsize]# // Size Declaration
    if(self.zsize > 1)
      a = arra[1] = Array.new(self.xsize) { Array.new(self.ysize) { Array.new(self.zsize, 0) } }
      iterate3 do |i,x,y,z| a[x][y][z] = i ; end
    elsif(self.ysize > 1)
      a = arra[1] = Array.new(self.xsize) { Array.new(self.ysize, 0) }
      iterate2 do |i,x,y| a[x][y] = i ; end
    else
      a = arra[1] = Array.new(self.xsize,0)
      iterate1 do |i,x| a[x] = i ; end
    end
    return arra
  end

  def vx_to_dump
    hsh = {}
    hsh[:_header] = [self.class.name]
    hsh[:_config], hsh[:data] = to_table_array
    return hsh
  end
end
