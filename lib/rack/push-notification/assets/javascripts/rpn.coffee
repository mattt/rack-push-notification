window.RPN =
  Collections: {}
  Models: {}
  Routers: {}
  Views: {}

  initialize: ->
    @devices = new RPN.Collections.Devices
    @devicesView = new RPN.Views.Devices({collection: @devices})

    window.app = new RPN.Routers.Root

    Backbone.history.start({pushState: true, hashChange: false})

