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
list { 
  expects 1 :hq
  expects 2 :troops

  permits 2 :hq
  permits 6 :troops
  permits 3 :heavy_support
  permits 3 :fast_attack
  permits 3 :elites
}
