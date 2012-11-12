#
# hash.rb
#
class Hash

  def get_values(*args)
    args.collect {|a|self[a]}
  end
  
end
