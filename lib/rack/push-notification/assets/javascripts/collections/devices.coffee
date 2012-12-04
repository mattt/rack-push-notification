class RPN.Collections.Devices extends Backbone.Paginator.requestPager
  model: RPN.Models.Device

  paginator_core:
    type: 'GET'
    dataType: 'json'
    url: '/devices?'

  paginator_ui:
    firstPage: 1,
    currentPage: 1,
    perPage: 20

  server_api:
    'q': -> 
      @query || ""
    'limit': ->
      @perPage
    'offset': ->
      (@currentPage - 1) * @perPage

  parse: (response) ->
    @total = response.total
    @totalPages = Math.ceil(@total / @perPage)
    response.devices

  comparator: (database) ->
    database.get('token')
