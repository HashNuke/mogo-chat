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


App.NewMessageView = Ember.View.extend
  templateName: "new-message"
  classNames:   ["new-message"]

  keyUp: (event)->
    if event.keyCode == 13  # enter key
      @get("controller").send("postMessage", event.target.value);
      event.target.value = ""
