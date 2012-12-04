class RPN.Views.Pagination extends Backbone.View
  template: JST['templates/pagination']
  el: ".pagination"

  events:
    'click a.previous': 'gotoPrevious'
    'click a.next': 'gotoNext'
    'click a.page': 'gotoPage'

  initialize: ->
    @collection.on 'reset', =>
      @render()

  render: ->
    @$el.html(@template(devices: @collection))
    @

  gotoPrevious: (e) ->
    e.preventDefault()
    @collection.requestPreviousPage() unless $(e.target).parent().hasClass("disabled")

  gotoNext: (e) ->
    e.preventDefault()
    @collection.requestNextPage() unless $(e.target).parent().hasClass("disabled")

  gotoPage: (e) ->
    e.preventDefault()
    page = $(e.target).text()
    @collection.goTo(page)
