#==============================================================================#
# // VXDump2Ace
#==============================================================================#
# // Created By    : IceDragon(rpgmakervx.net,rpgmakervxace.net,rpgmakerweb.com)
# // Date Created  : 03/29/2012
# // Date Modified : 04/16/2012
# // Version       : 0.1
#==============================================================================#
# (03/29/2012)
#   Started and Finished
# (04/16/2012)
#   Major bugfix regarding moveroutes, commands where missing and broken.
#   Fixed missing BGM,BGS,ME,SE also related to the moveroute issue.
#==============================================================================#
class Hash
  def get_values(*args)
    args.collect {|a|self[a]}
  end
end  
module VXDump2Ace
  NAME2HSHCOM = {
    "RPG::AudioFile"   => "hsh2aud",
    "RPG::BGM"         => "hsh2bgm",
    "RPG::BGS"         => "hsh2bgs",
    "RPG::ME"          => "hsh2me",
    "RPG::SE"          => "hsh2se",
    #"RPG::Animation"   => "hsh2anim", # // Doesn't Exist Yet
    "RPG::BaseItem"    => "hsh2bsitem",
    "RPG::Actor"       => "hsh2actor",
    "RPG::Class"       => "hsh2class",
    "RPG::Enemy"       => "hsh2enemy",
    "RPG::Item"        => "hsh2item",
    "RPG::Skill"       => "hsh2skill",
    "RPG::Armor"       => "hsh2armor",
    "RPG::Weapon"      => "hsh2weapon",
    "RPG::MoveCommand" => "hsh2mvcom",
    "RPG::MoveRoute"   => "hsh2mvr"
  }
  def self.try_vxdump2ace(obj)
    return obj unless(obj.is_a?(Hash))
    header,= obj[:_header]
    return obj unless(header)
    unless(NAME2HSHCOM.has_key?(header))
      puts "->Unsupported _header type #{header}" 
      return obj
    end  
    self.send(NAME2HSHCOM[header],obj)
  end
  def self.elerank_a(tab)
    eleranks = [0,200,150,100,50,0,-100].collect{|r|r/100.0}
    result =[]
    for x in 1...tab.xsize
      result << MkFeature.element_r(x,eleranks[tab[x]]) if(eleranks[tab[x]]!=1.0)
    end
    result
  end  
  def self.staterank_a(tab)
    staranks = [0,100,80,60,40,20,0].collect{|r|r/100.0}
    result = []
    for x in 1...tab.xsize
      result << MkFeature.state_r(x,staranks[tab[x]]) if(staranks[tab[x]]!=0.6)
    end  
    result
  end
  
  def self.hsh2table(hsh)
    sizes = hsh[:_config]
    data  = hsh[:data]
    if(sizes[2] > 1)
      result = Table.new(*sizes)
      for x in 0...result.xsize
        for y in 0...result.ysize
          for z in 0...result.zsize
            result[x,y,z] = data[x][y][z]
          end
        end
      end  
    elsif(sizes[1] > 1)
      result = Table.new(*sizes[0..1])
      for x in 0...result.xsize
        for y in 0...result.ysize
          result[x,y] = data[x][y]
        end
      end  
    else
      result = Table.new(sizes[0])
      for x in 0...result.xsize
        result[x] = data[x]
      end  
    end 
    return result
  end 
  def self.hsh2audio_a(hsh)
    hsh.get_values(:name,:volume,:pitch)
  end  
  def self.hsh2aud(hsh)
    RPG::AudioFile.new(*hsh2audio_a(hsh))
  end  
  def self.hsh2bgm(hsh)
    RPG::BGM.new(*hsh2audio_a(hsh))
  end  
  def self.hsh2bgs(hsh)
    RPG::BGS.new(*hsh2audio_a(hsh))
  end  
  def self.hsh2se(hsh)
    RPG::SE.new(*hsh2audio_a(hsh))
  end  
  def self.hsh2me(hsh)
    RPG::ME.new(*hsh2audio_a(hsh))
  end  
  def self.hsh2event(hsh)
    ev = RPG::Event.new(0,0)
    ev.id    = hsh[:id]   # // Integer
    ev.name  = hsh[:name] # // String
    ev.x     = hsh[:x]    # // Integer
    ev.y     = hsh[:y]    # // Integer
    ev.pages = hsh[:pages].collect { |evphsh| hsh2evPage(evphsh) }
    ev
  end  
  def self.hsh2evPage(hsh)
    page = RPG::Event::Page.new()
    page.condition      = hsh2evPageCond(hsh[:condition])
    page.graphic        = hsh2evPageGraph(hsh[:graphic])
    page.move_type      = hsh[:move_type]      # // Integer
    page.move_speed     = hsh[:move_speed]     # // Integer
    page.move_frequency = hsh[:move_frequency] # // Integer
    page.move_route     = hsh2mvr(hsh[:move_route])
    page.walk_anime     = hsh[:walk_anime]     # // Boolean
    page.step_anime     = hsh[:step_anime]     # // Boolean
    page.direction_fix  = hsh[:direction_fix]  # // Boolean
    page.through        = hsh[:through]        # // Boolean
    page.priority_type  = hsh[:priority_type]  # // Integer
    page.trigger        = hsh[:trigger]        # // Integer
    page.list           = hsh[:list].collect{|evhsh|hsh2evCom(evhsh)}
    page 
  end  
  def self.hsh2evPageCond(hsh)
    cond = RPG::Event::Page::Condition.new
    cond.switch1_valid     = hsh[:switch1_valid]     # // Boolean
    cond.switch2_valid     = hsh[:switch2_valid]     # // Boolean
    cond.variable_valid    = hsh[:variable_valid]    # // Boolean
    cond.self_switch_valid = hsh[:self_switch_valid] # // Boolean
    cond.item_valid        = hsh[:item_valid]        # // Boolean
    cond.actor_valid       = hsh[:actor_valid]       # // Boolean
    cond.switch1_id        = hsh[:switch1_id]        # // Integer
    cond.switch2_id        = hsh[:switch2_id]        # // Integer
    cond.variable_id       = hsh[:variable_id]       # // Integer
    cond.variable_value    = hsh[:variable_value]    # // Integer
    cond.self_switch_ch    = hsh[:self_switch_ch]    # // Character(String)
    cond.item_id           = hsh[:item_id]           # // Integer
    cond.actor_id          = hsh[:actor_id]          # // Integer
    cond
  end  
  def self.hsh2evPageGraph(hsh)
    graph = RPG::Event::Page::Graphic.new
    graph.tile_id         = hsh[:tile_id]            # // Integer
    graph.character_name  = hsh[:character_name]     # // String
    graph.character_index = hsh[:character_index]    # // Integer
    graph.direction       = hsh[:direction]          # // Integer 
    graph.pattern         = hsh[:pattern]            # // Integer
    graph
  end  
  def self.hsh2evCom(hsh)
    evcom = RPG::EventCommand.new
    evcom.code       = hsh[:code]                    # // Integer        
    evcom.indent     = hsh[:indent]                  # // Integer
    evcom.parameters = hsh[:parameters].collect{|o|try_vxdump2ace(o)}# // Array[]
    #evcom = fixevcom(evcom)
    evcom
  end  
  #def self.fixevcom(evcom)
  #  result = evcom.clone
  #  if(result.code ==)
  #    result.parameters
  #  end
  #  result
  #end
  def self.hsh2mvr(hsh)
    mvr = RPG::MoveRoute.new
    mvr.repeat    = hsh[:repeat]       # // Boolean
    mvr.skippable = hsh[:skippable]    # // Boolean
    mvr.wait      = hsh[:wait]         # // Boolean
    mvr.list      = hsh[:list].collect{|mvcm|hsh2mvcom(mvcm)}
    mvr 
  end  
  def self.hsh2mvcom(hsh)
    mvcm = RPG::MoveCommand.new()
    mvcm.code       = hsh[:code]       # // Integer
    mvcm.parameters = hsh[:parameters].collect{|o|try_vxdump2ace(o)}# // Array[]
    mvcm 
  end  
  def self.hsh2map(hsh)
    map = RPG::Map.new(1,1)
    # // Ace only
    map.display_name          = '' # // Read from MapInfo
    map.tileset_id            = 1  # // Default the Tileset ID to 1
    map.specify_battleback    = false
    map.battleback1_name      = ''
    map.battleback2_name      = ''
    map.note                  = ''
    # // VX / Ace
    map.width                 = hsh[:width]           # // Integer
    map.height                = hsh[:height]          # // Integer
    map.scroll_type           = hsh[:scroll_type]     # // Integer
    map.autoplay_bgm          = hsh[:autoplay_bgm]    # // Boolean
    map.bgm                   = hsh2bgm(hsh[:bgm])
    map.autoplay_bgs          = hsh[:autoplay_bgs]    # // Boolean
    map.bgs                   = hsh2bgs(hsh[:bgs])
    map.disable_dashing       = hsh[:disable_dashing] # // Boolean
    map.encounter_list        = hsh[:encounter_list]  # // Array
    map.encounter_step        = hsh[:encounter_step]  # // Integer
    map.parallax_name         = hsh[:parallax_name]   # // String
    map.parallax_loop_x       = hsh[:parallax_loop_x] # // Boolean
    map.parallax_loop_y       = hsh[:parallax_loop_y] # // Boolean
    map.parallax_sx           = hsh[:parallax_sx]     # // Integer
    map.parallax_sy           = hsh[:parallax_sy]     # // Integer
    map.parallax_show         = hsh[:parallax_show]   # // Boolean
    map.data                  = hsh2table(hsh[:data])
    map.events = {}
    hsh[:events].each_pair { |k,evhsh| map.events[k] = hsh2event(evhsh) }
    map.data.resize(map.data.xsize, map.data.ysize, 4) # // Ace Correction
    map
  end  
  # // BaseItem
  def self.hsh2bsitem(hsh)
    bsite = RPG::BaseItem.new()
    bsite.id          = hsh[:id]          # // Integer
    bsite.name        = hsh[:name]        # // String
    bsite.icon_index  = hsh[:icon_index]  # // Integer
    bsite.note        = hsh[:note]        # // String
    bsite.description = hsh[:description] # // String
    bsite.features    = []
    bsite
  end  
  def self.hsh2actor(hsh)
    actor = RPG::Actor.new()
    # // Ace Only
    actor.icon_index    = 0
    actor.note          = ''
    actor.description   = ''
    actor.nickname      = ''
    actor.max_level     = 99
    # // VX / Ace
    actor.id              = hsh[:id]              # // Integer
    actor.name            = hsh[:name]            # // String
    actor.class_id        = hsh[:class_id]        # // Integer
    actor.initial_level   = hsh[:initial_level]   # // Integer
    actor.character_name  = hsh[:character_name]  # // String
    actor.character_index = hsh[:character_index] # // Integer
    actor.face_name       = hsh[:face_name]       # // String
    actor.face_index      = hsh[:face_index]      # // Integer
    actor.equips = hsh.get_values(:weapon_id,:armor1_id,:armor2_id,:armor3_id,:armor4_id)
    actor.features << MkFeature.slot_type(0) if(hsh[:two_swords_style])
    actor.features += (0...5).collect{|i|MkFeature.equip_fix(i)} if(hsh[:fix_equipment])
    actor.features << MkFeature.auto_battle() if(hsh[:auto_battle]) 
    actor.features << MkFeature.grd_r(2.00) if(hsh[:super_guard]) 
    actor.features << MkFeature.pha_r(2.00) if(hsh[:pharmacology]) 
    actor.features << MkFeature.cri_r(0.40) if(hsh[:critical_bonus]) 
    actor
  end  
  def self.hsh2class(hsh)
    cls = RPG::Class.new()
    # // Ace Only
    cls.icon_index  = 0
    cls.note        = ''
    cls.description = '' 
    cls.features    = []
    # // VX / Ace
    cls.id          = hsh[:id]   # // Integer
    cls.name        = hsh[:name] # // String
    cls.features << MkFeature.tgr([1.00,0.75,0.50][hsh[:position]]) 
    # // Ace Tailing
    cls.features << MkFeature.hit_r(0.95)
    cls.features << MkFeature.eva_r(0.05)
    cls.features << MkFeature.cri_r(0.05)
    # // hsh[:weapon_set] Level 2 Conversion required
    # // hsh[:armor_set] Level 2 Conversion required
    cls.features += elerank_a(hsh2table(hsh[:element_ranks]))
    cls.features += staterank_a(hsh2table(hsh[:state_ranks]))
    cls.learnings = hsh[:learnings].collect{|lrnhsh|hsh2clslrn(lrnhsh)}
    # // hsh[:skill_name_valid] # // Boolean unused
    # // hsh[:skill_name]       # // String  unused
    cls
  end     
  def self.hsh2clslrn(hsh)  
    lrn = RPG::Class::Learning.new()
    # // Ace Only
    lrn.note = ''
    # // VX / Ace
    lrn.skill_id = hsh[:skill_id] # // Integer
    lrn.level    = hsh[:level]    # // Integer
    lrn
  end  
  def self.hsh2skill(hsh)
    skl = RPG::Skill.new()
    # // Ace Only
    skl.features     = []
    skl.repeats      = 1
    skl.tp_gain      = 0
    skl.effects      = []
    # // VX / Ace
    skl.id           = hsh[:id]          # // Integer
    skl.name         = hsh[:name]        # // String
    skl.icon_index   = hsh[:icon_index]  # // Integer
    skl.note         = hsh[:note]        # // String
    skl.description  = hsh[:description] # // String
    skl.scope        = hsh[:scope]       # // Integer
    skl.occasion     = hsh[:occasion]    # // Integer
    skl.speed        = hsh[:speed]       # // Integer
    skl.success_rate = hsh[:hit]         # // Integer
    skl.animation_id = hsh[:animation_id]# // Integer
    skl.hit_type     = hsh[:physical_attack] ? 1 : 2
    skl.mp_cost      = hsh[:mp_cost]     # // Integer
    skl.message1     = hsh[:message1]    # // String
    skl.message2     = hsh[:message2]    # // String
    skl.damage       = hsh2damage(hsh)
    skl.effects << MkEffect.common_event(hsh[:common_event_id]) if(hsh[:common_event_id]>0)
    skl.effects += hsh[:plus_state_set].collect{|sid|MkEffect.add_state(sid,0.7)}
    skl.effects += hsh[:minus_state_set].collect{|sid|MkEffect.rem_state(sid,1.0)}
    skl
  end
  def self.hsh2damage(hsh)  
    damage = RPG::UsableItem::Damage.new
    damage.type = 0
    damage.type += 1 if(hsh[:base_damage]>0)
    damage.type += 2 if(hsh[:base_damage]<0)
    damage.type += 4 if(hsh[:absorb_damage]&&hsh[:base_damage]>0)
    damage.type += 1 if(hsh[:damage_to_mp])
    damage.variance = hsh[:variance]
    if(damage.type>0)
      bsd, atk_f, spi_f = hsh.get_values(:base_damage,:atk_f,:spi_f)
      bsd = bsd.abs
      if(atk_f > 0 && spi_f > 0)
        damage.formula = format("%d + (4 * (a.atk * %d / 100.0)).to_i + (4 * (a.mat * %d / 100.0))).to_i", bsd, atk_f, spi_f)
      elsif(atk_f > 0)  
        damage.formula = format("%d + (4 * (a.atk * %d / 100.0)).to_i", bsd, atk_f)
      elsif(spi_f > 0)
        damage.formula = format("%d + (4 * (a.mat * %d / 100.0))).to_i", bsd, spi_f)
      else
        damage.formula = format("%d",bsd)
      end  
      unless(hsh[:ignore_defense]) 
        damage.formula = "("+damage.formula+")"
        if(hsh[:physical_attack])
          damage.formula += " - (2 * b.def)"
        else
          damage.formula += " - (2 * b.mdf)"
        end  
      end
      eid, = hsh[:element_set]
      eid ||= hsh[:physical_attack] ? -1 : 0
      damage.element_id = eid if(eid)
    end  
    damage
  end  
  def self.hsh2item(hsh)
    ite = RPG::Item.new()
    # // Ace Only
    ite.features     = []
    ite.repeats      = 1
    ite.tp_gain      = 0
    ite.effects      = []
    # // VX / Ace
    ite.id           = hsh[:id]          # // Integer
    ite.name         = hsh[:name]        # // String
    ite.icon_index   = hsh[:icon_index]  # // Integer
    ite.note         = hsh[:note]        # // String
    ite.description  = hsh[:description] # // String
    ite.scope        = hsh[:scope]       # // Integer
    ite.occasion     = hsh[:occasion]    # // Integer
    ite.speed        = hsh[:speed]       # // Integer
    ite.success_rate = hsh[:hit]         # // Integer
    ite.animation_id = hsh[:animation_id]# // Integer
    ite.hit_type     = hsh[:physical_attack] ? 1 : 2
    ite.price        = hsh[:price]       # // Integer
    ite.consumable   = hsh[:consumable]  # // Boolean
    ite.damage       = hsh2damage(hsh)
    ite.effects << MkEffect.common_event(hsh[:common_event_id]) if(hsh[:common_event_id]>0)
    ite.effects += hsh[:plus_state_set].collect{|sid|MkEffect.add_state(sid,0.7)}
    ite.effects += hsh[:minus_state_set].collect{|sid|MkEffect.rem_state(sid,1.0)}
    if(hsh[:hp_recovery_rate]>0||hsh[:hp_recovery]>0)
      ite.effects << MkEffect.recover_hp(hsh[:hp_recovery_rate]/100.0,hsh[:hp_recovery].to_f)
    end  
    if(hsh[:mp_recovery_rate]>0||hsh[:mp_recovery]>0)
      ite.effects << MkEffect.recover_mp(hsh[:mp_recovery_rate]/100.0,hsh[:mp_recovery].to_f)
    end
    if(hsh[:parameter_type]>0)
      ite.effects << MkEffect.grow([0,1,2,3,4,6][hsh[:parameter_type]-1],hsh[:parameter_points])
    end  
    ite
  end  
  def self.hsh2weapon(hsh)
    wep = RPG::Weapon.new()
    # // Ace Only
    wep.features     = []
    wep.wtype_id     = 0
    wep.etype_id     = 0
    # // VX / Ace
    wep.id           = hsh[:id]          # // Integer
    wep.name         = hsh[:name]        # // String
    wep.icon_index   = hsh[:icon_index]  # // Integer
    wep.note         = hsh[:note]        # // String
    wep.description  = hsh[:description] # // String
    wep.price        = hsh[:price]       # // Integer
    wep.animation_id = hsh[:animation_id]
    wep.params       = [0,0,hsh[:atk],hsh[:def],hsh[:spi],0,hsh[:agi],0]
    wep.features << MkFeature.hit_r(hsh[:hit]/100.0)
    wep.features << MkFeature.equip_seal(1) if(hsh[:two_handed])
    wep.features << MkFeature.atk_speed(10) if(hsh[:fast_attack])  
    wep.features << MkFeature.atk_times(1) if(hsh[:dual_attack])  
    wep.features << MkFeature.cri_r(0.05) if(hsh[:critical_bonus])  
    wep.features += hsh[:state_set].collect{|sid|MkFeature.atk_state(sid, 0.5)}
    wep.features += hsh[:element_set].collect{|eid|MkFeature.atk_element(eid)}
    wep
  end  
  def self.hsh2armor(hsh)
    arm = RPG::Armor.new()
    # // Ace Only
    arm.features     = []
    arm.atype_id     = 0
    # // VX / Ace
    arm.etype_id     = hsh[:kind] + 1
    arm.id           = hsh[:id]          # // Integer
    arm.name         = hsh[:name]        # // String
    arm.icon_index   = hsh[:icon_index]  # // Integer
    arm.note         = hsh[:note]        # // String
    arm.description  = hsh[:description] # // String
    arm.price        = hsh[:price]       # // Integer
    arm.params       = [0,0,hsh[:atk],hsh[:def],hsh[:spi],0,hsh[:agi],0]
    # // hsh[:prevent_critical] Dunno o-e
    arm.features << MkFeature.mcr(0.5) if(hsh[:half_mp_cost])  
    arm.features << MkFeature.exr(2.0) if(hsh[:double_exp_gain])  
    arm.features << MkFeature.hp_regen_r(0.1) if(hsh[:auto_hp_recover])  
    arm.features += hsh[:state_set].collect{|sid|MkFeature.state_resist(sid)}
    arm.features += hsh[:element_set].collect{|eid|MkFeature.element_r(eid,0.5)}
    arm
  end 
  def self.hsh2enemy(hsh)
    emy = RPG::Enemy.new()
    # // Ace Only
    emy.icon_index   = hsh[:icon_index]  # // Integer
    emy.description  = hsh[:description] # // String
    emy.features     = []
    # // VX / Ace
    emy.id           = hsh[:id]          # // Integer
    emy.name         = hsh[:name]        # // String
    emy.note         = hsh[:note]        # // String
    emy.battler_name = hsh[:battler_name]# // String
    emy.battler_hue  = hsh[:battler_hue] # // Integer
    emy.params       = [hsh[:maxhp],hsh[:maxmp],hsh[:atk],hsh[:def],hsh[:spi],10,hsh[:agi],10]
    emy.exp = hsh[:exp]
    emy.gold = hsh[:gold]
    emy.drop_items = Array.new(3) { RPG::Enemy::DropItem.new }
    emy.drop_items[0] = hsh2dropitem(hsh[:drop_item1])
    emy.drop_items[1] = hsh2dropitem(hsh[:drop_item2])
    emy.actions = hsh[:actions].collect{|a|hsh2action(a)}
    emy.features << MkFeature.hit_r(hsh[:hit]/100.0)
    emy.features << MkFeature.eva_r(hsh[:eva]/100.0)
    emy.features << MkFeature.cri_r(0.05) if(hsh[:has_critical])
    emy.features += elerank_a(hsh2table(hsh[:element_ranks]))
    emy.features += staterank_a(hsh2table(hsh[:state_ranks]))
    emy
  end    
  def self.hsh2dropitem(hsh)
    drop = RPG::Enemy::DropItem.new()
    drop.kind        = hsh[:kind]        # // Integer
    case(drop.kind)
    when 1 ; drop.data_id = hsh[:item_id]     # // Integer
    when 2 ; drop.data_id = hsh[:weapon_id]   # // Integer
    when 3 ; drop.data_id = hsh[:armor_id]    # // Integer
    end  
    drop.denominator = hsh[:denominator] # // Integer
    drop
  end  
  def self.hsh2action(hsh)
    action = RPG::Enemy::Action.new()
    case(hsh[:kind])
    when 0
      case(hsh[:basic])
      when 0 # // Attack
        action.skill_id = 1
      when 1 # // Guard
        action.skill_id = 2
      when 2 # // Escape 
        action.skill_id = 1
      when 3 # // Wait  
        action.skill_id = 1
      end  
    when 1
      action.skill_id = hsh[:skill_id]
    end  
    action.condition_type   = hsh[:condition_type]
    action.condition_param1 = hsh[:condition_param1]
    action.condition_param2 = hsh[:condition_param2]
    action.rating           = hsh[:rating]
    action
  end  
  def self.hsh2state(hsh)
    state = RPG::State.new()
    # // Ace Only
    state.features          = []
    state.description       = ''
    state.chance_by_damage  = 100
    state.remove_by_walking = false
    state.remove_by_restriction = false
    state.steps_to_remove   = 100
    # // VX / Ace
    state.id           = hsh[:id]          # // Integer
    state.name         = hsh[:name]        # // String
    state.icon_index   = hsh[:icon_index]  # // Integer
    state.note         = hsh[:note]        # // String
    case(hsh[:restriction])
    when 0 # // None
    when 1 # // Silence  
      state.restriction  = 0
      state.features << MkFeature.stype_seal(2)
    when 2 # // Always Attack Enemies  
      state.restriction  = 1
    when 3 # // Always Attack Allies
      state.restriction  = 3
    when 4 # // Cannot Move  
      state.restriction  = 4
    when 5 # // Cannot Move or Evade
      state.restriction  = 4
    end  
    state.priority       = hsh[:priority] * 10
    state.remove_at_battle_end  = hsh[:battle_only]
    state.auto_removal_timing   = hsh[:hold_turn] > 0 ? 2 : 0
    state.min_turns             = hsh[:hold_turn]
    state.max_turns             = hsh[:hold_turn] + (hsh[:hold_turn] - (hsh[:hold_turn] * hsh[:auto_release_prob] / 100.0)).to_i
    state.remove_by_damage      = hsh[:release_by_damage]
    state.message1 = hsh[:message1]
    state.message2 = hsh[:message2]
    state.message3 = hsh[:message3]
    state.message4 = hsh[:message4]
    state.features << MkFeature.hit_r(-0.5) if(hsh[:reduce_hit_ratio])
    state.features << MkFeature.hp_regen_r(-0.10) if(hsh[:slip_damage])
    state.features << MkFeature.atk_r(hsh[:atk_rate]/100.0) if(hsh[:atk_rate] != 100)  
    state.features << MkFeature.def_r(hsh[:def_rate]/100.0) if(hsh[:def_rate] != 100)  
    state.features << MkFeature.mat_r(hsh[:spi_rate]/100.0) if(hsh[:spi_rate] != 100)  
    state.features << MkFeature.agi_r(hsh[:agi_rate]/100.0) if(hsh[:agi_rate] != 100)  
    state.features += hsh[:element_set].collect{|eid|MkFeature.element_r(eid,0.5)}
    # // hsh[:offset_by_opposite] dunno
    # // hsh[:state_set] requires LV2 Conversion
    state  
  end  
  def self.hsh2system(hsh)
    sys                 = RPG::System.new()
    sys.japanese        = false
    sys.currency_unit   = hsh[:terms][:gold]
    sys.skill_types     = [nil, '']
    sys.weapon_types    = [nil, '']
    sys.armor_types     = [nil, '']
    sys.title1_name     = ''
    sys.title2_name     = ''
    sys.opt_draw_title  = true
    sys.opt_use_midi    = false
    sys.opt_transparent = false
    sys.opt_followers   = true
    sys.opt_slip_death  = false
    sys.opt_floor_death = false
    sys.opt_display_tp  = true
    sys.opt_extra_exp   = false
    sys.window_tone     = Tone.new(0,0,0)
    sys.battleback1_name = ''
    sys.battleback2_name = ''
    sys.game_title     = hsh[:game_title]
    sys.version_id     = hsh[:version_id]
    sys.party_members  = hsh[:party_members]
    sys.elements       = hsh[:elements]
    sys.switches       = hsh[:switches]
    sys.variables      = hsh[:variables]
    sys.boat           = hsh2veh(hsh[:boat])
    sys.ship           = hsh2veh(hsh[:ship])
    sys.airship        = hsh2veh(hsh[:airship])
    sys.title_bgm      = hsh2bgm(hsh[:title_bgm])
    sys.battle_bgm     = hsh2bgm(hsh[:battle_bgm])
    sys.battle_end_me  = hsh2me(hsh[:battle_end_me])
    sys.gameover_me    = hsh2me(hsh[:gameover_me])
    sys.sounds = Array.new(24) { RPG::SE.new }
    snds = hsh[:sounds]
    sys.sounds[0] = hsh2se(snds[0]) # // Cursor
    sys.sounds[1] = hsh2se(snds[1]) # // Decision
    sys.sounds[2] = hsh2se(snds[2]) # // Cancel
    sys.sounds[3] = hsh2se(snds[3]) # // Buzzer
    sys.sounds[4] = hsh2se(snds[4]) # // Equip
    sys.sounds[5] = hsh2se(snds[5]) # // Save
    sys.sounds[6] = hsh2se(snds[6]) # // Load
    sys.sounds[7] = hsh2se(snds[7]) # // Battle Start
    sys.sounds[8] = hsh2se(snds[8]) # // Escape 
    sys.sounds[9] = hsh2se(snds[9]) # // Enemy Attack
    sys.sounds[10]= hsh2se(snds[10])# // Enemy Damage
    sys.sounds[11]= hsh2se(snds[11])# // Enemy Collapse
    
    sys.sounds[14]= hsh2se(snds[12])# // Actor Damage
    sys.sounds[15]= hsh2se(snds[13])# // Actor Collapse
    sys.sounds[16]= hsh2se(snds[14])# // Recovery
    sys.sounds[17]= hsh2se(snds[15])# // Miss
    sys.sounds[18]= hsh2se(snds[16])# // Evasion
    
    sys.sounds[21]= hsh2se(snds[17])# // Shop
    sys.sounds[22]= hsh2se(snds[18])# // Use Item
    sys.sounds[23]= hsh2se(snds[19])# // Use Skill

    sys.test_battlers = hsh[:test_battlers].collect{|a|hsh2testbat(a)}
    sys.test_troop_id = hsh[:test_troop_id]
    sys.start_map_id  = hsh[:start_map_id]
    sys.start_x       = hsh[:start_x]
    sys.start_y       = hsh[:start_y]
    sys.terms         = hsh2terms(hsh[:terms])
    sys.battler_name  = hsh[:battler_name]
    sys.battler_hue   = hsh[:battler_hue]
    sys.edit_map_id   = hsh[:edit_map_id]
    # // hsh[:passages] Ignored
    sys
  end  
  def self.hsh2veh(hsh)
    veh = RPG::System::Vehicle.new()
    veh.character_name  = hsh[:character_name]  # // String
    veh.character_index = hsh[:character_index] # // Integer
    veh.bgm             = hsh2bgm(hsh[:bgm])   
    veh.start_map_id    = hsh[:start_map_id]    # // Integer
    veh.start_x         = hsh[:start_x]         # // Integer
    veh.start_y         = hsh[:start_y]         # // Integer
    veh
  end  
  def self.hsh2testbat(hsh)
    bat = RPG::System::TestBattler.new()
    bat.actor_id = hsh[:actor_id]
    bat.level    = hsh[:level]
    bat.equips   = hsh.get_values(:weapon_id,:armor1_id,:armor2_id,:armor3_id,:armor4_id)
    bat
  end  
  def self.hsh2terms(hsh)
    terms = RPG::System::Terms.new()
    terms.basic    = Array.new(8) {''}
    terms.basic[0] = hsh[:level]
    terms.basic[1] = hsh[:level_a]
    terms.basic[2] = hsh[:hp]
    terms.basic[3] = hsh[:hp_a]
    terms.basic[4] = hsh[:mp]
    terms.basic[5] = hsh[:mp_a]
    terms.basic[6] = 'TP'
    terms.basic[7] = 'TP'
    terms.params   = Array.new(8) {''}
    terms.params[0]= 'MHP'
    terms.params[1]= 'MMP'
    terms.params[2]= hsh[:atk]
    terms.params[3]= hsh[:def]
    terms.params[4]= hsh[:spi]
    terms.params[5]= 'RES'
    terms.params[6]= hsh[:agi]
    terms.params[7]= 'LUK'
    terms.etypes   = Array.new(5) {''}
    terms.etypes[0]= hsh[:weapon]
    terms.etypes[1]= hsh[:armor1]
    terms.etypes[2]= hsh[:armor2]
    terms.etypes[3]= hsh[:armor3]
    terms.etypes[4]= hsh[:armor4]
    terms.commands = Array.new(23) {''}
    terms.commands[0] = hsh[:fight]
    terms.commands[1] = hsh[:escape]
    terms.commands[2] = hsh[:attack]
    terms.commands[3] = hsh[:guard]
    terms.commands[4] = hsh[:item]
    terms.commands[5] = hsh[:skill]
    terms.commands[6] = hsh[:equip]
    terms.commands[7] = hsh[:status]
    terms.commands[8] = 'Formation'
    terms.commands[9] = hsh[:save]
    terms.commands[10]= hsh[:game_end]
    terms.commands[12]= 'Weapon'
    terms.commands[13]= 'Armor'
    terms.commands[14]= 'Important' # // Important Items
    terms.commands[15]= 'Change'    # // Change Equip
    terms.commands[16]= 'Optimize'  # // Best Equipment
    terms.commands[17]= 'Clear'     # // Remove Equipment
    terms.commands[18]= hsh[:new_game]
    terms.commands[19]= hsh[:continue]
    terms.commands[20]= hsh[:shutdown]
    terms.commands[21]= hsh[:to_title]
    terms.commands[22]= hsh[:cancel]        
    terms
  end  
  def self.load_vx2dump(filename)
    begin
      return load_data("VX2Data(Out)/#{filename}.vx2dump")
    rescue(Exception) => ex
      puts format("%s.vx2dump failed to load", filename)
      puts ex
      sleep 0.3
      return nil
    end  
  end
  def self.save_data_ace(obj, filename)
    save_data(obj, "Data(Ace)/#{filename}.rvdata2")
  end  
  def self.fmsg(text)
    format("<Hash2Ace:@>%s",text)
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
  GPS  = Win32API.new( "kernel32", "GetPrivateProfileStringA", "pppplp", "l")
  def self.read_config()
    unless(File.exist?("VX2Ace.ini"))
      File.open("VX2Ace.ini", "w+") do |f|
        f.puts "[Settings]"
        f.puts "ActorParam2Class=0"
        f.puts "CleverClassEquip=0"
      end
    end  
    hsh = {}
    hsh[:ap2c] = config_read_string("ActorParam2Class").to_i
    hsh[:cce]  = config_read_string("CleverClassEquip").to_i
    hsh
  end 
  def self.config_read_string(s)
    str = "\0" * 256
    GPS.call( 'Settings',s, '', str, 255, ".\\VX2Ace.ini" )
    str.delete!("\0")
  end  
  def self.run!()
    unless(File.exist?("VX2Data(Out)"))
      puts fmsg("Making VX2Data(Out) Folder")
      Dir.mkdir("VX2Data(Out)")
    end 
    unless(File.exist?("Data(Ace)"))
      puts fmsg("Making Data(Ace) Folder")
      Dir.mkdir("Data(Ace)")
    end
    config_hsh = read_config()
    pfmsg "[ap2c]: #{config_hsh[:ap2c]}" 
    pfmsg "[cce] : #{config_hsh[:cce]}" 
    pfmsg "[Starting Hash2Ace]"
    swait(80)
    loaded = {}
    ["Actors","Classes","Skills","Items",
     "Weapons","Armors","Enemies","States"].each do |s|
      loaded[s] = load_vx2dump(s) 
    end
    if(loaded["Actors"])
      pfmsg "Loading and converting Actors"
      actors = loaded["Actors"].collect{|hsh|hsh ? hsh2actor(hsh) : hsh}
    end  
    if(loaded["Classes"])
      pfmsg "Loading and converting Classes"
      classes= loaded["Classes"].collect{|hsh|hsh ? hsh2class(hsh) : hsh}
    end
    if(loaded["Skills"])
      pfmsg "Loading and converting Skills"
      skills = loaded["Skills"].collect{|hsh|hsh ? hsh2skill(hsh) : hsh}
    end
    if(loaded["Items"])
      pfmsg "Loading and converting Items"
      items  = loaded["Items"].collect{|hsh|hsh ? hsh2item(hsh) : hsh}
    end
    if(loaded["Weapons"])
      pfmsg "Loading and converting Weapons"
      weapons= loaded["Weapons"].collect{|hsh|hsh ? hsh2weapon(hsh) : hsh}
    end
    if(loaded["Armors"])
      pfmsg "Loading and converting Armors"
      armors = loaded["Armors"].collect{|hsh|hsh ? hsh2armor(hsh) : hsh}
    end
    if(loaded["Enemies"])
      pfmsg "Loading and converting Enemies"
      enemies= loaded["Enemies"].collect{|hsh|hsh ? hsh2enemy(hsh) : hsh}
    end
    if(loaded["States"])
      pfmsg "Loading and converting States"
      states = loaded["States"].collect{|hsh|hsh ? hsh2state(hsh) : hsh}
    end
    if(loaded["System"])
      pfmsg "Loading and converting System"
      system = hsh2system(load_vx2dump("System"))
    end  
    maps = Dir.glob("VX2Data(Out)/Map*.vx2dump")
    if(maps&&maps.size>0)
      pfmsg "Loading and converting Maps"
      maps = maps.collect{|m|
        puts "->Converting Map #{m}"
        [hsh2map(load_data(m)),m]
      }
    end  
    pfmsg "[Load and Convert Complete]"
    # // 
    swait(80)
    pfmsg "-Fixing up-"
    if(config_hsh[:ap2c]==1&&(actors&&classes))
      pfmsg "Applying Actor Parameters to Classes"
      params = nil
      x,y = nil, nil
      cls = nil
      loaded["Actors"].each do |a| next unless(a)
        params = hsh2table(a[:parameters])
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
    #if(config_hsh[:cce]==1)
    #  clsweapons, clsarmors = nil, nil
    #  loaded["Classes"].each do |clshsh|
    #    clsweapons = clshsh[:weapon_set]
    #    clsarmors  = clshsh[:armor_set]
    #  end  
    #  # // hsh[:weapon_set] Level 2 Conversion required
    #  # // hsh[:armor_set] Level 2 Conversion required
    #end  
    # // 
    pfmsg "Saving"
    if(actors)
      pfmsg "Actors >> "
      save_data_ace(actors , "Actors") 
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
    if(states)
      pfmsg "States >> "
      save_data_ace(states , "States") 
    end
    if(system)
      pfmsg "System >> "
      save_data_ace(system , "System")
    end
    if(maps&&maps.size>0)
      pfmsg "Maps >> "
      maps.each {|a|save_data_ace(a[0],File.basename(a[1]).gsub(/\.vx2dump/i,""))}
    end  
    # // 
    swait(40)
    paw("Hash2Ace Complete")
  end  
end      