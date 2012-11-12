#==============================================================================#
# ■ MkFeature
#==============================================================================#
# // • Created By      : IceDragon
# // • Modified By     : IceDragon
# // • Data Created    : 02/23/2012
# // • Data Modified   : 03/14/2012
# // • RGSS-Version(s) : 3
# // • Version         : 1.0
#==============================================================================#
# This is just a library, for features (RMVXAce)
# Basically its a shortcut for making features while scripting
# Lets say you need, a Attack Rate Feature and a Agility Rate Feature:
#   Normally you'd need to know the Feature Code, Data Id, etc..etc..
#   I've taken the problem into my own hands, and wrote this little thing
#   So instead of RPG::BaseItem::Feature.new(etc..etc..)
#   You could just:
#     MkFeature.atk_r(rate)
#     MkFeature.def_r(rate)
#==============================================================================#
# ● Change Log
#     ♣ 02/23/2012
#         Added stuff, I dont remember the exact order...
#     ♣ 03/14/2012
#         Cleaned up, added header, and tail
#==============================================================================#
# ● Functions/Methods
#   // Few Notes
#      *_r Means Rate (so if you want 100% thats 1.0, 50%, 0.5, and so on)
#==============================================================================#
#   // Base
#     feature(feature_id, data_id, value)
#     param_r(param_id, rate)
#     sparam_r(sparam_id, rate)
#     xparam_r(xparam_id, rate)
#     special(data_id, n)
#     party_ability(data_id)
#   // Actor
#     element_r(element_id, rate)
#     debuff_r(param_id, rate)
#     state_r(state_id, rate)
#     state_resist(state_id)
#   // Parameter
#     mhp_r(rate)
#     mmp_r(rate)
#     atk_r(rate)
#     def_r(rate)
#     mat_r(rate)
#     mdf_r(rate)
#     agi_r(rate)
#     luk_r(rate)
#   // Extended Paramater
#     hit_r(rate)
#     eva_r(rate)
#     cri_r(rate)
#     mag_eva_r(rate)
#     mag_reflect_r(rate)
#     cat_r(rate) - Counter Attack Rate
#     hp_regen_r(rate)
#     mp_regen_r(rate)
#     tp_regen_r(rate)
#   // Specical Parameter 
#     tgr(rate)   - Target Rate
#     grd_r(rate) - Guard Rate
#     rec_r(rate) - Recovery Rate
#     pha_r(rate) - Pharmacology Rate
#     mcr(rate)   - MP Cost Rate
#     tcr(rate)   - TP Charge Rate
#     pdr(rate)   - Phyiscal Damage Rate
#     mdr(rate)   - Magic Damage Rate
#     fdr(rate)   - Floor Damage Rate
#     exr(rate)   - EXP Gain Rate
#   // Attack
#     atk_element(element_id)
#     atk_state(state_id, probability_rate)
#     atk_speed(speed)
#     atk_times(n)
#   // Skill 
#     stype_add(stype_id)
#     stype_seal(stype_id)
#     skill_add(skill_id)
#     skill_seal(skill_id)
#   // Equipment
#     equip_wtype(wtype_id)
#     equip_atype(atype_id)
#     equip_fix(etype_id)
#     equip_seal(etype_id)
#     slot_type(slot_type_id)
#     action_plus(rate)
#   // Special
#     auto_battle()
#     guard()
#     substitute()
#     preserve_tp()
#     collapse_type(type)
#   // Party
#     encounter_halve()
#     encounter_none()
#     cancel_surprise()
#     raise_preemitive()
#     gold_double()
#     drop_item_double()
#
#==============================================================================#     
module Mixin ; end
module Mixin::FeatureConstants
  FEATURE_ELEMENT_RATE  = 11             
  FEATURE_DEBUFF_RATE   = 12             
  FEATURE_STATE_RATE    = 13             
  FEATURE_STATE_RESIST  = 14             
  FEATURE_PARAM         = 21             
  FEATURE_XPARAM        = 22             
  FEATURE_SPARAM        = 23             
  FEATURE_ATK_ELEMENT   = 31             
  FEATURE_ATK_STATE     = 32             
  FEATURE_ATK_SPEED     = 33             
  FEATURE_ATK_TIMES     = 34             
  FEATURE_STYPE_ADD     = 41             
  FEATURE_STYPE_SEAL    = 42             
  FEATURE_SKILL_ADD     = 43             
  FEATURE_SKILL_SEAL    = 44             
  FEATURE_EQUIP_WTYPE   = 51             
  FEATURE_EQUIP_ATYPE   = 52             
  FEATURE_EQUIP_FIX     = 53             
  FEATURE_EQUIP_SEAL    = 54             
  FEATURE_SLOT_TYPE     = 55             
  FEATURE_ACTION_PLUS   = 61             
  FEATURE_SPECIAL_FLAG  = 62             
  FEATURE_COLLAPSE_TYPE = 63             
  FEATURE_PARTY_ABILITY = 64             
  # // >_> Gotta move these later \/
  FLAG_ID_AUTO_BATTLE   = 0               
  FLAG_ID_GUARD         = 1               
  FLAG_ID_SUBSTITUTE    = 2               
  FLAG_ID_PRESERVE_TP   = 3               
