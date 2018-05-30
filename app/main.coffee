import MyComponent from './dev'
MyComponent.create(document.getElementById('react'))

# { TzolkinPlugin } = require './app'

# document.querySelectorAll('.select-datetime').forEach (input) ->
#   t = input.nextElementSibling
#   trigger = t if /select-date-calendar/.test(t.className)

#   configs =
#     type: 'datetime'
#     input: input
#     trigger: trigger
#     step: 15

#     onOpen: (date) -> console.log "don't close that..."

#     onSelect: ->
#       console.log 'selected'

#     onClose: ->
#       console.log 'close!'

#   tz = new TzolkinPlugin().create(configs)
