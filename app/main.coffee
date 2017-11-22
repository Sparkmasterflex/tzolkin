Tzolkin  = require './app'

div = document.querySelector('.date-picker')

Tzolkin.create {label: 'Date', type: 'date', default: "2017-11-21"}, div

