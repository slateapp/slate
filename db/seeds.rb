# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

teacher1 = Teacher.new(
  email: 'slate@makersacademy.com',
  password: '12345678',
  confirmed_at: Time.now
)
teacher1.save!

teacher2 = Teacher.new(
  email: 'khush@makersacademy.com',
  password: '12345678',
  confirmed_at: Time.now
)
teacher2.save!

teacher3 = Teacher.new(
  email: 'ross@makersacademy.com',
  password: '12345678',
  confirmed_at: Time.now
)
teacher3.save!

[
  'Ruby',
  'Command Line',
  'JavaScript',
  'Git',
  'Heroku',
  'CSS',
  'HTML',
  'Rails',
  'Postgresql',
  'Rspec'
].each do |category|
  Category.create(name: category)
end

[
  %w[January 2014],
  %w[February 2014],
  %w[March 2014],
  %w[May 2014]

].each do |cohort|
  Cohort.create(month: cohort[0], year: cohort[1])
end

if Rails.env == 'development'
  # description, student_id, solved, category_id, teacher_id, solved_at, created_at
  [
    ['Argh!', 1, true, 1, 1, Time.now - 100.minutes, Time.now - 110.minutes],
    ['OMGOMGOMG!', 1, true, 3, 2, Time.now - 90.minutes, Time.now - 92.minutes],
    ["This ruby code isn't working!", 1, true, 1, 1, Time.now - 85.minutes, Time.now - 93.minutes],
    ['Omg, I cannot get my head around this one!', 1, true, 1, 3, Time.now - 75.minutes, Time.now - 83.minutes],
    ['HELPPPPPPP!', 1, true, 2, 1, Time.now - 65.minutes,    Time.now - 69.minutes],
    ['I HATE CSS!', 1, true, 1, 2, Time.now - 60.minutes,    Time.now - 62.minutes],
    ['WHY DOES HEROKU RUIN EVERYTHING?!', 1, true, 5, 1, Time.now - 45.minutes, Time.now - 50.minutes],
    ['JavaScript cannot be fun!!', 1, true, 1, 1, Time.now - 30.minutes, Time.now - 33.minutes],
    ['One more for good luck!', 1, true, 7, 2, Time.now - 15.minutes, Time.now - 20.minutes]
  ].each do |request|
    Request.create(
      description: request[0], student_id: request[1], solved: request[2], category_id: request[3], teacher_id: request[4], solved_at: request[5], created_at: request[6]
    )
  end

  # [["Argh!",1,true,1,1,Time.now-100.minutes,Time.now-110.minutes],["OMGOMGOMG!",1,true,3,2,Time.now-90.minutes,Time.now-92.minutes],["Thisrubycodeisn'tworking!",1,true,1,1,Time.now-85.minutes,Time.now-93.minutes],["Omg,Icannotgetmyheadaroundthisone!",1,true,1,3,Time.now-75.minutes,Time.now-83.minutes],["HELPPPPPPP!",1,true,2,1,Time.now-65.minutes,Time.now-69.minutes],["IHATECSS!",1,true,1,2,Time.now-60.minutes,Time.now-62.minutes],["WHYDOESHEROKURUINEVERYTHING?!",1,true,5,1,Time.now-45.minutes,Time.now-50.minutes],["JavaScriptcannotbefun!!",1,true,1,1,Time.now-30.minutes,Time.now-33.minutes],["Onemoreforgoodluck!",1,true,7,2,Time.now-15.minutes,Time.now-20.minutes]].each{|request|Request.create(description:request[0],student_id:request[1],solved:request[2],category_id:request[3],teacher_id:request[4],solved_at:request[5],created_at:request[6])}

end
