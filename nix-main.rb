#
# VX2Ace/nix-main.rb
#
# For those of us who don't have RMVXA installed or just feel like using pure
# ruby to accomplish the task at hand using the command line.
require_relative 'src/main.rb'
require_relative 'src/rgss3-lib/_all.rb'

HELP_STR = %Q(
VX2Ace
by IceDragon
vr 0.91

COMMANDS
  --tohash, -v
    VX2Ace will operate in VX2Hash mode.
    It will create the *.vx2dump files.

    --src, -s <directory>
      Source directory of *.rvdata files
      default: 
        VXDataIn (vx2ace-conf.rb)

    --dest, -d <directory>
      Destination directory for *.vx2dump files.
      default: 
        VXDataOut (vx2ace-conf.rb)

  --toace, -a
    VX2Ace will operate in Hash2Ace mode. 
    It will create the *.rvdata2 files.

    --src, -s <directory>
      Source directory of *.vx2dump files
      default: 
        VXDataOut (vx2ace-conf.rb)

    --dest, -d <directory>
      Destination directory for *.rvdata2 files.
      default: 
        AceDataOut (vx2ace-conf.rb)

  --help, -h
    Displays this message.
          
EXAMPLES
  ruby nix-main.rb -h          
  ruby nix-main.rb -a
  ruby nix-main.rb --toace -s vxdumps --dest acedata

)

def main(argsv)

  if argsv.empty?
    puts HELP_STR
    return
  end

  settings = {
    console: true
  }

  while(arg = argsv.shift)
    case arg
    when '--help', '-h'
      puts HELP_STR
      return
    when '--tohash', '-v'
      warn "Switching to: vx to hash" if settings[:mode]
      settings[:mode] = :to_hash
      settings[:src] ||= VXDataIn
      settings[:dest] ||= VXDataOut
    when '--toace', '-a'  
      warn "Switching to: hash to ace" if settings[:mode]
      settings[:mode] = :to_ace
      settings[:src] ||= VXDataOut
      settings[:dest] ||= AceDataOut
    when '--src', '-s'
      settings[:src] = argsv.shift
    when '--dest', '-d'
      settings[:dest] = argsv.shift
    end
  end

  case settings[:mode]
  when :to_hash
    main_vx(settings)
  when :to_ace
    main_vxa(settings)
  else
    raise("No mode was defined: Aborting operation")
  end

  return 0;
end

begin
  main(ARGV.dup)
rescue(Exception) => ex
  raise ex  
end
