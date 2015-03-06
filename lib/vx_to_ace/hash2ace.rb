#==============================================================================#
# // VXDump2Ace
#==============================================================================#
# // Created By    : IceDragon(rpgmakervx.net,rpgmakervxace.net,rpgmakerweb.com)
# // Date Created  : 03/29/2012
# // Date Modified : 04/18/2012
# // Version       : 0.9
#==============================================================================#
# (03/29/2012)
#   Started and Finished
# (04/16/2012)
#   Major bugfix regarding moveroutes, commands where missing and broken.
#   Fixed missing BGM,BGS,ME,SE also related to the moveroute issue.
# (04/18/2012)
#   Several Bugfixes
#     Variables which used items, actors, enemies, map_id where missing
#     Class weapon/armor is now uniquely set if CleverClassEquip is set to 1
#==============================================================================#
# // TODO
# // Shorten code and cleanup, add more error handling and clean console output
#==============================================================================#
require_relative 'hash2ace/core'

module Hash2Ace
  class << self
    attr_accessor :src_dir
    attr_accessor :dest_dir
  end

  def self.load_vx2dump(filename)
    begin
      return load_data("#{src_dir}/#{filename}.vx2dump")
    rescue(Exception) => ex
      puts format("%s.vx2dump failed to load", filename)
      puts ex
      sleep 0.3
      return nil
    end
  end

  def self.save_data_ace(obj, filename)
    save_data(obj, "#{dest_dir}/#{filename}.rvdata2")
  end

  def self.fmsg(text)
    format("<Hash2Ace:@> %s",text)
  end

  def self.pfmsg(text)
    puts fmsg(text)
  end

  # // Print and wait
  def self.paw(text)
    puts "["+("-"*20)+"]"
    fmsg(text)
    sleep 4.0
  end

  def self.swait(d)
    puts "Waiting"
    d.times do
      sleep 0.01
      print "."
    end
    puts ""
  end

  def self.read_config
    hsh = {}
    hsh[:actor_param_to_class] = true
    hsh[:clever_class_equip]  = false
    hsh
  end

  def self.main(settings)

    self.src_dir  = settings[:src]
    self.dest_dir = settings[:dest]

    mk_vx2ace_dirs(src_dir, dest_dir)

    config_hsh = read_config
    pfmsg "[actor_param_to_class]: #{config_hsh[:actor_param_to_class]}"
    pfmsg "[clever_class_equip] : #{config_hsh[:clever_class_equip]}"
    pfmsg "[Starting Hash2Ace]"
    swait(80)
    loaded = {}

    rvdatas_names = [
      "Actors",
      "Animations",
      "Armors",
      "Classes",
      "CommonEvents",
      "Enemies",
      "Items",
      "MapInfos",
      "Skills",
      "States",
      "System",
      "Troops",
      "Weapons",
    ]

    rvdatas_names.each do |s|
      loaded[s] = load_vx2dump(s)
    end

    # Initialize all variables for loading rvdata
    actors        = nil
    animations    = nil
    classes       = nil
    skills        = nil
    items         = nil
    weapons       = nil
    armors        = nil
    enemies       = nil
    states        = nil
    system        = nil
    common_events = nil
    mapinfos      = nil

    if(loaded["Actors"])
      pfmsg "Loading and converting Actors"
      actors = loaded["Actors"].collect{|hsh|hsh ? hash_to_actor(hsh) : hsh}
    end
    if(loaded["Animations"])
      pfmsg "Loading and converting Animations"
      animations= loaded["Animations"].collect{|hsh|hsh ? hash_to_animation(hsh) : hsh}
    end
    if(loaded["Armors"])
      pfmsg "Loading and converting Armors"
      armors = loaded["Armors"].collect{|hsh|hsh ? hash_to_armor(hsh) : hsh}
    end
    if(loaded["Classes"])
      pfmsg "Loading and converting Classes"
      classes= loaded["Classes"].collect{|hsh|hsh ? hash_to_class(hsh) : hsh}
    end
    if(loaded["CommonEvents"])
      pfmsg "Loading and converting CommonEvents"
      common_events = loaded["CommonEvents"].collect{|hsh|hsh ? hash_to_common_event(hsh) : hsh}
    end
    if(loaded["Enemies"])
      pfmsg "Loading and converting Enemies"
      enemies= loaded["Enemies"].collect{|hsh|hsh ? hash_to_enemy(hsh) : hsh}
    end
    if(loaded["Items"])
      pfmsg "Loading and converting Items"
      items  = loaded["Items"].collect{|hsh|hsh ? hash_to_item(hsh) : hsh}
    end
    if(loaded["MapInfos"])
      pfmsg "Loading and converting MapInfos"
      mapinfos = Hash[loaded["MapInfos"].collect{|(mid,hsh)|[mid,hash_to_map_info(hsh)]}]
    end
    if(loaded["Skills"])
      pfmsg "Loading and converting Skills"
      skills = loaded["Skills"].collect{|hsh|hsh ? hash_to_skill(hsh) : hsh}
    end
    if(loaded["States"])
      pfmsg "Loading and converting States"
      states = loaded["States"].collect{|hsh|hsh ? hash_to_state(hsh) : hsh}
    end
    if(loaded["System"])
      pfmsg "Loading and converting System"
      system = hash_to_system(loaded["System"])
    end
    if(loaded["Troops"])
      pfmsg "Loading and converting Troops"
      troops= loaded["Troops"].collect{|hsh|hsh ? hash_to_troop(hsh) : hsh}
    end
    if(loaded["Weapons"])
      pfmsg "Loading and converting Weapons"
      weapons= loaded["Weapons"].collect{|hsh|hsh ? hash_to_weapon(hsh) : hsh}
    end

    maps = Dir.glob("#{src_dir}/Map*.vx2dump").select{ |f| f=~/Map[0-9]{3}/i }

    if(maps && maps.size>0)
      pfmsg "Loading and converting Maps"
      maps = maps.sort.collect do |m|
        tmp = load_data(m)
        puts "->Converting Map #{m}"
        [hash_to_map(tmp),m]
      end
    end

    pfmsg "[Load and Convert Complete]"
    # //
    swait(80)

    pfmsg "-Fixing up-"

    if(config_hsh[:actor_param_to_class] && (actors && classes))
      pfmsg "Applying Actor Parameters to Classes"
      params = nil
      x,y = nil, nil
      cls = nil
      loaded["Actors"].each do |a| next unless(a)
        params = hash_to_table(a[:parameters])
        cls = classes[a[:class_id]]
        pfmsg "Applying Actor(#{a[:id]}) Parameters to Class(#{cls.id})"
        for x in 0...params.xsize
          for y in 0...params.ysize
            case(x) # // Kind
            when 0 # // MHP
              cls.params[0,y] = params[x,y]
            when 1 # // MMP
              cls.params[1,y] = params[x,y]
            when 2 # // ATK
              cls.params[2,y] = params[x,y]
            when 3 # // DEF
              cls.params[3,y] = params[x,y]
            when 4 # // SPI
              cls.params[4,y] = params[x,y]
            when 5 # // AGI
              cls.params[6,y] = params[x,y]
            end
          end
        end
        cls.exp_params = [a[:exp_basis], a[:exp_inflation]] + cls.exp_params[2..3]
      end
    end

    if(config_hsh[:clever_class_equip] && classes && system && (weapons||armors))
      puts "Uniqing Equipment per class"
      clsweapons = []
      clsarmors  = []
      wepset = []
      armset = []
      lclasses = loaded["Classes"]
      assoc_wids = {}
      assoc_aids = {}
      lclasses.each do |clshsh| next unless(clshsh)
        wepset << clshsh[:weapon_set]
        armset << clshsh[:armor_set]
        clsweapons+= clshsh[:weapon_set]
        clsarmors += clshsh[:armor_set]
        clshsh[:weapon_set].each {|i|(assoc_wids[i]||=[]).push(clshsh[:id])}
        clshsh[:armor_set].each {|i|(assoc_aids[i]||=[]).push(clshsh[:id])}
      end
      clsweapons.uniq_arrays!(wepset)
      clsarmors.uniq_arrays!(armset)
      # // Bit sloppy
      if(weapons)
        puts "Processing Weapons"
        clsweapons.each_with_index do |wep_a,wtid|
          wep_a.each do |wid|
            system.weapon_types[wtid+1] = "WeaponSet#{"%02d"%(wtid+1)}"
            weapons[wid].wtype_id = wtid+1
          end
        end
        classes.compact.each do |cls|
          lcls = lclasses[cls.id]
          lcls[:weapon_set].collect{|wid|weapons[wid].wtype_id}.uniq.compact.sort.each { |wty|
            puts "assigning WTYPE #{wty} to class #{cls.id} #{cls.name}"
            cls.features << MkFeature.equip_wtype(wty)
          }
        end
      end
      if(armors)
        puts "Processing Armors"
        clsarmors.each_with_index do |arm_a,atid|
          arm_a.each do |aid|
            system.armor_types[atid+1] = "ArmorSet#{"%02d"%(atid+1)}"
            armors[aid].atype_id = atid+1
          end
        end
        classes.compact.each do |cls|
          lcls = lclasses[cls.id]
          lcls[:armor_set].collect{|aid|armors[aid].atype_id}.uniq.compact.sort.each do |aty|
            puts "assigning ATYPE #{aty} to class #{cls.id} #{cls.name}"
            cls.features << MkFeature.equip_atype(aty)
          end
        end
      end
    end
    # //
    pfmsg "-Saving- *.rvdata2"
    if(actors)
      pfmsg "Actors >> "
      save_data_ace(actors , "Actors")
    end
    if(animations)
      pfmsg "Animations >> "
      save_data_ace(animations , "Animations")
    end
    if(classes)
      pfmsg "Classes >> "
      save_data_ace(classes, "Classes")
    end
    if(skills)
      pfmsg "Skills >> "
      save_data_ace(skills , "Skills")
    end
    if(items)
      pfmsg "Items >> "
      save_data_ace(items  , "Items")
    end
    if(weapons)
      pfmsg "Weapons >> "
      save_data_ace(weapons, "Weapons")
    end
    if(armors)
      pfmsg "Armors >> "
      save_data_ace(armors , "Armors")
    end
    if(enemies)
      pfmsg "Enemies >> "
      save_data_ace(enemies, "Enemies")
    end
    if(troops)
      pfmsg "Troops >> "
      save_data_ace(troops , "Troops")
    end
    if(states)
      pfmsg "States >> "
      save_data_ace(states , "States")
    end
    if(common_events)
      pfmsg "CommonEvents >> "
      save_data_ace(common_events, "CommonEvents")
    end
    if(system)
      pfmsg "System >> "
      save_data_ace(system , "System")
    end
    if(mapinfos)
      pfmsg "MapInfos >> "
      save_data_ace(mapinfos, "MapInfos")
    end
    if(maps && maps.size>0)
      pfmsg "Maps >> "
      maps.each do |a|
        save_data_ace(a[0], File.basename(a[1]).gsub(/\.vx2dump/i, ''))
      end
    end

    # //
    paw('Hash2Ace Complete')
    swait(40)
  end
end
