App.UsersNewRoute = App.AuthenticatedRoute.extend
  setupController: (controller)->
    controller.setProperties
      "firstName": null
      "lastName": null
      "email": null
      "password": null
      "role": null
