//= require "lib/moment.min"
//= require "lib/jquery-2.0.3"
//= require "lib/handlebars-v1.1.2"
//= require "lib/ember"
//= require "lib/ember-data"
//= require "lib/fastclick"
//= require "mogo_chat"
//= require_self
//= require "serializers"
//= require "models"
//= require "views"
//= require "helpers"
//= require_tree "./controllers"
//= require "./routes/authenticated_route"
//= require_tree "./routes"
//= require_tree "./pollers"


String.prototype.rtrim = function() {
  return this.replace(/\s*$/g, "")
}


window.App = Em.Application.create({LOG_TRANSITIONS: true});
App.ApplicationSerializer = DS.ActiveModelSerializer.extend({});
App.ApplicationAdapter    = DS.ActiveModelAdapter.reopen({namespace: "api"});
App.ApplicationView       = Em.View.extend({classNames: ["container"]});
App.paintBox = new MogoChat.PaintBox();



//NOTE from http://stackoverflow.com/a/1060034/477045
(function() {
    var hidden = "hidden";

    // Standards:
    if (hidden in document)
        document.addEventListener("visibilitychange", onVisibilityChange);
    else if ((hidden = "mozHidden") in document)
        document.addEventListener("mozvisibilitychange", onVisibilityChange);
    else if ((hidden = "webkitHidden") in document)
        document.addEventListener("webkitvisibilitychange", onVisibilityChange);
    else if ((hidden = "msHidden") in document)
        document.addEventListener("msvisibilitychange", onVisibilityChange);
    // IE 9 and lower:
    else if ('onfocusin' in document)
        document.onfocusin = document.onfocusout = onVisibilityChange;
    // All others:
    else
        window.onpageshow = window.onpagehide 
            = window.onfocus = window.onblur = onVisibilityChange;

    function onVisibilityChange (evt) {
      var v = 'visible', h = 'hidden';
      var evtMap = {
        focus:v, focusin:v, pageshow:v, blur:h, focusout:h, pagehide:h
      };

      evt = evt || window.event;
      if(evt.type == "focusout" || evt.type == "blur" || evt.type == "pagehige" || this[hidden]) {
        App.isPageActive = false;
      }
      else {
        App.isPageActive = true;
        document.title = "Mogo Chat";
      }
    }
})();


App.notifyBySound = function() {
  if(App.isPageActive)
    return

  document.title = "[+] " + document.title
  $audio = $("#app-audio")[0];
  $audio.load();
  $audio.play();
}

App.Router.map(function() {
  // login
  this.route("login");

  // logout
  this.route("logout");

  // rooms
  this.resource("rooms", function() {
    this.route("new");
    this.resource("room", {path: "/:room_id"}, function() {
      this.route("edit");
    });
  });


  // users
  // users/new
  // users/:user_id
  this.resource("users", function() {
    this.route("new");
    this.resource("user", {path: "/:user_id"}, function() {
      this.route("edit");
    });

  });

});
