React    = require "react"
ReactDOM = require 'react-dom'
moment   = require "moment"

map    = require('lodash/collection/map')
extend = require('lodash/object/extend')
clone  = require('lodash/lang/clone')

DatePicker = require('./pickers/date_picker')
TimePicker = require('./pickers/time_picker')

{ ALLOWED_TYPES } = require('../constants')

css = require("./stylesheets")

# https://en.wikipedia.org/wiki/Tzolk%27in
class Tzolkin extends React.Component
  displayName: "Tzolkin"

  constructor: (props) ->
    super(props)
    configs = extend this.defaults(props?.type), props
    this.errors = {}
    this.state = extend { show: false, selected: moment(configs.default) }, configs

  defaults: (type='date') ->
    format = switch type
      when 'date'     then "MM/DD/YYYY"
      when 'datetime' then "MM/DD/YYYY h:mma"
      when 'time'     then "h:mma"

    {
      label: null
      html_id: "tzolkin-#{type}"
      type: type
      default: moment().format("YYYY-MM-DD HH:mm:ss")
      format: format
    }

  render: ->
    errors = this.render_errors() if this.invalid_type()
    <div className='tzolkin-container'>
      {errors}
      <label htmlFor={this.state.html_id}>{this.state.label or this.state.type}</label>
      <input
        ref='tzolkin_input'
        id={this.state.html_id}
        type='text'
        defaultValue={this.state.selected?.format(this.state.format)}
        onFocus={this.display_picker}
      />
      {this.render_picker()}
    </div>

  render_picker: ->
    return "" unless this.state.show
    switch this.state.type
      when 'date'     then this.render_datepicker()
      when 'time'     then this.render_timepicker()
      else
        <div>nothing</div>
     # when 'datetime' then DateTimePicker

  render_datepicker: ->
    <DatePicker
      selected={this.state.selected}
      switch_month={this.switch_month}
      switch_year={this.switch_year}
      set_date={this.set_date}
    />

  render_timepicker: ->
    <TimePicker
      selected={this.state.selected}
      format={this.state.format}
      set_date={this.set_date}
    />

  render_errors: ->
    map this.errors, (err,key) -> <p key="error-#{key}">{err}</p>

  invalid_type: ->
    valid = ALLOWED_TYPES.indexOf(this.props.type) >= 0
    this.errors.invalid = "Invalid HTML input type. Allowed: #{ALLOWED_TYPES.join(', ')}" unless valid
    !valid

  switch_month: (direction, num) =>
    @switch_to('month', direction, num)

  switch_year: (direction, num) =>
    @switch_to('year', direction, num)

  switch_to: (unit, direction, num) ->
    selected = this.state.selected
    if direction is 'subtract'
      selected.subtract(num, unit)
    else
      selected.add(num, unit)

    this.setState {selected: selected}

  set_date: (d) =>
    this.refs.tzolkin_input.value = d.format(this.state.format)
    @setState
      selected: d
      show: false

  ###==================
         EVENTS
  ==================###
  display_picker: (e) => @setState { show: !@state.show }



module.exports = {
  create: (config, node) ->
    ReactDOM.render <Tzolkin {...config} />, node
}
