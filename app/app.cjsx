React    = require "react"
ReactDOM = require 'react-dom'
moment   = require "moment"

{ map, each } = require('lodash/collection')
extend = require('lodash/object/extend')
clone  = require('lodash/lang/clone')

DatePicker = require('./pickers/date_picker')
TimePicker = require('./pickers/time_picker')
DateTimePicker = require('./pickers/datetime_picker')

{
  ALLOWED_TYPES,
  PICKER_HEIGHT,
  PICKER_WIDTHS
} = require('../constants')

css = require("./stylesheets")

# https://en.wikipedia.org/wiki/Tzolk%27in
class Tzolkin extends React.Component
  displayName: "Tzolkin"

  constructor: (props) ->
    super(props)
    unclean_props = clone(props)
    {minDate, maxDate} = unclean_props
    delete unclean_props.minDate
    delete unclean_props.maxDate

    configs = extend this.defaults(props?.type), unclean_props
    min = moment(minDate, configs.format, unclean_props.type is "date") if minDate?
    max = moment(maxDate, configs.format, unclean_props.type is "date") if maxDate?
    configs.min_date = min if min?.isValid()
    configs.max_date = max if max?.isValid()
    this.state = extend { show: false }, configs

  defaults: (type='date') ->
    format = switch type
      when 'date'     then "MM/DD/YYYY"
      when 'datetime' then "MM/DD/YYYY h:mma"
      when 'time'     then "h:mma"

    date = moment(this.input().value, format) or moment()

    {
      type: type
      default: date.format("YYYY-MM-DD HH:mm:ss")
      selected: date
      min_date: moment({month: '0', day: '01'}).subtract(2, 'y')
      max_date: moment({month: '11', day: '31'}).add(2, 'y')
      format: format
    }

  componentWillMount: ->
    element = (el) ->
      return el unless typeof el is 'string'
      document.querySelector(el)

    element(this.props.input).addEventListener 'click', this.display_picker
    if this.props.trigger?
      element(this.props.trigger).addEventListener 'click', this.display_picker

  render: ->
    <div ref='tzolkin-picker'>
      {this.render_picker()}
    </div>

  render_picker: ->
    return "" unless this.state.show
    switch this.state.type
      when 'date'     then this.render_datepicker()
      when 'time'     then this.render_timepicker()
      when 'datetime' then this.render_datetimepicker()
      else
        <div>Invalid input type</div>

  render_datepicker: ->
    props = this.picker_props(
      switch_month: this.switch_month
      switch_year: this.switch_year
      min_date: this.state.min_date
      max_date: this.state.max_date
    )

    <DatePicker {...props} />

  render_timepicker: ->
    <TimePicker {...this.picker_props()} />

  render_datetimepicker: ->
    props = this.picker_props
      switch_month: this.switch_month
      switch_year: this.switch_year

    <DateTimePicker {...props} />

  picker_props: (add={}) ->
    extend {
      selected:  this.state.selected
      format:    this.state.format
      set_date:  this.set_date
      styles:    this.calculate_position()
      on_open:   this.on_open
      on_close:  this.on_close
    }, add

  calculate_position: ->
    {x, y, width, height} = this.input().getBoundingClientRect()
    height += 5 # padding

    top  = (y+height) + window.scrollY
    left = x + window.scrollX

    top = top - (PICKER_HEIGHT + height) if (PICKER_HEIGHT + top) >= window.innerHeight
    left = (x + width) - PICKER_WIDTHS[this.props.type] if left + PICKER_WIDTHS[this.props.type] >= window.innerWidth

    { top: "#{top}px", left: "#{left}px" }

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

  set_date: (d, show=false, node) =>
    this.input().value = d.format(this.state.format)
    @on_select(node)
    @setState {selected: d, show: show}

  input: ->
    return this.props.input unless typeof this.props.input is 'string'
    document.querySelector(this.props.input)

  ###==================
        CALLBACKS
  ==================###
  on_open: (node) =>
    @props.onOpen?(@state.selected.format(@state.format), node, @input())

  on_select: (node) =>
    @props.onSelect?(@state.selected.format(@state.format), node, @input())

  on_close: (node) =>
    @props.onClose?(@state.selected.format(@state.format), node, @input())

  ###==================
         EVENTS
  ==================###
  display_picker: (e) =>
    e.preventDefault()
    @setState { show: !@state.show }



module.exports = {
  create: (config) ->
    calendar = document.createElement('div')
    calendar.className = "tzolkin"
    document.body.appendChild calendar
    ReactDOM.render <Tzolkin {...config} />, calendar
}
