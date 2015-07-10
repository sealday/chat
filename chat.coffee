Chats = new Mongo.Collection "chats"

if Meteor.isClient
#  counter starts at 0
#  Session.setDefault 'counter', 0
#
#  Template.hello.helpers
#    counter: ->
#      return Session.get 'counter'
#
#  Template.hello.events
#    'click button': ->
##      increment the counter when button is clicked
#      Session.set 'counter', 1 + Session.get 'counter'
  Template.body.helpers
    chats: ->
      return Chats.find({})

if Meteor.isServer
  Meteor.startup ->
#    code to run on server at startup
