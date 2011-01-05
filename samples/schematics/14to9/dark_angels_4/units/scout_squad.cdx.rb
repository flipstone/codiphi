model :scout {
  ? weapon :sniper_rifle {
    permits 0 weapon :boltgun
    + cost 5
  }

  ? weapon :missile_launcher {
    permits 0 weapon :boltgun
    + cost 15
    permits 0 weapon :heavy_bolter on unit :scout_squad
  }

  if weapon :heavy_bolter {
    permits 0 weapon :boltgun
    + cost 15
  }
}

model :scout_sergeant {
  if weapon :plasma_pistol {
    - weapon :bolt_pistol
    + cost 15
  }
  
  if weapon :power_weapon {
    - weapon :boltgun
    - weapon :power_fist
    + cost 15
  }

  if weapon :power_fist {
    - weapon :boltgun
    - weapon :power_weapon
    + cost 25
  }

  if weapon :meltabombs {
    + cost 5
  }

}

unit :scout_squad {
  + rank :elites
  + nature :infantry
  + special_rule [
    :and_they_shall_know_no_fear
    :combat_squads
    :infiltrate
    :move_through_cover
  ]
  + cost 80

  expects 1 model :scout_sergeant
  expects 4 model :scout
  permits 1 weapon :heavy_bolter
  permits 1 weapon :missile_launcher
  permits 1 unit :drop_pod
  
  + weapon [
    :bolt_pistol
    :boltgun
    :chainsword
    :combat_blade
    :shotgun
  ]
  
   ? count(model :scout) > 4 {
    + cost 65
    expects 9 model :scout
  } 
}
