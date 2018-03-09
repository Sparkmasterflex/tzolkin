React    = require "react"
ReactDOM = require 'react-dom'
moment   = require "moment"

each = require('lodash/collection/each')
extend = require('lodash/object/extend')
{ clone, isArray } = require('lodash/lang')

DatePicker = require('./pickers/date_picker')
TimePicker = require('./pickers/time_picker')
DateTimePicker = require('./pickers/datetime_picker')

Disabler = require('./lib/disabler')

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
    this.disabler = new Disabler(this.props.disable)
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
      when 'datetime' then "MM/DD/YYYY h:mm a"
      when 'time'     then "h:mm a"

    date = this.date(format)
    {
      type: type
      default: date.format("YYYY-MM-DD HH:mm:ss")
      selected: date
      min_date: moment({month: '0', day: '01'}).subtract(2, 'y')
      max_date: moment({month: '11', day: '31'}).add(2, 'y')
      format: format
    }

  componentWillMount: ->
    if this.props.input
      this.input()?.addEventListener 'click', this.display_picker

    if this.props.trigger?
      trigger = if typeof this.props.input is 'string'
      then document.querySelector(this.props.trigger)
      else this.props.trigger
      trigger.addEventListener 'click', this.display_picker

  render: ->
    <div ref='tzolkin-picker'>
      {this.children()}
      {this.render_picker()}
    </div>

  render_picker: ->
    return "" unless this.show_datepicker()
    switch this.state.type
      when 'date'     then this.render_datepicker()
      when 'time'     then this.render_timepicker()
      when 'datetime' then this.render_datetimepicker()
      else
        <div>Invalid input type</div>

  render_datepicker: ->
    <DatePicker {...this.datepicker_props()} />

  render_timepicker: ->
    <TimePicker {...this.picker_props()} />

  render_datetimepicker: ->
    <DateTimePicker {...this.datepicker_props()} />

  picker_props: ->
    {
      selected:     this.state.selected
      format:       this.state.format
      step:         this.state.step
      set_date:     this.set_date
      styles:       this.calculate_position()
      on_open:      this.on_open
      on_close:     this.on_close
      disabler:     this.disabler
      set_readonly: this.readonly
      toggle:       this.display_picker
    }

  datepicker_props: ->
    extend {
      switch_month: this.switch_month
      switch_year: this.switch_year
      min_date: this.state.min_date
      max_date: this.state.max_date
    }, this.picker_props()

  calculate_position: ->
    {x, y, width, height} = this.input().getBoundingClientRect()
    height += 5 # padding

    top  = (y+height) + window.scrollY
    left = x + window.scrollX

    if (PICKER_HEIGHT + top) >= window.innerHeight
      top = (y + window.scrollY) - (PICKER_HEIGHT + height)

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

  set_date: (d, keep_open=false, node) =>
    this.input().value = d.format(this.state.format)
    @on_select(node)
    @setState {selected: d, show: keep_open}

  readonly: (action) =>
    if action is 'add'
      @input().setAttribute('readonly', true)
    else if action is 'remove'
      @input().removeAttribute('readonly')

  date: (format)->
    format ?= this.state.format
    return moment(this.props.date, format) if this.props.date?

    input = this.input()
    return moment(input.value, format) if input? and input.value isnt ""
    return moment()

  children: ->
    return "" unless this.props.children?

    children = if isArray(this.props.children) then this.props.children else [this.props.children]
    children_arr = []
    each children, (el, i) =>
      props = {key: "#{el.type}-#{i}"}
      props = extend(props, {onFocus: @display_picker, ref: "tzolkin-input" }) if el.type is 'input'
      children_arr.push React.cloneElement(el, props)

    children_arr

  input: ->
    # if nested input in JSX
    return this.refs['tzolkin-input'] if this.refs['tzolkin-input']?

    # nothing to see here
    return unless this.props.input

    # either return dom element or use string to find it
    return this.props.input unless typeof this.props.input is 'string'
    document.querySelector(this.props.input)

  show_datepicker: ->
    return this.props.visible if this.props.visible?
    this.state.show           if this.state.show?

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
    e?.preventDefault()
    @setState { show: !@state.show }

TzolkinPlugin = {
  create: (config) ->
    calendar = document.createElement('div')
    calendar.className = "tzolkin"
    document.body.appendChild calendar
    ReactDOM.render <Tzolkin {...config} />, calendar
}

module.exports = { Tzolkin, TzolkinPlugin }
