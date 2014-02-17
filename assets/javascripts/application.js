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


var hidden, visibilityChange;
if (typeof document.hidden !== "undefined") { // Opera 12.10 and Firefox 18 and later support
  hidden = "hidden";
  visibilityChange = "visibilitychange";
} else if (typeof document.mozHidden !== "undefined") {
  hidden = "mozHidden";
  visibilityChange = "mozvisibilitychange";
} else if (typeof document.msHidden !== "undefined") {
  hidden = "msHidden";
  visibilityChange = "msvisibilitychange";
} else if (typeof document.webkitHidden !== "undefined") {
  hidden = "webkitHidden";
  visibilityChange = "webkitvisibilitychange";
}

function handleVisibilityChange() {
  if (document[hidden])
    App.isPageActive = false;
  else
  {
    App.isPageActive = true;
    document.title = "Mogo Chat";
  }
}

if (typeof document.addEventListener === "undefined" || typeof hidden === "undefined")
  App.isPageActive = false;
else
  document.addEventListener(visibilityChange, handleVisibilityChange, false);


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
