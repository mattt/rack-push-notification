#= require ./vendor/date
#= require ./vendor/jquery
#= require ./vendor/underscore
#= require ./vendor/backbone
#= require ./vendor/backbone.paginator
#= require ./vendor/codemirror
#= require ./vendor/codemirror.javascript

#= require ./rpn
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./templates
#= require_tree ./views
#= require_tree ./routers

$ ->
  $('a').live 'click', (event) ->
    href = $(this).attr('href')
    event.preventDefault()
    window.app.navigate(href, {trigger: true})

  $('.iphone .slider input').live 'change', (event) ->
    $(this).siblings("span").css(opacity: (100 - $(this).val()) / 100.0)
  $('.alert button.close').live 'click', (event) ->
    $(this).parents(".alert").remove()

  RPN.devices = new RPN.Collections.Devices
  RPN.devices.fetch(success: RPN.initialize)