end  
module Mixin::ParamConstants
  PARAM_MHP = 0
  PARAM_MMP = 1
  PARAM_ATK = 2
  PARAM_DEF = 3
  PARAM_MAT = 4
  PARAM_MDF = 5
  PARAM_AGI = 6
  PARAM_LUK = 7
end  
module Mixin::XParamConstants
  XPARAM_HIT_RATE      = 0
  XPARAM_EVA_RATE      = 1
  XPARAM_CRI_RATE      = 2
  XPARAM_CRI_EVA_RATE  = 3
  XPARAM_MAG_EVA_RATE  = 4
  XPARAM_MAG_REF_RATE  = 5
  XPARAM_CAT_RATE      = 6
  XPARAM_HP_REGEN_RATE = 7
  XPARAM_MP_REGEN_RATE = 8
  XPARAM_TP_REGEN_RATE = 9
end  
module Mixin::SParamConstants
  SPARAM_TARGET_RATE       = 0
  SPARAM_GUARD_RATE        = 1
  SPARAM_RECOVERY_RATE     = 2
  SPARAM_PHARMACOLOGY_RATE = 3
  SPARAM_MP_COST_RATE      = 4
  SPARAM_TP_CHARGE_RATE    = 5
  SPARAM_PHYSICAL_DAM_RATE = 6
  SPARAM_MAGICAL_DAM_RATE  = 7
  SPARAM_FLOOR_DAM_RATE    = 8
  SPARAM_EXP_GAIN_RATE     = 9
end
module Mixin::AbilityConstants
  ABILITY_ENCOUNTER_HALF    = 0          
  ABILITY_ENCOUNTER_NONE    = 1          
  ABILITY_CANCEL_SURPRISE   = 2          
  ABILITY_RAISE_PREEMPTIVE  = 3          
  ABILITY_GOLD_DOUBLE       = 4          
  ABILITY_DROP_ITEM_DOUBLE  = 5          
