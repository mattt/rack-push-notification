class RPN.Views.Devices extends Backbone.View
  template: JST['templates/devices']
  partial: JST['templates/_devices']
  el: "[role='main']"

  events:
    'keyup form.filter input': 'filter'

  initialize: ->
    @collection.on 'reset', =>
      @$el.find("table").html(@partial(devices: @collection))

  render: ->
    @$el.html(@template(devices: @collection))

    @paginationView = new RPN.Views.Pagination(collection: @collection)
    @paginationView.render()
    @

  filter: (e) ->
    e.preventDefault()
    @collection.query = $(e.target).val()
    @collection.fetch()