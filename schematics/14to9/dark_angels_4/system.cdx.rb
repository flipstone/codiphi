# cost system
cost_unit :points

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
