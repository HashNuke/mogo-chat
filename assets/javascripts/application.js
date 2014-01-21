//= require "lib/moment.min"
//= require "lib/jquery-2.0.3"
//= require "lib/handlebars-v1.1.2"
//= require "lib/ember"
//= require "lib/ember-data"
//= require_self
//= require "models"
//= require "views"
//= require "helpers"
//= require "./routes/authenticated_route"
//= require_tree "./controllers"
//= require_tree "./routes"


window.App = Em.Application.create({LOG_TRANSITIONS: true})

App.ApplicationSerializer = DS.ActiveModelSerializer.extend({})
App.ApplicationAdapter    = DS.RESTAdapter.reopen({namespace: "api"})
App.ApplicationView       = Em.View.extend({classNames: ["container"]})


App.Router.map(function() {
  // login
  this.route("login");

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
