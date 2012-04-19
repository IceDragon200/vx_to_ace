#==============================================================================#
# // VX to Hash
#==============================================================================#
# // Created By    : IceDragon(rpgmakervx.net,rpgmakervxace.net,rpgmakerweb.com)
# // Date Created  : 03/29/2012
# // Date Modified : 03/29/2012
# // Version       : 0.1
#==============================================================================#
class Table
  include Mixin::TableExpansion
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
  def vx2dump()
    hsh = {}
    hsh[:_header] = [self.class.name]
    hsh[:_config], hsh[:data] = to_table_array
    return hsh
  end  
end  
class Rect
  def to_a();[self.x,self.y,self.width,self.height];end
  def vx2dump()
    (hsh = {})[:_header]=[self.class.name];hsh[:data]=to_a();return hsh
  end  
end  
module VX2Hash  
  def self.get_all_classes(obj)
    result = [];cls = nil
    obj.constants.each do |c|
      cls=obj.send("const_get",c);result<<cls;result+=get_all_classes(cls)
    end  
    return result
  end  
  def self.try_vx2dump(obj)
    case(obj)
    when(Array)
      obj.collect{|o|try_vx2dump(o)}
    when(Hash)  
      result = {};obj.each_pair{|k,o|result[k]=try_vx2dump(o)};result
    else  
      (obj.respond_to?(:vx2dump)) ? obj.vx2dump : obj
    end  
  end  
  def self.vx2dump_a(arra)
    result = Array.new(arra.size,nil)
    arra.each_with_index do|o,i|result[i]=try_vx2dump(o);end
    return result
  end
  def self.vx2dump_h(hsh)
    result = {};hsh.each_pair do|k,v|result[k]=try_vx2dump(v);end;return result
  end 
  module Include
    def vx2dump()
      (hsh = {})[:_header] = [self.class.name]
      instance_variables.each do |v|
        hsh[v.to_s.gsub("@","").to_sym] = VX2Hash.try_vx2dump(instance_variable_get(v))
      end
      return hsh
    end 
  end 
end  
module RPG
  VX2Hash.get_all_classes(self).each do |c|
    c.send("include",VX2Hash::Include)
  end
end 
module VX2Hash
  def self.fmsg(text)
    format("<VX2Hash:@>%s",text)
  end  
  # // Print and wait
  def self.paw(text)
    puts "["+("-"*20)+"]"
    fmsg(text)
    sleep 4.0
    #puts "Press Return to continue"
    #gets
  end
  def self.swait(d)
    puts "Waiting"
    d.times do 
      sleep 0.01
      $stdout << "." 
    end
    puts ""
  end  
  def self.run!()
    unless(File.exist?("VX2Data(Out)"))
      puts fmsg("Making VX2Data(Out) Folder")
      Dir.mkdir("VX2Data(Out)")
    end  
    unless(File.exist?("VX2Data(In)"))
      puts fmsg("Making VX2Data(In) Folder")
      Dir.mkdir("VX2Data(In)") 
    end  
    data = Dir.glob("VX2Data(In)/*.rvdata") - [".",".."]
    return raise "VX2Data(In) folder is empty, please place your .rvdata there" if(data.empty?())
    fn, obj, result = nil, nil, nil
    pa = nil
    data.each_with_index do |f,i|
      pa = Array.new(data.size,"-")
      pa[i] = "O"
      #puts fmsg("Progress: #{pa.join("|")} #{(i/pa.size.to_f*100.0).round()}%")
      puts fmsg("-Loading #{f}-")
      begin
        obj = load_data(f)
        result = case(obj)
        when(Array)
          vx2dump_a(obj)
        when(Hash)  
          vx2dump_h(obj)
        else
          try_vx2dump(obj)
        end 
        puts fmsg("Dumped #{obj.class}")
        fn = "VX2Data(Out)/#{File.basename(f).gsub(/\.rvdata/i,".vx2dump")}"
        save_data(result,fn)
        puts fmsg("#{obj.class.name} dumped to #{fn}")
      rescue(Exception) => ex
        puts fmsg("Failed to load #{f}")
      end
      #swait(60)
    end  
    paw "Dumping complete"
  end  
end  