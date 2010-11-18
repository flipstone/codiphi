unit :tactical_squad, {
  rank :troops
  nature :infantry
  has_special_rules :and_they_shall_know_no_fear, :combat_squads
  costs 75
  demands 1.model :veteran
  demands 4.models :space_marine
  permits 9.models :space_marine
  equipped_with "Wargear", {
    :bolt_pistol,
    :boltgun
  }
}

#
# Options
#

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
