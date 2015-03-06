#
# vxconsole.rb
#
def vx_create_console
  Win32API.new("kernel32", "AllocConsole", "V", "L").call
  $stdout.reopen("CONOUT$")
  $stdin.reopen("CONIN$")
end  
