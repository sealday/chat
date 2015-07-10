if Meteor.isClient
#  counter starts at 0
  Session.setDefault 'counter', 0

  Template.hello.helpers
    counter: ->
      return Session.get 'counter'

  Template.hello.events
    'click button': ->
#      increment the counter when button is clicked
      Session.set 'counter', 1 + Session.get 'counter'

if Meteor.isServer
  Meteor.startup ->
#    code to run on server at startup
