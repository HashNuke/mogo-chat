App.RoomsNewRoute = App.AuthenticatedRoute.extend
  setupController: (controller)->
    controller.setProperties("roomName": null)
