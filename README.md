Slate (SL8) [![Code Climate](https://codeclimate.com/github/slateapp/slate.png)](https://codeclimate.com/github/slateapp/slate)
---
![](screenshot.png?raw=true)
This project was built as our final project at [Makers
Academy](http://www.makersacademy.com). Slate is a web
application allows students to get assistance from
educators and in turn assists teachers by helping them
to understand problem areas.

# The Team
* [Ross Hepburn](https://github.com/RossHepburn)
* [Sarah C Young](https://github.com/sarahseewhy)
* [Alex Gaudiosi](https://github.com/alexgaudiosi)
* [Matthew Thomas](https://github.com/Lycanstrife)
* [Charles De Barros](https://github.com/Charliebr73)
* [Khushkaran Singh Bajwa](https://github.com/khushkaran)

# The History
SL8 began as a desire to write a labor-saving program that could improve the existing method students used to ask for help and provide teachers with data-driven feedback. We started our project as a blank slate, or SL8. 

Before SL8 students would write their name and occasionally a specific question on a whiteboard to notify teachers if they were stuck on a problem. The whiteboard functioned as a waiting list for each cohort of students; as each problem was solved a teacher would erase a name and corresponding problem from the board and move on to the next student. 

We felt this system could be improved by creating an interactive, responsive application that would display the key information (name, cohort, and question), save a record of who posed the question, the question type, how quickly the question was answered and who answered it, as well as creating an SMS alert system to notify teachers of new requests.

# The Project
SL8 functions as an efficient and interactive replacement of the 'Help Board' . 

Students are able to sign in through their GitHub accounts which are activiated on their first day at Makers Academy. We created an approval system whereby a student must be approved by a teacher before they can continue to the SL8 dashboard. Once approved, students can create a request, highlighting a question or snippet of code with which they are struggling. They must also choose a category for the request which is then recorded on the database. Only the student who created the request can edit or delete it. Using Websockets, once a request is posted it is immediately displayed on a waiting list. The waiting list can be viewed on various iOS devices as well as a TV or monitor which we connected to a Raspberry Pi.

The system provides teachers with information about how each student and cohort is responding to the material 

# The Technologies
* Ruby
* Rails
* PostgreSQL
* HTML5
* CSS3
* Bootstrap
* JavaScript
* CoffeeScript
* jQuery
* Twilio
* Raspberry Pi
* jbuilder
* Mustache.js
* Websockets
* Devise
* Omniauth (GitHub)
* Thin
* Chartkick
* Groupdate
* Google Prettify

### Deployment
* Heroku
* Heroku Secrets

### Testing
* RSpec
* Capybara
* Factory Girl


# The Instructions
To run the application run `bin/rails s` and visit
`localhost:3000` in the browser.

### secrets.yml
Before running, for obvious reasons the repo doesn't include
`config/secrets.yml`, however, below you can see the items required
in your secrets file to enable the functionality of Slate.
```
  secret_key_base: ***
  GITHUB_KEY: ***
  GITHUB_SECRET: ***
  twilio_sid: ***
  twilio_token: ***
  twilio_phone_number: ***
```
