# import MyComponent from './dev'
# MyComponent.create(document.getElementById('react'))

{ TzolkinPlugin } = require './app'

tz = null

document.querySelectorAll('.select-datetime').forEach (input) ->
  t = input.nextElementSibling
  trigger = t if /select-date-calendar/.test(t.className)

  configs =
    type: 'datetime'
    input: input
    trigger: trigger
    step: 15

    onOpen: (date) -> console.log "don't close that..."

    onSelect: ->
      console.log 'selected'

    onClose: ->
      console.log 'close!'

  tz = new TzolkinPlugin().create(configs)

document.addEventListener "DOMContentLoaded", ->
  document.querySelector('a.toggle-type').addEventListener 'click', (e) ->
    e.preventDefault()
    input = document.querySelector('.select-datetime')
    if /no-time/.test input.class
      klass = 'select-datetime'
      val = "12/18/2017 04:51 pm"
      format = "MM/DD/YYYY h:mm a"
      type = 'datetime'
    else
      klass = 'select-datetime no-time'
      val = "12/18/2017"
      format = "MM/DD/YYYY"
      type = 'date'

    input.class = klass
    input.value = val
    tz.update
      type: type
      default: val
      format: format
