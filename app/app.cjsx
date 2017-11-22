React = require("react")
ReactDOM = require 'react-dom'
moment = require("moment")

map   = require('lodash/collection/map')
clone = require('lodash/lang/clone')

DatePicker = require('./pickers/date_picker')

{ ALLOWED_TYPES } = require('../constants')

css = require("./stylesheets")

# https://en.wikipedia.org/wiki/Tzolk%27in
class Tzolkin extends React.Component
  displayName: "Tzolkin"

  constructor: (props) ->
    super(props)
    this.errors = {}
    this.state =
      show: true
      selected: moment(props.default)

  render: ->
    errors = this.render_errors() if this.invalid_type()
    <div className='tzolkin-container'>
      {errors}
      <label htmlFor="tzolkin-#{this.props.type}">{this.props.type}</label>
      <input
        id="tzolkin-#{this.props.type}"
        type='text'
        defaultValue={this.props.default}
        onFocus={this.display_picker}
      />
      {this.render_picker()}
    </div>

  render_picker: ->
    return "" unless this.state.show
    switch this.props.type
      when 'date'     then this.render_datepicker()
      else
        <div>nothing</div>
     # when 'time'     then TimePicker
     # when 'datetime' then DateTimePicker

  render_datepicker: ->
    <DatePicker selected={this.state.selected} switch_month={this.switch_month} />

  render_errors: ->
    map this.errors, (err,key) -> <p key="error-#{key}">{err}</p>

  invalid_type: ->
    valid = ALLOWED_TYPES.indexOf(this.props.type) >= 0
    this.errors.invalid = "Invalid HTML input type. Allowed: #{ALLOWED_TYPES.join(', ')}" unless valid
    !valid

  switch_month: (direction, num) =>
    selected = @state.selected
    if direction is 'subtract'
      selected.subtract(1, 'month')
    else
      selected.add(1, 'month')

    @setState
      selected: selected




  ###==================
         EVENTS
  ==================###
  display_picker: (e) => @setState { show: !@state.show }



module.exports = {
  create: (config, node) ->
    ReactDOM.render <Tzolkin {...config} />, node
}
