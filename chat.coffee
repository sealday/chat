Chats = new Mongo.Collection "chats"
Notices = new Mongo.Collection "notices"

if Meteor.isClient

  Template.body.helpers
    chats: ->
      return Chats.find({})
    notices: ->
      if Meteor.user()
        Notices.find({sendTo: Meteor.user().username, isRead: false})
      else
        []

  Template.body.events
    'click .notice .close': (e) ->
      console.log 'close'
      _id = e.target.dataset['id']
      Notices.update
        _id: _id,
          $set:
            isRead: true

    'submit .chat': (e) ->
      e.preventDefault()

      text = e.target.text.value

      # empty string
      if text == ''
        return ''


      _id = Chats.insert
        text: text
        createdAt: new Date()
        owner: Meteor.userId()
        username: Meteor.user().username

      persons = text.match(/@\w+\s/gm)
      if persons
        persons.forEach (p) ->
          sendTo = p.trim().slice(1)
          Notices.insert
            chat: _id
            text: text
            owner: Meteor.userId()
            username: Meteor.user().username
            sendTo: sendTo
            isRead: false
            isNotified: false

      e.target.text.value = ''

  Accounts.ui.config
    passwordSignupFields: 'USERNAME_ONLY'

if Meteor.isServer
  Meteor.startup ->
#    code to run on server at startup

if Meteor.isClient
  scrollToBottom = (e) ->
    e.scrollTop = e.scrollHeight - e.clientHeight

  #  init scroll
  Meteor.startup ->
    # 请求通知的权限
    Notification.requestPermission()

    chatArea = document.getElementsByClassName('chat-area')[0]
    scrollToBottom chatArea
    window.Chats = Chats

    Chats.find({}).observe
      added: ->
        chatArea = document.getElementsByClassName('chat-area')[0]
        scrollToBottom chatArea


    Notices.find({sendTo: Meteor.user().username, isRead: false}).observe
      added: ->
        if !Meteor.user()
          return ''
        Notices.find({sendTo: Meteor.user().username, isRead: false, isNotified: false}).forEach (notice)->
          new Notification notice.text
          Notices.update {_id: notice._id}, {$set: {isNotified: true}}




