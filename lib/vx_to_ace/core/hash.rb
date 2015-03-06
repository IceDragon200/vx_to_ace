#
# hash.rb
#
class Hash
  def get_values(*args)
    args.map { |a| self[a] }
  end
end
