Tzolkin  = require './app'

configs =
  type: 'time'
  input: document.querySelector('.select-datetime')
  trigger: document.querySelector('.select-date-calendar')

  onOpen: (date) ->
    console.log 'open!'

  onSelect: ->
    console.log 'selected'

  onClose: ->
    console.log 'close!'

Tzolkin.create configs

