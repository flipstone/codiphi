  unit :interrogator_chaplain, {
  + rank :hq
  + nature :infantry
  + special_rules :independent_character, :honour_of_the_chapter, :litanies_of_hate
  costing 120
  expects 1.model [:interrogator_chaplain, :interrogator_chaplain_terminator, :interrogator_chaplain_jumppack]
  equipped_with "Wargear", {
    :bolt_pistol,
    :crozius_arcanum
  }
}

#
# Options
#

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