end  
module MkFeature
  include Mixin::FeatureConstants
  include Mixin::ParamConstants
  include Mixin::XParamConstants
  include Mixin::SParamConstants
  include Mixin::AbilityConstants
  module_function()
  def feature(feature_id,data_id,value=0)
    RPG::BaseItem::Feature.new(feature_id,data_id,value.to_f)
  end  
  # // And More @_@ - 02/24/2012
  def element_r(id,n)
    feature(FEATURE_ELEMENT_RATE,id,n)
  end
  # // 02/29/2012
  def debuff_r(id,n)
    feature(FEATURE_DEBUFF_RATE,id,n)
  end  
  def state_r(id,n)
    feature(FEATURE_STATE_RATE,id,n)
  end  
  def state_resist(id)
    feature(FEATURE_STATE_RESIST,id)
  end  
  # // 02/23/2012
  def param_r(i,n)
    feature(FEATURE_PARAM,i,n)
  end  
  def mhp_r(n)
    param_r(PARAM_MHP,n)
  end  
  def mmp_r(n)
    param_r(PARAM_MMP,n)
  end  
  def atk_r(n)
    param_r(PARAM_ATK,n)
  end  
  def def_r(n)
    param_r(PARAM_DEF,n)
  end  
  def mat_r(n)
    param_r(PARAM_MAT,n)
  end  
  def mdf_r(n)
    param_r(PARAM_MDF,n)
  end  
  def agi_r(n)
    param_r(PARAM_AGI,n)
  end  
  def luk_r(n)
    param_r(PARAM_LUK,n)
  end
  # // XPARAM
  def xparam_r(i,n)
    feature(FEATURE_XPARAM, i, n)
  end 
  def hit_r(n)
    xparam_r(XPARAM_HIT_RATE, n)
  end  
  def eva_r(n)
    xparam_r(XPARAM_EVA_RATE, n)
  end  
  def evasion_r(*args,&block);eva_r(*args,&block);end
  def critical_r(n)
    xparam_r(XPARAM_CRI_RATE, n)
  end
  def cri_r(*args,&block);critical_r(*args,&block);end
  def cri_eva_r(n)
    xparam_r(XPARAM_CRI_EVA_RATE, n)
  end
  def mag_eva_r(n)
    xparam_r(XPARAM_MAG_EVA_RATE, n)
  end
  def mag_reflect_r(n)
    xparam_r(XPARAM_MAG_REF_RATE, n)
  end
  def counter_attack_r(n)
    xparam_r(XPARAM_CAT_RATE, n)
  end
  def cat_r(*args,&block);counter_attack_r(*args,&block);end
  def hp_regen_r(n)
    xparam_r(XPARAM_HP_REGEN_RATE, n)
  end  
  def mp_regen_r(n)
    xparam_r(XPARAM_MP_REGEN_RATE, n)
  end  
  def tp_regen_r(n)
    xparam_r(XPARAM_TP_REGEN_RATE, n)
  end   
  # // Special Abilities
  def sparam_r(i,n)
    feature(FEATURE_SPARAM, i, n)
  end  
  def target_r(n)
    sparam_r(SPARAM_TARGET_RATE, n)
  end 
  def tgr(n);target_r(n);end
  def guard_r(n)
    sparam_r(SPARAM_GUARD_RATE, n)
  end 
  def grd_r(n);guard_r(n);end
  def recovery_r(n)
    sparam_r(SPARAM_RECOVERY_RATE, n)
  end 
  def rec_r(n);recovery_r(n);end
  def pharmacology_r(n)
    sparam_r(SPARAM_PHARMACOLOGY_RATE, n)
  end 
  def pha_r(n);pharmacology_r(n);end
  def mp_cost_r(n)
    sparam_r(SPARAM_MP_COST_RATE, n)
  end 
  def mcr(n);mp_cost_r(n);end
  def tp_charge_r(n)
    sparam_r(SPARAM_TP_CHARGE_RATE, n)
  end
  def tcr(n);tp_charge_r(n);end
  def phy_dam_r(n)
    sparam_r(SPARAM_PHYSICAL_DAM_RATE, n)
  end
  def pdr(n);phy_dam_r(n);end
  def mat_dam_r(n)
    sparam_r(SPARAM_MAGICAL_DAM_RATE, n)
  end
  def mdr(n);mat_dam_r(n);end
  def floor_dam_r(n)
    sparam_r(SPARAM_FLOOR_DAM_RATE, n)
  end
  def fdr(n);floor_dam_r(n);end
  def exp_gain_r(n)
    sparam_r(SPARAM_EXP_GAIN_RATE, n)
  end
  def exr(n);exp_gain_r(n);end
  # // 02/29/2012
  def atk_element(n)
    feature(FEATURE_ATK_ELEMENT, n)
  end
  def atk_state(id, n)
    feature(FEATURE_ATK_STATE, id, n)
  end
  def atk_speed(n)
    feature(FEATURE_ATK_SPEED, 0, n)
  end
  def atk_times(n)
    feature(FEATURE_ATK_TIMES, 0, n)    
  end 
  # // Some More -3- - 02/25/2012
  def stype_add(n)
    feature(FEATURE_STYPE_ADD, n)
  end 
  def skill_type_add(*args,&block);stype_add(*args,&block);end
  def stype_seal(n)
    feature(FEATURE_STYPE_SEAL, n)
  end  
  def skill_type_seal(*args,&block);stype_seal(*args,&block);end
  def skill_add(n)
    feature(FEATURE_SKILL_ADD, n)
  end  
  def skill_seal(n)
    feature(FEATURE_SKILL_SEAL, n)
  end
  # // More x.x 
  def equip_wtype(n)
    feature(FEATURE_EQUIP_WTYPE, n)
  end  
  def weapon_type(n);equip_wtype(n);end
  def equip_atype(n)  
    feature(FEATURE_EQUIP_ATYPE, n)
  end  
  def armor_type(n);equip_atype(n);end
  # // EVEN MOAR 030 - 02/29/2012
  def equip_fix(n)
    feature(FEATURE_EQUIP_FIX, n)
  end
  def equip_seal(n)
    feature(FEATURE_EQUIP_SEAL, n)
  end  
  def slot_type(n=0)
    feature(FEATURE_SLOT_TYPE, n, 0)
  end 
  def action_plus(n)
    feature(FEATURE_ACTION_PLUS, 0, n)
  end  
  # // Special
  def special(id,n=0)
    feature(FEATURE_SPECIAL_FLAG, id, n)
  end
  def auto_battle()
    special(FLAG_ID_AUTO_BATTLE, 0)
  end  
  def guard()
    special(FLAG_ID_GUARD, 0)
  end  
  def substitute()
    special(FLAG_ID_SUBSTITUTE, 0)
  end  
  def preserve_tp()
    special(FLAG_ID_PRESERVE_TP, 0)
  end   
  # // Collapse
  def collapse_type(n)
    feature(FEATURE_COLLAPSE_TYPE, n)
  end  
  # // Party
  def party_ability(n)
    feature(FEATURE_PARTY_ABILITY, n)
  end 
  def encounter_halve()
    party_ability(ABILITY_ENCOUNTER_HALF)
  end  
  def encounter_none()
    party_ability(ABILITY_ENCOUNTER_NONE)
  end  
  def cancelsurprise()
    party_ability(ABILITY_CANCEL_SURPRISE)
  end  
  def raise_preemitive()
    party_ability(ABILITY_RAISE_PREEMPTIVE)
  end  
  def gold_double()
    party_ability(ABILITY_GOLD_DOUBLE)
  end  
  def drop_item_double()
    party_ability(ABILITY_DROP_ITEM_DOUBLE)
  end   
end    
#=■==========================================================================■=#
#                           // ● End of File ● //                              #
#=■==========================================================================■=#