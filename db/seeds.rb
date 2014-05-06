# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

teacher = Teacher.new(
  email: "slate@makersacademy.com",
  password: '12345678'
)
teacher.save!

["Ruby",
  "Command Line",
  "JavaScript",
  "Git",
  "Heroku",
  "CSS",
  "HTML",
  "Rails",
  "Postgresql",
  "Rspec"].each{|category|
  Category.create(name: category)
}

[ 
  ["January", "2014"],
  ["February", "2014"],
  ["March", "2014"],
  ["May", "2014"]

   ].each{|cohort|
  Cohort.create(month: cohort[0], year: cohort[1])
}