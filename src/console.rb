Win32API.new("kernel32", "AllocConsole", "V", "L").call
$stdout.reopen("CONOUT$")
$stdin.reopen("CONIN$")