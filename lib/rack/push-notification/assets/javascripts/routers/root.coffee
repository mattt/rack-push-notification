class RPN.Routers.Root extends Backbone.Router
  el:
    "div[role='container']"

  initialize: (options) ->
    @views = {}
    super

  routes:
    '':         'index'
    'compose':  'compose'
    'compose/': 'compose'

  index: ->
    @_activateNavbarLink("devices")

    RPN.devices.fetch()
    @views.devices ||= new RPN.Views.Devices(collection: RPN.devices)
    @views.devices.render()

  compose: ->
    @_activateNavbarLink("compose")

    @views.compose ||= new RPN.Views.Compose()
    @views.compose.render()

  _activateNavbarLink: (className) ->
    $li = $("header nav li")
    $li.removeClass("active")
    $li.filter("." + className).addClass("active")
