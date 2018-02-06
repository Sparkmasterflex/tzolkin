Tzolkin  = require './app'

configs =
  type: 'time'
  input: document.querySelector('.select-datetime')
  trigger: document.querySelector('.select-date-calendar')
  step: 15

  onOpen: (date) ->
    console.log 'open!'

  onSelect: ->
    console.log 'selected'

  onClose: ->
    console.log 'close!'

Tzolkin.create configs

