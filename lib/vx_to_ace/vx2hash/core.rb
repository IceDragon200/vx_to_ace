require 'vx_to_ace/core/array'
require 'vx_to_ace/core/hash'
require 'vx_to_ace/core/kernel'
require 'vx_to_ace/core/rect'
require 'vx_to_ace/core/table'
require 'vx_to_ace/core/color'
require 'vx_to_ace/core/tone'

module VX2Hash
  def self.get_all_classes(obj, depth = 0)
    #STDERR.puts "#{'  ' * depth}#{obj}"
    abort 'WTF, the depth went deeper than 100' if depth > 100
    obj.constants.each_with_object([]) do |c, r|
      mod = obj.const_get(c)
      if mod.is_a?(Module)
        r.push(mod)
        r.concat(get_all_classes(mod, depth + 1))
      end
    end
  end

  def self.try_vx_to_dump(obj)
    case obj
    when Array
      obj.map { |o| try_vx_to_dump(o) }
    when Hash
      obj.each_with_object({}) do |(k, o), result|
        result[k] = try_vx_to_dump(o)
      end
    when Numeric, String, NilClass, TrueClass, FalseClass
      obj
    else
      if obj.respond_to?(:vx_to_dump)
        obj.vx_to_dump
      else
        fail "Cannot dump #{obj}"
      end
    end
  end

  def self.vx_to_dump_a(arra)
    result = Array.new(arra.size,nil)
    arra.each_with_index do |o, i|
      result[i] = try_vx_to_dump(o)
    end
    return result
  end

  def self.vx_to_dump_h(hsh)
    result = {}
    hsh.each_pair do |k, v|
      result[k] = try_vx_to_dump(v)
    end
    result
  end

  module IVX2Hash
    def vx_to_dump
      data = {}
      data[:_header] = [self.class.name]
      instance_variables.each do |v|
        data[v.to_s.gsub("@", "").to_sym] = VX2Hash.try_vx_to_dump(instance_variable_get(v))
      end
      data
    end
  end
end

module RPG
  VX2Hash.get_all_classes(self).each do |c|
    c.send(:include, VX2Hash::IVX2Hash)
  end
end
