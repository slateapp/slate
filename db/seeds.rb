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
  "Postgresql"].each{|category|
  Category.create(name: category)
}

["January 2014",
  "February 2014",
  "March 2014",
  "April 2014",
  "May 2014",
  "June 2013",
  "July 2013",
  "August 2013",
  "September 2013"].each{|cohort|
  Cohort.create(name: cohort)
}