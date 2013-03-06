class RPN.Views.Compose extends Backbone.View
  template: JST['templates/compose']
  partial: JST['templates/_preview']
  el: "[role='main']"

  events:
    'submit form': 'submit'
    'click button#send': 'submit' 
    'keyup textarea': 'updatePreview'
    'focus textarea': ->
      @$el.find("input[type=radio][value=selected]").prop('checked',true)

  initialize: ->
    window.setInterval(@updateTime, 10000)

  render: ->
    @$el.html(@template())

    @editor = CodeMirror.fromTextArea(document.getElementById("payload"), {
      mode: "application/json",
      theme: "solarized-dark",
      tabMode: "indent",
      lineNumbers : true,
      matchBrackets: true
    })

    @updatePreview()
    @updateTime()

    $.ajax("/message"
      type: "HEAD"

      error: (data, status) =>
        @disable()
    )
    @

  submit: ->
    console.log("submit!")
    $form = @$el.find("form#compose")
    payload = @editor.getValue()

    tokens = undefined
    if $("input[name='recipients']:checked").val() == "specified"
      tokens = [$form.find("#tokens").val()]

    $.ajax("/message"
      type: "POST"
      dataType: "json"
      data: {
        tokens: tokens,
        payload: payload
      }
    )
      
      beforeSend: =>
        @$el.find(".alert-error, .alert-success").remove()

      success: (data, status) =>
        alert = """
          <div class="alert alert-block alert-success">
            <button type="button" class="close" data-dismiss="alert">×</button>
            <h4>Push Notification Succeeded</h4>
          </div>
        """
        @$el.prepend(alert)

      error: (data, status) =>
        alert = """
          <div class="alert alert-block alert-error">
            <button type="button" class="close" data-dismiss="alert">×</button>
            <h4>Push Notification Failed</h4>
            <p>#{$.parseJSON(data.responseText).error}</p>
          </div>
        """
        @$el.prepend(alert)


  disable: ->
    alert = """
      <div class="alert alert-block">
        <button type="button" class="close" data-dismiss="alert">×</button>
        <h4>Push Notification Sending Unavailable</h4>
        <p>Check that Rack::PushNotification initializes with a <tt>:certificate</tt> parameter, and that the certificate exists and is readable in the location specified.</p>
      </div>
    """

    @$el.prepend(alert)

    $(".iphone").css(opacity: 0.5)

    $form = @$el.find("form#compose")
    $form.css(opacity: 0.5)
    $form.find("input").disable()

  updatePreview: ->
    @$el.find(".preview").html(@partial())

    try
      json = $.parseJSON(@editor.getValue())
      if alert = json.aps.alert
        $(".preview p").text(alert)
    
    catch error
      $(".alert strong").text(error.name)
      $(".alert span").text(error.message)
    finally
      if alert? and alert.length > 0
        $(".notification").show()
        $(".alert").hide()
      else
        $(".notification").hide()
        $(".alert").show()

  updateTime: ->
    $time = $("time")
    $time.attr("datetime", Date.now().toISOString())
    $time.find(".time").text(Date.now().toString("HH:mm"))
    $time.find(".date").text(Date.now().toString("dddd, MMMM d"))

