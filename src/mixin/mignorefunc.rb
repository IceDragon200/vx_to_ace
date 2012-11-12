#
# VX2Ace/src/mixin/mignorefunc.rb
#
module MIgnoreFunc

  def ignore_func(*func_names)
    func_names.each do |func_name|
      define_method(func_name) do |*args, &block|
        warn("Running from console: Ignoring #{self.name}.#{func_name}")
        return false
      end
    end  
  end

end  
