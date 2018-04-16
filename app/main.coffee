# import MyComponent from './dev'
# MyComponent.create(document.getElementById('react'))

{ TzolkinPlugin } = require './app'

configs =
  type: 'datetime'
  input: document.querySelector('.select-datetime')
  trigger: document.querySelector('.select-date-calendar')
  step: 15

  onOpen: (date) ->
    setTimeout ->
      TzolkinPlugin.close()
    , 3000

  onSelect: ->
    console.log 'selected'

  onClose: ->
    console.log 'close!'

TzolkinPlugin.create configs


