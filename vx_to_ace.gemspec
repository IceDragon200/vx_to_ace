#
# vx_to_ace/vx_to_ace.gemspec
#
lib = File.join(File.dirname(__FILE__), 'lib')
$:.unshift lib unless $:.include?(lib)

require 'vx_to_ace/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'vx_to_ace'
  s.summary     = 'RMVX Data dumper and converter'
  s.description = 'Dumps RMVX rvdata and converts it to rvdata2'
  s.date        = Time.now.to_date.to_s
  s.version     = VxToAce::Version::STRING
  s.homepage    = 'https://github.com/IceDragon200/vx_to_ace'
  s.license     = 'MIT'

  s.authors = ['Corey Powell']
  s.email  = 'mistdragon100@gmail.com'

  s.add_runtime_dependency 'json',     '~> 1.8'
  s.add_runtime_dependency 'minitest', '~> 5.1'
  s.add_runtime_dependency 'rspec',    '~> 3.1'
  s.add_runtime_dependency 'rgss_tk',  '~> 1.12'

  s.executables = ['vx_dump', 'vxdump_to_ace']
  s.require_path = 'lib'
  s.files = []
  s.files.concat(Dir.glob('{bin,lib}/**/*'))
end
