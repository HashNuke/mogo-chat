App.UsersIndexView = Ember.View.extend
  layoutName: "settings"
  classNames: ["settings"]

App.UsersNewView = Ember.View.extend
  layoutName: "settings"
  classNames: ["settings"]

App.UserEditView = Ember.View.extend
  layoutName: "settings"
  classNames: ["settings"]

App.RoomsIndexView = Ember.View.extend
  layoutName: "settings"
  classNames: ["settings"]

App.RoomsNewView = Ember.View.extend
  layoutName: "settings"
  classNames: ["settings"]

App.RoomEditView = Ember.View.extend
  layoutName: "settings"
  classNames: ["settings"]

App.RoomMessagesView = Ember.View.extend
  templateName: "room-messages"
  classNames: ["messages-wrapper"]

  latestMsgId: -1


  scrollIfRequired: ->
    messages = @get("controller.activeState.room.messages")
    return if messages.length == 0

    lastMsg = messages[messages.length - 1]
    @set("latestMsgId", lastMsg.id)

    viewableHeight   = @$().height()
    coveredHeight    = if @$().scrollTop() < 1 then 1 else @$().scrollTop()
    scrollableHeight = @$().find(".messages").height()

    bottomHiddenContentSize = scrollableHeight - (coveredHeight + viewableHeight)
    bottomHiddenContentSize = 0 if bottomHiddenContentSize < 0

    # Assume that 16px == 1em. And if the scrolled lines are less than 4, then don't scroll
    #TODO use 32 if devicePixelRatio is 2

    if (bottomHiddenContentSize / 16) < 4
      Ember.run.scheduleOnce "afterRender", @, =>
        # $(".messages-wrapper").scrollTop( $(".messages-wrapper").prop("scrollHeight") )
        @$().scrollTop(
          @$().find(".messages").prop("scrollHeight") + 100
        )


  onMessagesChange: (->
    @scrollIfRequired()
  ).observes("controller.activeState.room.messages.@each")

  onActiveStateChange: (->
    @scrollIfRequired()
  ).observes("controller.activeState")


App.NewMessageView = Ember.View.extend
  templateName: "new-message"
  classNames:   ["new-message"]

  keyUp: (event)->
    if event.keyCode == 13  # enter key
      @get("controller").send("postMessage", event.target.value);
      event.target.value = ""
