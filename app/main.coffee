Tzolkin  = require './app'

configs =
  type: 'datetime'
  input: document.querySelector('.select-datetime')
  trigger: document.querySelector('.select-date-calendar')

Tzolkin.create configs

