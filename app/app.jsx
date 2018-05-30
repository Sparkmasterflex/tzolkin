import React    from  "react"
import ReactDOM from  'react-dom'
import { DateTime } from "luxon"

import extend from 'lodash/object/extend'
import { each, map, find } from 'lodash/collection'
import { clone, isArray }  from 'lodash/lang'

import DatePicker     from './pickers/date_picker'
import TimePicker     from './pickers/time_picker'
import DateTimePicker from './pickers/datetime_picker'

import Disabler from './lib/disabler'

import {
  ALLOWED_TYPES,
  PICKER_HEIGHT,
  PICKER_WIDTHS,
  SQL_FORMAT
} from '../constants'

import css from "./stylesheets"

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
    min = DateTime.fromFormat(minDate, configs.format) if minDate?
    max = DateTime.fromFormat(maxDate, configs.format) if maxDate?
    configs.min_date = min if min?.isValid()
    configs.max_date = max if max?.isValid()
    this.state = extend { show: false }, configs

  defaults: (type='date') ->
    format = switch type
      when 'date'     then "LL/dd/yyyy"
      when 'datetime' then "LL/dd/yyyy h:mm a"
      when 'time'     then "h:mm a"

    date = this.date(format)
    {
      type: type
      default: date.toFormat("#{SQL_FORMAT} HH:mm:ss")
      selected: date
      min_date: DateTime.fromObject({month: 1, day: 1}).minus(years: 2)
      max_date: DateTime.fromObject({month: 12, day: 31}).plus(years: 2)
      format: format
    }

  componentWillMount: ->
    window.addEventListener "resize", this.recalculate

    if this.props.input
      this.input()?.addEventListener 'click', this.display_picker

    if this.props.trigger?
      trigger = if typeof this.props.input is 'string'
      then document.querySelector(this.props.trigger)
      else this.props.trigger
      trigger.addEventListener 'click', this.display_picker

  componentWillUnmount: ->
    window.removeEventListener "resize", this.recalculate

  render: ->
    # {this.render_errors()}
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
      styles:       this.state.position or this.calculate_position()
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

  render_errors: ->
    map this.state.errors, (err, i) -> <p key="error-#{i}">{err}</p>

  calculate_position: ->
    {x, left, y, top, width, height} = this.input().getBoundingClientRect()
    height += 5 # padding

    y ?= top
    x ?= left

    top  = (y+height) + window.scrollY
    left = x + window.scrollX

    if (PICKER_HEIGHT + top) >= window.innerHeight
      top = (y + window.scrollY) - (PICKER_HEIGHT + height)

    left = (x + width) - PICKER_WIDTHS[this.props.type] if left + PICKER_WIDTHS[this.props.type] >= window.innerWidth

    { top: "#{top}px", left: "#{left}px" }

  switch_month: (direction, num) =>
    @switch_to({months: num}, direction)

  switch_year: (direction, num) =>
    @switch_to({years: num}, direction)

  switch_to: (change, direction) ->
    selected = this.state.selected
    if direction is 'subtract'
      selected.minus(change)
    else
      selected.plus(change)

    this.setState {selected: selected}

  set_date: (d, keep_open=false, node) =>
    formatted = d.toFormat(@state.format)
    if @validate_date(d)
      @input().value = formatted
      @on_select(node)
      @setState {
        selected: d,
        show: keep_open
        errors: []
      }
    else
      if @props.onError?
        @props.onError?(formatted, @errors, node, @input())
      else
        @setState {errors: @errors}

  readonly: (action) =>
    if action is 'add'
      @input().setAttribute('readonly', true)
    else if action is 'remove'
      @input().removeAttribute('readonly')

  date: (format)->
    format ?= this.state.format
    return DateTime.fromFormat(this.props.date, format) if this.props.date?

    input = this.input()
    return DateTime.fromFormat(input.value, format) if input? and input.value isnt ""
    return DateTime.local()

  children: ->
    return "" unless this.props.children?
    this.inputs = []

    children = if isArray(this.props.children) then this.props.children else [this.props.children]
    children_arr = []
    each children, (el, i) =>
      ref = (input) =>
        o = input.props.order
        if o?
          ref_name = "tzolkin-input-#{o}"
          @inputs.push ref_name
          return ref_name
        "tzolkin-input"

      props = {key: "#{el.type}-#{i}"}
      props = extend(props, { onFocus: @display_picker, ref: ref(el) }) if el.type is 'input'
      children_arr.push React.cloneElement(el, props)

    children_arr

  input: ->
    # if nested input in JSX
    refs_query  = 'tzolkin-input'
    refs_query += "-#{this.state.input_index}" if this.state?.input_index?
    return this.refs[refs_query] if this.refs[refs_query]?

    # nothing to see here
    return unless this.props.input

    # either return dom element or use string to find it
    return this.props.input unless typeof this.props.input is 'string'
    document.querySelector(this.props.input)

  show_datepicker: ->
    return this.props.visible if this.props.visible?
    this.state.show           if this.state.show?

  validate_date: (selected_date) ->
    this.errors = []
    return true unless this.inputs?.length
    current_index = this.input().getAttribute('order')
    curr_i = current_index-1
    return true unless current_index? and current_index > 1
    valid_compared_to = map this.inputs, (ref, i) =>
      compared_to = DateTime.fromFormat(@refs[ref].value, @state.format)
      if i < curr_i
        err = "before"
        valid = selected_date > compared_to
      else if i > curr_i
        err = "after"
        valid = selected_date < DateTime.fromFormat(@refs[ref].value, @state.format)
        valid = false
      else
        valid = true
      this.errors.push "#{selected_date.toFormat(@state.format)} cannot be #{err} #{compared_to.toFormat(@state.format)}" unless valid
      valid

    !find(valid_compared_to, (v) -> v is false)? # return true if none invalid


  ###==================
        CALLBACKS
  ==================###
  on_open: (node) =>
    @props.onOpen?(@state.selected.toFormat(@state.format), node, @input())

  on_select: (node) =>
    @props.onSelect?(@state.selected.toFormat(@state.format), node, @input())

  on_close: (node) =>
    @props.onClose?(@state.selected.toFormat(@state.format), node, @input())


  ###==================
         EVENTS
  ==================###
  display_picker: (e) =>
    if e?
      e.preventDefault()
      input_index = e.target.getAttribute('order')

    show = (input_index? and input_index isnt @state?.input_index) or !@state.show
    state = { show: show }
    extend state, { input_index: input_index } if input_index?
    @setState state

  recalculate: (e) =>
    @setState
      position: @calculate_position()


class TzolkinPlugin
  constructor: -> this

  create: (configs) ->
    this.calendar = document.createElement('div')
    this.calendar.className = "tzolkin"
    document.body.appendChild this.calendar
    this.tz = ReactDOM.render <Tzolkin {...configs} />, this.calendar
    this

  close: =>
    @tz.setState { show: false }

export { TzolkinPlugin, Tzolkin }
