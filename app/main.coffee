Tzolkin  = require './app'

div = document.querySelector('.date-picker')

configs =
  label: 'Date and Time'
  type: 'datetime'
  name: 'start_date'


Tzolkin.create configs, div

