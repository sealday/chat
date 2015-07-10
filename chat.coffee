Chats = new Mongo.Collection "chats"

if Meteor.isClient
  Template.body.helpers
    chats: ->
      return Chats.find({})

  Template.body.events
    'submit .chat': (e) ->
      e.preventDefault()
      text = e.target.text.value
      Chats.insert
        text: text
      e.target.text.value = ''

if Meteor.isServer
  Meteor.startup ->
#    code to run on server at startup
