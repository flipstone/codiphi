task default: :all
task all: [:engine, :web]

task :engine do
  sh "cd engine && rake"
end

task :web do
  sh "cd web && rake"
end

