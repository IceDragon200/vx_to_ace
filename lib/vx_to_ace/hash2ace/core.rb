module Hash2Ace
  NAME2HSHCOM = {
    'Color'            => 'hash_to_color',
    'Tone'             => 'hash_to_tone',
    'Rect'             => 'hash_to_rect',
    'Table'            => 'hash_to_table',
    'RPG::Actor'       => 'hash_to_actor',
    'RPG::Animation'   => 'hash_to_animation',
    'RPG::Armor'       => 'hash_to_armor',
    'RPG::AudioFile'   => 'hash_to_aud',
    'RPG::BaseItem'    => 'hash_to_base_item',
    'RPG::BGM'         => 'hash_to_bgm',
    'RPG::BGS'         => 'hash_to_bgs',
    'RPG::Class'       => 'hash_to_class',
    'RPG::Enemy'       => 'hash_to_enemy',
    'RPG::EventCommand'=> 'hash_to_event_command',
    'RPG::Item'        => 'hash_to_item',
    'RPG::ME'          => 'hash_to_me',
    'RPG::MoveCommand' => 'hash_to_move_command',
    'RPG::MoveRoute'   => 'hash_to_move_route',
    'RPG::SE'          => 'hash_to_se',
    'RPG::Skill'       => 'hash_to_skill',
    'RPG::State'       => 'hash_to_state',
    'RPG::System'      => 'hash_to_system',
    'RPG::Troop'       => 'hash_to_troop',
    'RPG::Weapon'      => 'hash_to_weapon',
    'RPG::MapInfo'     => 'hash_to_map_info',
  }

  def self.try_vxdump_to_ace(obj)
    return obj unless(obj.is_a?(Hash))
    header,= obj[:_header]
    return obj unless(header)
    unless NAME2HSHCOM.has_key?(header)
      fail "->Unsupported _header type #{header}"
    end
    self.send(NAME2HSHCOM[header], obj)
  end

  def self.elerank_a(tab)
    eleranks = [0,200,150,100,50,0,-100].map {|r|r/100.0}
    result =[]
    for x in 1...tab.xsize
      result << MkFeature.element_r(x,eleranks[tab[x]]) if(eleranks[tab[x]]!=1.0)
    end
    result
  end

  def self.staterank_a(tab)
    staranks = [0,100,80,60,40,20,0].map {|r|r/100.0}
    result = []
    for x in 1...tab.xsize
      result << MkFeature.state_r(x,staranks[tab[x]]) if(staranks[tab[x]]!=0.6)
    end
    result
  end

  def self.hash_to_rect(hsh)
    rect = Rect.new
    rect.x = hsh[:x]
    rect.y = hsh[:y]
    rect.width = hsh[:width]
    rect.height = hsh[:height]
    rect
  end

  def self.hash_to_color(hsh)
    color = Color.new
    color.red = hsh[:red]
    color.green = hsh[:green]
    color.blue = hsh[:blue]
    color.alpha = hsh[:alpha]
    color
  end

  def self.hash_to_tone(hsh)
    tone = Tone.new
    tone.red = hsh[:red]
    tone.green = hsh[:green]
    tone.blue = hsh[:blue]
    tone.gray = hsh[:gray]
    tone
  end

  def self.hash_to_table(hsh)
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

  def self.hash_to_audio_a(hsh)
    hsh.get_values(:name,:volume,:pitch)
  end

  def self.hash_to_aud(hsh)
    RPG::AudioFile.new(*hash_to_audio_a(hsh))
  end

  def self.hash_to_bgm(hsh)
    RPG::BGM.new(*hash_to_audio_a(hsh))
  end

  def self.hash_to_bgs(hsh)
    RPG::BGS.new(*hash_to_audio_a(hsh))
  end

  def self.hash_to_se(hsh)
    RPG::SE.new(*hash_to_audio_a(hsh))
  end

  def self.hash_to_me(hsh)
    RPG::ME.new(*hash_to_audio_a(hsh))
  end

  def self.hash_to_event(hsh)
    ev = RPG::Event.new(0,0)
    ev.id    = hsh[:id]   # // Integer
    ev.name  = hsh[:name] # // String
    ev.x     = hsh[:x]    # // Integer
    ev.y     = hsh[:y]    # // Integer
    ev.pages = hsh[:pages].map  { |evphsh| hash_to_event_page(evphsh) }
    ev
  end

  def self.hash_to_event_page(hsh)
    page = RPG::Event::Page.new
    page.condition      = hash_to_event_page_condition(hsh[:condition])
    page.graphic        = hash_to_event_page_graphic(hsh[:graphic])
    page.move_type      = hsh[:move_type]      # // Integer
    page.move_speed     = hsh[:move_speed]     # // Integer
    page.move_frequency = hsh[:move_frequency] # // Integer
    page.move_route     = hash_to_move_route(hsh[:move_route])
    page.walk_anime     = hsh[:walk_anime]     # // Boolean
    page.step_anime     = hsh[:step_anime]     # // Boolean
    page.direction_fix  = hsh[:direction_fix]  # // Boolean
    page.through        = hsh[:through]        # // Boolean
    page.priority_type  = hsh[:priority_type]  # // Integer
    page.trigger        = hsh[:trigger]        # // Integer
    page.list           = hsh[:list].map { |evhsh| hash_to_event_command(evhsh) }
    page
  end

  def self.hash_to_event_page_condition(hsh)
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

  def self.hash_to_event_page_graphic(hsh)
    graph = RPG::Event::Page::Graphic.new
    graph.tile_id         = hsh[:tile_id]            # // Integer
    graph.character_name  = hsh[:character_name]     # // String
    graph.character_index = hsh[:character_index]    # // Integer
    graph.direction       = hsh[:direction]          # // Integer
    graph.pattern         = hsh[:pattern]            # // Integer
    graph
  end

  def self.hash_to_event_command(hsh)
    evcom = RPG::EventCommand.new
    evcom.code       = hsh[:code]                    # // Integer
    evcom.indent     = hsh[:indent]                  # // Integer
    evcom.parameters = hsh[:parameters].map { |o| try_vxdump_to_ace(o) } # // Array[]
    fix_event_command(evcom)
  end

  def self.fix_event_command(evcom)
    consts = RPG::EventCommand::EvCCodes
    case evcom.code
    when consts::CONTROL_VARIABLE
      case evcom.parameters[3]
      when 3 # // Item
        evcom.parameters[3] = 3
        evcom.parameters.insert(4,0)
      when 4 # // Actor
        evcom.parameters[3] = 3
        evcom.parameters[5] = ([0,1,2,3,4,5,6,7,8,10])[evcom.parameters[5]]
        evcom.parameters.insert(4,3)
      when 5 # // Enemy
        evcom.parameters[3] = 3
        evcom.parameters[5] = ([0,1,2,3,4,5,6,8])[evcom.parameters[5]]
        evcom.parameters.insert(4,4)
      when 6 # // Character
        evcom.parameters[3] = 3
        evcom.parameters.insert(4,5)
      when 7 # // Other
        evcom.parameters[3] = 3
        evcom.parameters.insert(4,7)
      end
    end
    evcom
  end

  def self.hash_to_move_route(hsh)
    mvr = RPG::MoveRoute.new
    mvr.repeat    = hsh[:repeat]       # // Boolean
    mvr.skippable = hsh[:skippable]    # // Boolean
    mvr.wait      = hsh[:wait]         # // Boolean
    mvr.list      = hsh[:list].map {|mvcm|hash_to_move_command(mvcm)}
    mvr
  end

  def self.hash_to_move_command(hsh)
    mvcm = RPG::MoveCommand.new
    mvcm.code       = hsh[:code]       # // Integer
    mvcm.parameters = hsh[:parameters].map {|o|try_vxdump_to_ace(o)}# // Array[]
    mvcm
  end

  def self.hash_to_common_event(hsh)
    comev = RPG::CommonEvent.new
    comev.id        = hsh[:id]           # // Integer
    comev.name      = hsh[:name]         # // String
    comev.trigger   = hsh[:trigger]      # // Boolean
    comev.switch_id = hsh[:switch_id]    # // Integer
    comev.list      = hsh[:list].map { |o| hash_to_event_command(o) }# // Array[]
    comev
  end

  def self.hash_to_map(hsh)
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
    map.bgm                   = hash_to_bgm(hsh[:bgm])
    map.autoplay_bgs          = hsh[:autoplay_bgs]    # // Boolean
    map.bgs                   = hash_to_bgs(hsh[:bgs])
    map.disable_dashing       = hsh[:disable_dashing] # // Boolean
    map.encounter_list        = hsh[:encounter_list]  # // Array
    map.encounter_step        = hsh[:encounter_step]  # // Integer
    map.parallax_name         = hsh[:parallax_name]   # // String
    map.parallax_loop_x       = hsh[:parallax_loop_x] # // Boolean
    map.parallax_loop_y       = hsh[:parallax_loop_y] # // Boolean
    map.parallax_sx           = hsh[:parallax_sx]     # // Integer
    map.parallax_sy           = hsh[:parallax_sy]     # // Integer
    map.parallax_show         = hsh[:parallax_show]   # // Boolean
    data                      = hash_to_table(hsh[:data])
    map.events = {}
    hsh[:events].each_pair { |k,evhsh| map.events[k] = hash_to_event(evhsh) }
    # copy data from old data to new data, avoid using Table#resize, since
    # different implementations may ignore the data copying for performance.
    map.data = Table.new(data.xsize, data.ysize, 4)
    data.zsize.times do |z|
      data.ysize.times do |y|
        data.xsize.times do |x|
          map.data[x, y, z] = data[x, y, z]
        end
      end
    end
    map
  end

  # // BaseItem
  def self.hash_to_base_item(hsh)
    bsite = RPG::BaseItem.new
    bsite.id          = hsh[:id]          # // Integer
    bsite.name        = hsh[:name]        # // String
    bsite.icon_index  = hsh[:icon_index]  # // Integer
    bsite.note        = hsh[:note]        # // String
    bsite.description = hsh[:description] # // String
    bsite.features    = []
    bsite
  end

  def self.hash_to_actor(hsh)
    actor = RPG::Actor.new
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
    actor.features += (0...5).map {|i|MkFeature.equip_fix(i)} if(hsh[:fix_equipment])
    actor.features << MkFeature.auto_battle if(hsh[:auto_battle])
    actor.features << MkFeature.grd_r(2.00) if(hsh[:super_guard])
    actor.features << MkFeature.pha_r(2.00) if(hsh[:pharmacology])
    actor.features << MkFeature.cri_r(0.40) if(hsh[:critical_bonus])
    actor
  end

  def self.hash_to_animation_frame(hsh)
    frame = RPG::Animation::Frame.new
    frame.cell_max = hsh[:cell_max]
    frame.cell_data = hash_to_table(hsh[:cell_data])
    frame
  end

  def self.hash_to_animation_timing(hsh)
    timing = RPG::Animation::Timing.new
    timing.frame = hsh[:frame]
    timing.se = hash_to_se(hsh[:se])
    timing.flash_scope = hsh[:flash_scope]
    timing.flash_color = hash_to_color(hsh[:flash_color])
    timing.flash_duration = hsh[:flash_duration]
    timing
  end

  def self.hash_to_animation(hsh)
    animation = RPG::Animation.new
    animation.id              = hsh[:id]
    animation.name            = hsh[:name]
    animation.animation1_name = hsh[:animation1_name]
    animation.animation1_hue  = hsh[:animation1_hue]
    animation.animation2_name = hsh[:animation2_name]
    animation.animation2_hue  = hsh[:animation2_hue]
    animation.position        = hsh[:position]
    animation.frame_max       = hsh[:frame_max]
    animation.frames          = hsh[:frames].map { |o| hash_to_animation_frame(o) }
    animation.timings         = hsh[:timings].map { |o| hash_to_animation_timing(o) }
    animation
  end

  def self.hash_to_class(hsh)
    cls = RPG::Class.new
    # // Ace Only
    cls.icon_index  = 0
    cls.note        = ''
    cls.description = ''
    cls.features    = []
    # // VX / Ace
    cls.id          = hsh[:id]   # // Integer
    cls.name        = hsh[:name] # // String
    cls.features << MkFeature.stype_add(1)
    cls.features << MkFeature.tgr([1.00,0.75,0.50][hsh[:position]])
    # // Ace Tailing
    cls.features << MkFeature.hit_r(0.95)
    cls.features << MkFeature.eva_r(0.05)
    cls.features << MkFeature.cri_r(0.05)
    # // hsh[:weapon_set] Level 2 Conversion required
    # // hsh[:armor_set] Level 2 Conversion required
    cls.features += elerank_a(hash_to_table(hsh[:element_ranks]))
    cls.features += staterank_a(hash_to_table(hsh[:state_ranks]))
    cls.learnings = hsh[:learnings].map {|lrnhsh|hash_to_class_learning(lrnhsh)}
    # // hsh[:skill_name_valid] # // Boolean unused
    # // hsh[:skill_name]       # // String  unused
    cls
  end

  def self.hash_to_class_learning(hsh)
    learning = RPG::Class::Learning.new
    # // Ace Only
    learning.note = ''
    # // VX / Ace
    learning.skill_id = hsh[:skill_id] # // Integer
    learning.level    = hsh[:level]    # // Integer
    learning
  end

  def self.hash_to_skill(hsh)
    skill = RPG::Skill.new
    # // Ace Only
    skill.features     = []
    skill.repeats      = 1
    skill.tp_gain      = 0
    skill.effects      = []
    skill.stype_id     = 1
    # // VX / Ace
    skill.id           = hsh[:id]          # // Integer
    skill.name         = hsh[:name]        # // String
    skill.icon_index   = hsh[:icon_index]  # // Integer
    skill.note         = hsh[:note]        # // String
    skill.description  = hsh[:description] # // String
    skill.scope        = hsh[:scope]       # // Integer
    skill.occasion     = hsh[:occasion]    # // Integer
    skill.speed        = hsh[:speed]       # // Integer
    skill.success_rate = hsh[:hit]         # // Integer
    skill.animation_id = hsh[:animation_id]# // Integer
    skill.hit_type     = hsh[:physical_attack] ? 1 : 2
    skill.mp_cost      = hsh[:mp_cost]     # // Integer
    skill.message1     = hsh[:message1]    # // String
    skill.message2     = hsh[:message2]    # // String
    skill.damage       = hash_to_damage(hsh)
    skill.effects << MkEffect.common_event(hsh[:common_event_id]) if(hsh[:common_event_id]>0)
    skill.effects += hsh[:plus_state_set].map {|sid|MkEffect.add_state(sid,0.7)}
    skill.effects += hsh[:minus_state_set].map {|sid|MkEffect.rem_state(sid,1.0)}
    skill
  end

  def self.hash_to_damage(hsh)
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

  def self.hash_to_item(hsh)
    ite = RPG::Item.new
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
    ite.damage       = hash_to_damage(hsh)
    ite.effects << MkEffect.common_event(hsh[:common_event_id]) if(hsh[:common_event_id]>0)
    ite.effects += hsh[:plus_state_set].map {|sid|MkEffect.add_state(sid,0.7)}
    ite.effects += hsh[:minus_state_set].map {|sid|MkEffect.rem_state(sid,1.0)}
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

  def self.hash_to_weapon(hsh)
    wep = RPG::Weapon.new
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
    wep.features += hsh[:state_set].map {|sid|MkFeature.atk_state(sid, 0.5)}
    wep.features += hsh[:element_set].map {|eid|MkFeature.atk_element(eid)}
    wep
  end

  def self.hash_to_armor(hsh)
    arm = RPG::Armor.new
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
    arm.features += hsh[:state_set].map {|sid|MkFeature.state_resist(sid)}
    arm.features += hsh[:element_set].map {|eid|MkFeature.element_r(eid,0.5)}
    arm
  end

  def self.hash_to_enemy(hsh)
    emy = RPG::Enemy.new
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
    emy.drop_items[0] = hash_to_drop_item(hsh[:drop_item1])
    emy.drop_items[1] = hash_to_drop_item(hsh[:drop_item2])
    emy.actions = hsh[:actions].map { |a| hash_to_action(a) }
    emy.features << MkFeature.hit_r(hsh[:hit]/100.0)
    emy.features << MkFeature.eva_r(hsh[:eva]/100.0)
    emy.features << MkFeature.cri_r(0.05) if(hsh[:has_critical])
    emy.features += elerank_a(hash_to_table(hsh[:element_ranks]))
    emy.features += staterank_a(hash_to_table(hsh[:state_ranks]))
    emy
  end

  def self.hash_to_drop_item(hsh)
    drop = RPG::Enemy::DropItem.new
    drop.kind        = hsh[:kind]        # // Integer
    case(drop.kind)
    when 1 ; drop.data_id = hsh[:item_id]     # // Integer
    when 2 ; drop.data_id = hsh[:weapon_id]   # // Integer
    when 3 ; drop.data_id = hsh[:armor_id]    # // Integer
    end
    drop.denominator = hsh[:denominator] # // Integer
    drop
  end

  def self.hash_to_action(hsh)
    action = RPG::Enemy::Action.new
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

  def self.hash_to_state(hsh)
    state = RPG::State.new
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
    state.features += hsh[:element_set].map {|eid|MkFeature.element_r(eid,0.5)}
    # // hsh[:offset_by_opposite] dunno
    # // hsh[:state_set] requires LV2 Conversion
    state
  end

  def self.hash_to_system(hsh)
    sys                 = RPG::System.new
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
    sys.boat           = hash_to_vehicle(hsh[:boat])
    sys.ship           = hash_to_vehicle(hsh[:ship])
    sys.airship        = hash_to_vehicle(hsh[:airship])
    sys.title_bgm      = hash_to_bgm(hsh[:title_bgm])
    sys.battle_bgm     = hash_to_bgm(hsh[:battle_bgm])
    sys.battle_end_me  = hash_to_me(hsh[:battle_end_me])
    sys.gameover_me    = hash_to_me(hsh[:gameover_me])
    sys.sounds = Array.new(24) { RPG::SE.new }
    snds = hsh[:sounds]
    sys.sounds[0] = hash_to_se(snds[0]) # // Cursor
    sys.sounds[1] = hash_to_se(snds[1]) # // Decision
    sys.sounds[2] = hash_to_se(snds[2]) # // Cancel
    sys.sounds[3] = hash_to_se(snds[3]) # // Buzzer
    sys.sounds[4] = hash_to_se(snds[4]) # // Equip
    sys.sounds[5] = hash_to_se(snds[5]) # // Save
    sys.sounds[6] = hash_to_se(snds[6]) # // Load
    sys.sounds[7] = hash_to_se(snds[7]) # // Battle Start
    sys.sounds[8] = hash_to_se(snds[8]) # // Escape
    sys.sounds[9] = hash_to_se(snds[9]) # // Enemy Attack
    sys.sounds[10]= hash_to_se(snds[10])# // Enemy Damage
    sys.sounds[11]= hash_to_se(snds[11])# // Enemy Collapse

    sys.sounds[14]= hash_to_se(snds[12])# // Actor Damage
    sys.sounds[15]= hash_to_se(snds[13])# // Actor Collapse
    sys.sounds[16]= hash_to_se(snds[14])# // Recovery
    sys.sounds[17]= hash_to_se(snds[15])# // Miss
    sys.sounds[18]= hash_to_se(snds[16])# // Evasion

    sys.sounds[21]= hash_to_se(snds[17])# // Shop
    sys.sounds[22]= hash_to_se(snds[18])# // Use Item
    sys.sounds[23]= hash_to_se(snds[19])# // Use Skill

    sys.test_battlers = hsh[:test_battlers].map {|a|hash_to_test_battler(a)}
    sys.test_troop_id = hsh[:test_troop_id]
    sys.start_map_id  = hsh[:start_map_id]
    sys.start_x       = hsh[:start_x]
    sys.start_y       = hsh[:start_y]
    sys.terms         = hash_to_system_terms(hsh[:terms])
    sys.battler_name  = hsh[:battler_name]
    sys.battler_hue   = hsh[:battler_hue]
    sys.edit_map_id   = hsh[:edit_map_id]
    # // hsh[:passages] Ignored
    sys
  end

  def self.hash_to_vehicle(hsh)
    veh = RPG::System::Vehicle.new
    veh.character_name  = hsh[:character_name]  # // String
    veh.character_index = hsh[:character_index] # // Integer
    veh.bgm             = hash_to_bgm(hsh[:bgm])
    veh.start_map_id    = hsh[:start_map_id]    # // Integer
    veh.start_x         = hsh[:start_x]         # // Integer
    veh.start_y         = hsh[:start_y]         # // Integer
    veh
  end

  def self.hash_to_test_battler(hsh)
    bat = RPG::System::TestBattler.new
    bat.actor_id = hsh[:actor_id]
    bat.level    = hsh[:level]
    bat.equips   = hsh.get_values(:weapon_id,:armor1_id,:armor2_id,:armor3_id,:armor4_id)
    bat
  end

  def self.hash_to_system_terms(hsh)
    terms = RPG::System::Terms.new
    terms.basic    = Array.new(8) {''}
    terms.basic[0] = hsh[:level]       # // String
    terms.basic[1] = hsh[:level_a]     # // String
    terms.basic[2] = hsh[:hp]          # // String
    terms.basic[3] = hsh[:hp_a]        # // String
    terms.basic[4] = hsh[:mp]          # // String
    terms.basic[5] = hsh[:mp_a]        # // String
    terms.basic[6] = 'TP'
    terms.basic[7] = 'TP'
    terms.params   = Array.new(8) {''}
    terms.params[0]= 'MHP'
    terms.params[1]= 'MMP'
    terms.params[2]= hsh[:atk]         # // String
    terms.params[3]= hsh[:def]         # // String
    terms.params[4]= hsh[:spi]         # // String
    terms.params[5]= 'RES'
    terms.params[6]= hsh[:agi]         # // String
    terms.params[7]= 'LUK'
    terms.etypes   = Array.new(5) {''}
    terms.etypes[0]= hsh[:weapon]      # // String
    terms.etypes[1]= hsh[:armor1]      # // String
    terms.etypes[2]= hsh[:armor2]      # // String
    terms.etypes[3]= hsh[:armor3]      # // String
    terms.etypes[4]= hsh[:armor4]      # // String
    terms.commands = Array.new(23) {''}
    terms.commands[0] = hsh[:fight]    # // String
    terms.commands[1] = hsh[:escape]   # // String
    terms.commands[2] = hsh[:attack]   # // String
    terms.commands[3] = hsh[:guard]    # // String
    terms.commands[4] = hsh[:item]     # // String
    terms.commands[5] = hsh[:skill]    # // String
    terms.commands[6] = hsh[:equip]    # // String
    terms.commands[7] = hsh[:status]   # // String
    terms.commands[8] = 'Formation'
    terms.commands[9] = hsh[:save]     # // String
    terms.commands[10]= hsh[:game_end] # // String
    terms.commands[12]= 'Weapon'
    terms.commands[13]= 'Armor'
    terms.commands[14]= 'Important'    # // Important Items
    terms.commands[15]= 'Change'       # // Change Equip
    terms.commands[16]= 'Optimize'     # // Best Equipment
    terms.commands[17]= 'Clear'        # // Remove Equipment
    terms.commands[18]= hsh[:new_game] # // String
    terms.commands[19]= hsh[:continue] # // String
    terms.commands[20]= hsh[:shutdown] # // String
    terms.commands[21]= hsh[:to_title] # // String
    terms.commands[22]= hsh[:cancel]   # // String
    terms
  end

  def self.hash_to_map_info(hsh)
    mapinf = RPG::MapInfo.new
    mapinf.name      = hsh[:name]      # // String
    mapinf.parent_id = hsh[:parent_id] # // Integer
    mapinf.order     = hsh[:order]     # // Integer
    mapinf.expanded  = hsh[:expanded]  # // Boolean
    mapinf.scroll_x  = hsh[:scroll_x]  # // Integer
    mapinf.scroll_y  = hsh[:scroll_y]  # // Integer
    mapinf
  end

  def self.hash_to_troop_member(hsh)
    mem = RPG::Troop::Member.new
    mem.enemy_id = hsh.fetch(:enemy_id)
    mem.x = hsh.fetch(:x)
    mem.y = hsh.fetch(:y)
    mem.hidden = hsh.fetch(:hidden)
    #mem.immortal = hsh.fetch(:immortal)
    mem
  end

  def self.hash_to_troop_page_condition(hsh)
    cond = RPG::Troop::Page::Condition.new
    cond.turn_ending = hsh.fetch(:turn_ending)
    cond.turn_valid = hsh.fetch(:turn_valid)
    cond.enemy_valid = hsh.fetch(:enemy_valid)
    cond.actor_valid = hsh.fetch(:actor_valid)
    cond.switch_valid = hsh.fetch(:switch_valid)
    cond.turn_a = hsh.fetch(:turn_a)
    cond.turn_b = hsh.fetch(:turn_b)
    cond.enemy_index = hsh.fetch(:enemy_index)
    cond.enemy_hp = hsh.fetch(:enemy_hp)
    cond.actor_id = hsh.fetch(:actor_id)
    cond.actor_hp = hsh.fetch(:actor_hp)
    cond.switch_id = hsh.fetch(:switch_id)
    cond
  end

  def self.hash_to_troop_page(hsh)
    page = RPG::Troop::Page.new
    page.condition = hash_to_troop_page_condition(hsh.fetch(:condition))
    page.span = hsh.fetch(:span)
    page.list = hsh.fetch(:list).map { |evc| hash_to_event_command(evc) }
    page
  end

  def self.hash_to_troop(hsh)
    troop = RPG::Troop.new
    troop.id = hsh.fetch(:id)
    troop.name = hsh.fetch(:name)
    troop.members = hsh.fetch(:members).map { |mem| hash_to_troop_member(mem) }
    troop.pages = hsh.fetch(:pages).map { |page| hash_to_troop_page(page) }
    troop
  end
end
