#
# VX2Ace/src/vx2hash.d/core.rb
#
module VX2Hash  

  def self.get_all_classes(obj)
    result = []; cls = nil
    obj.constants.each do |c|
      cls = obj.send("const_get",c);
      result.push(cls); 
      result += get_all_classes(cls)
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

  module IVX2Hash

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
    c.send(:include, VX2Hash::IVX2Hash)
  end

end 
