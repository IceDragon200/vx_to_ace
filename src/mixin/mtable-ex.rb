#
# VX2Ace/src/mixin/mtable-ex.rb
#
module Mixin
  module TableEx

    def iterate( pos_only, &block )
      if zsize > 0
        return iterate3( pos_only, &block )
      elsif ysize > 0
        return iterate2( pos_only, &block )
      else
        return iterate1( pos_only, &block )
      end  
    end  

    def iterate1( pos_only=false ) 
      if pos_only
        for x in 0...xsize
          yield(x)
        end  
      else  
        for x in 0...xsize
          yield(self[x],x)
        end  
      end  
      return self
    end  

    def iterate2( pos_only=false )
      if pos_only
        for x in 0...xsize
          for y in 0...ysize
            yield(x,y)
          end  
        end  
      else  
        for x in 0...xsize
          for y in 0...ysize
            yield(self[x,y],x,y)
          end  
        end  
      end 
      return self
    end  

    def iterate3( pos_only=false )
      if pos_only
        for x in 0...xsize
          for y in 0...ysize
            for z in 0...zsize
              yield(x,y,z)
            end
          end  
        end  
      else  
        for x in 0...xsize
          for y in 0...ysize
            for z in 0...zsize
              yield(self[x,y,z],x,y,z)
            end
          end  
        end  
      end  
      return self
    end  

    def iterate_map1( pos_only=false )
      if pos_only
        iterate1( true ) { |x| self[x] = yield x }
      else  
        iterate1( false ) { |n, x| self[x] = yield n, x }
      end  
      return self
    end  

    def iterate_map2( pos_only=false )
      if pos_only
        iterate2( true ) { |x, y| self[x, y] = yield x, y }
      else  
        iterate2( false ) { |n, x, y| self[x, y] = yield n, x, y }
      end  
      return self
    end  

    def iterate_map3( pos_only=false )
      if pos_only
        iterate3( true ) { |x, y, z| self[x, y, z] = yield x, y, z }
      else  
        iterate3( false ) { |n, x, y, z| self[x, y, z] = yield n, x, y, z }
      end  
      return self
    end

    def nudge_x( n )
      tabclone = self.dup
      xs = tabclone.xsize
      if tabclone.zsize > 0
        tabclone.iterate3 { |i,x,y,z| self[(x+n)%xs,y,z] = i }
      elsif tableclone.ysize > 0  
        tabclone.iterate2 { |i,x,y| self[(x+n)%xs,y] = i }
      else  
        tabclone.iterate1 { |i,x| self[(x+n)%xs] = i }
      end  
      return self
    end

    def nudge_y( n )
      tabclone = self.dup
      ys = tabclone.ysize
      if tabclone.zsize > 0
        tabclone.iterate3 { |i,x,y,z| self[x,(y+n)%ys,z] = i }
      elsif ys > 0  
        tabclone.iterate2 { |i,x,y| self[x,(y+n)%ys] = i }
      end  
      return self
    end  

    def nudge_z( n )
      tabclone = self.dup
      zs = tabclone.zsize
      return self unless zs > 0
      tabclone.iterate3 { |i,x,y,z| self[x,y,(z+n)% zs] = i }
      return self
    end  

    def nudge_xy( nx, ny )
      tabclone = self.dup
      xs, ys = tabclone.xsize, tabclone.ysize
      if tabclone.zsize > 0
        tabclone.iterate3 { |i,x,y,z| self[(x+nx)%xs,(y+ny)%ys,z] = i }
      else
        tabclone.iterate2 { |i,x,y| self[(x+nx)%xs,(y+ny)%ys] = i }
      end  
      return self
    end  

    def nudge_xyz( nx, ny, nz )
      tabclone = self.dup
      xs, ys, zs = tabclone.xsize, tabclone.ysize, tabclone.zsize
      tabclone.iterate3 { |i,x,y,z| self[(x+nx)%xs,(y+ny)%ys,(z+nz)%zs] = i }
      return self
    end   

    # // 02/21/2012
    def oor?(x,y=0,z=0) # // Out Of Range?
      return true if x < 0 || y < 0 || z < 0
      return true if xsize <= x
      return true if ysize <= y if ysize > 0
      return true if zsize <= z if zsize > 0
      return false
    end  

  end
end
