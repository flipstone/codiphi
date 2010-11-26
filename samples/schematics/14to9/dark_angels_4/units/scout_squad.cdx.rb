unit :scout_squad, {
  rank :elites
  nature :infantry
  special_rule {
    :and_they_shall_know_no_fear
    :combat_squads
    :infiltrate
    :move_through_cover
  }
  cost 80

  expects 1 :scout_sergeant
  expects 4 :scout
  permits 9 :scout

  weapon {
    :bolt_pistol
    :boltgun
    :chainsword
    :combat_blade
    :shotgun
  }
}

#
# Options
#

unit_option :scout_squad, "Additional scouts", {
  model_addition 5 :scout {
    cost 65
  }
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
unit_option :scout_squad, "Sergeant bolter upgrade", :scout_sergeant, {
  weapon_replacement [
    [ :boltgun, :power_weapon, 15 ],
    [ :boltgun, :power_fist, 25 ]
  ]
}
unit_option :scout_squad, "Sergeant meltabombs", :scout_sergeant, {
  weapon_addition :meltabombs, 5 
}
unit_option :scout_squad, "Dedicated Transport" { 
  unit_addition :drop_pod
}