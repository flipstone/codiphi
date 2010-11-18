#
# dark_angels.v4.cdx
# 7 Nov 2010 
# Scott Conley
#
# This file is an example of a Codexor/Codiphile schematic
# It implements my copy of the Dark Angels codex (4th ed)
#
# All references to Games Workshop trademarks are without permission,
# and remain the property of Games Workshop.  This software is for 
# personal and private use and may not be sold.
#
# License to use this software is granted under MIT license.
#

#
# core domain definitions:
# these are the 'flat' ones (no conditionals)
#

include Codiphile

require 'weapons.cdx.rb'
require 'models.cdx.rb'

# cost system
cost :points

# ranks
rank :hq
rank :troops
rank :elites
rank :heavy_support
rank :fast_attack

nature :infantry
nature :jump_infantry
nature :tank
nature :open_topped
nature :bike


# special rules
special_rule :and_they_shall_know_know_fear, {
  text: "bleah bleah",
  reference: "Codex: Dark Angels",
  page: 77
}
special_rule :orbital_bombardment
special_rule :combat_squads
special_rule :combat_tactics
special_rule :independent_character
special_rule :fearless
special_rule :infiltrate
special_rule :move_through_cover
special_rule :scout
special_rule :deep_strike



# weapons
weapon :meltagun {
  range: 12,
  strength: 8,
  ap: 1
  type: "assault 1, melta"
}
weapon :assault_cannon
weapon :autocannon
weapon :bolt_pistol
weapon :boltgun
weapon :flamer
weapon :heavy_bolter
weapon :heavy_flamer
weapon :lascannon
weapon :missile_launcher
weapon :multimelta
weapon :plasma_cannon
weapon :plasma_gun
weapon :plasma_pistol
weapon :shotgun
weapon :sniper_rifle
weapon :storm_bolter
weapon :typhoon_missile
weapon :demolisher
weapon :whirlwind
weapon :power_fist
weapon :chainsword
weapon :meltabombs
weapon :crozius_arcanum

# force organization
list :force_organization { 
  demands 1.unit.ranked :hq
  demands 2.units.ranked :troops

  permits 2.units.ranked :hq
  permits 6.units.ranked :troops
  permits 3.units.ranked :heavy_support
  permits 3.units.ranked :fast_attack
  permits 3.units.ranked :elites
}

# units
unit :tactical_squad, {
  ranked_as :troops
  with_nature :infantry
  having_special_rules :and_they_shall_know_no_fear, :combat_squads
  costing 75
  demands 1.model :veteran
  demands 4.models :space_marine
  permits 9.models :space_marine
  equipped_with "Wargear", {
    :bolt_pistol,
    :boltgun
  }
}
unit_option :tactical_squad, "Dedicated Transport" { 
  unit_addition [:rhino, :drop_pod, :razorback]
}
unit_option :tactical_squad, "Additional marines", {
  model_addition 5.models :space_marines, 75
}
unit_option :tactical_squad, "Veteran pistol upgrade", :veteran, {
  weapon_replacement :bolt_pistol, :plasma_pistol, 15
}
unit_option :tactical_squad, "Veteran bolter upgrade", :veteran, {
  weapon_replacement [
    [ :boltgun, :chainsword, 0 ],
    [ :boltgun, :power_weapon, 15 ],
    [ :boltgun, :power_fist, 25 ]
  ]
}
unit_option :tactical_squad, "Veteran meltabombs", :veteran, {
  weapon_addition :meltabombs, 5 
}
unit_option :tactical_squad, "Squad assault weapon", :space_marine, {
  unique
  weapon_replacement [
    [ :boltgun, :flamer, 5],
    [ :boltgun, :meltagun, 10],
    [ :boltgun, :plasma_gun, 15]
  ]
}
unit_option :tactical_squad, "Squad heavy weapon", :space_marine, {
  unique
  weapon_replacement [
    [ :boltgun, :heavy_bolter, 10],
    [ :boltgun, :multi_melta, 10],
    [ :boltgun, :missile_launcher, 10],
    [ :boltgun, :plasma_cannon, 15],
    [ :boltgun, :lascannon, 20],
  ] if model_count == 10
}

unit :scout_squad, {
  ranked_as :elites
  with_nature :infantry
  having_special_rules :and_they_shall_know_no_fear, :combat_squads, :infiltrate, :move_through_cover
  costing 80
  demands 1.model :scout_sergeant
  demands 4.models :scout
  permits 9.models :scout
  equipped_with "Wargear", {
    :bolt_pistol,
    [ :boltgun, :chainsword, :combat_blade, :shotgun ]
  }
  
}
unit_option :scout_squad, "Additional scouts", {
  model_addition 5.models :scout, 65
}
unit_option :scout_squad, "Sniper rifles", :scout, {
  weapon_replacement :boltgun, :sniper_rifle, 5
}
unit_option :scout_squad, "Squad heavy weapon", :scout, {
  unique
  weapon_replacement [
    [ :boltgun, :heavy_bolter, 15 ],
    [ :boltgun, :missile_launcher, 20 ],
  ]
}
unit_option :scout_squad, "Sergeant pistol upgrade", :scout_sergeant, {
  weapon_replacement :bolt_pistol, :plasma_pistol, 15
}
unit_option :tactical_squad, "Sergeant bolter upgrade", :scout_sergeant, {
  weapon_replacement [
    [ :boltgun, :power_weapon, 15 ],
    [ :boltgun, :power_fist, 25 ]
  ]
}
unit_option :tactical_squad, "Sergeant meltabombs", :scout_sergeant, {
  weapon_addition :meltabombs, 5 
}
unit_option :tactical_squad, "Dedicated Transport" { 
  unit_addition :drop_pod
}

unit :interrogator_chaplain, {
  ranked_as :hq
  with_nature :infantry
  having_special_rules :independent_character, :honour_of_the_chapter, :litanies_of_hate
  costing 120
  demands 1.model [:interrogator_chaplain, :interrogator_chaplain_terminator, :interrogator_chaplain_jumppack]
  equipped_with "Wargear", {
    :bolt_pistol,
    :crozius_arcanum
  }
}

unit_option :interrogator_chaplain, "Chaplain upgrade", {
  model_replacement [
    [ :interrogator_chaplain, :interrogator_chaplain_jumppack, 20],
    [ :interrogator_chaplain, :interrogator_chaplain_bike, 30],
    [ :interrogator_chaplain, :interrogator_chaplain_terminator, 25],
  ]
}
unit_requirement :interrogator_chaplain, "Terminator wargear", :interrogator_chaplain_terminator {
  weapon_replacement :everything, [ :storm_bolter, :crozius_arcanum, :rosarius ], 0
}
unit_option :interrogator_chaplain, "Terminator chaplain pistol upgrade", :interrogator_chaplain_terminator {
  weapon_replacement [
    [ :storm_bolter, :combi_flamer, 5 ],
    [ :storm_bolter, :combi_melta, 5 ],
    [ :storm_bolter, :combi_plasma, 5 ]
  ]
}
unit_option :interrogator_chaplain, "Command Squad" { 
  unit_addition :command_squad
}
