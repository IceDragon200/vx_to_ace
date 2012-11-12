=begin

  VX to Hash
  by IceDragon (rpgmakervx.net rpgmakervxace.net rpgmakerweb.com)
  dc 29/03/2012
  dm 11/11/2012
  vr 0.91

=end
Dir[File.join(File.dirname(__FILE__), 'vx2hash.d', '*.rb')].each do |s|
  require_relative s
end 

module VX2Hash

  def self.fmsg(text)
    format("<VX2Hash:@> %s",text)
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

  def self.main(settings)

    src  = settings[:src]
    dest = settings[:dest]

    mk_vx2ace_dirs(src, dest)

    data = Dir.glob("#{src}/*.rvdata") - [".", ".."]

    raise "Source: #{src} directory has no valid *.rvdata, please place your *.rvdata there" if(data.empty?())

    fn, obj, result = nil, nil, nil
    pa = nil
    data.each_with_index do |f,i|
      pa = Array.new(data.size,"-")
      pa[i] = "O"
      #puts fmsg("Progress: #{pa.join("|")} #{(i/pa.size.to_f*100.0).round()}%")
      puts fmsg("Loading #{f}")
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
        fn = "#{dest}/#{File.basename(f).gsub(/\.rvdata/i,".vx2dump")}"
        save_data(result, fn)
        puts fmsg("#{obj.class.name} dumped to #{fn}")
      rescue(Exception) => ex
        puts fmsg("Failed to load #{f}: #{ex.message}")
      end
      #swait(60)
    end  
    paw "Dumping complete"
  end  
  
end  
