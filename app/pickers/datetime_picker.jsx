import React        from "react"
import ReactDOM     from 'react-dom'
import ClickOutside from 'react-click-outside'

import map      from 'lodash/collection/map'
import clone    from 'lodash/lang/clone'

import { DateTime } from "luxon"

import Calendar   from '../components/calendar'
import Week       from '../components/week'
import TimePicker from './time_picker'

import { SQL_FORMAT } from '../../constants'

class DateTimePicker extends React.Component
  displayName: "DateTimePicker"

  constructor: (props) ->
    super(props)
    this.state =
      show: true
      date: null
      time: null

  componentDidMount: ->
    this.node = ReactDOM.findDOMNode(this)
    this.props.on_open this.node
    this.props.set_readonly 'add'

  componentWillUnmount: ->
    this.props.on_close?(this.node)
    this.props.set_readonly 'remove'

  render: ->
    <div className="tzolkin-datetimepicker" style={this.props.styles}>
      <Calendar
        date={this.props.selected}
        set_date={this.props.set_date}
        switch_month={this.props.switch_month}
        switch_year={this.props.switch_year}
        min_date={this.props.min_date}
        max_date={this.props.max_date}
        disabler={this.props.disabler}
        format={this.props.format}
      >
        {this.render_weeks()}
      </Calendar>

      <TimePicker
        selected={this.props.selected}
        format={this.props.format}
        set_date={this.set_time}
        step={this.props.step}
        disabler={this.props.disabler}
      />
    </div>

  render_weeks: ->
    date      = this.props.selected
    first_day = date.startOf('month')
    weeks     = Math.floor(date.daysInMonth/7)
    map [0..weeks], (w) =>
      <Week
        week_num={w}
        first_day={first_day.toFormat(SQL_FORMAT)}
        key="week-#{w}"
        selected={this.props.selected}
        min_date={@props.min_date}
        max_date={@props.max_date}
        set_date={@set_date}
        disabler={this.props.disabler}
      />

  concat_selected: (val, part) ->
    if part is 'time'
      time = val.toFormat("HH:mm")
      date = this.state.date or this.props.selected.toFormat(SQL_FORMAT)
    else
      date = val.toFormat(SQL_FORMAT)
      time = this.state.time or this.props.selected.toFormat("HH:mm")
    DateTime.fromFormat("#{date} #{time}", "#{SQL_FORMAT} HH:mm")

  handleClickOutside: (e) =>
    # horrible hack to prevent toggle before ready
    if @state.show
      @setState show: !@state.show
    else
      return if e.target.tagName.toUpperCase() == 'INPUT'
      @props.toggle()

  ###==================
         EVENTS
  ==================###
  set_date: (date) =>
    @setState {date: date.toFormat(SQL_FORMAT)}, =>
      @props.set_date(@concat_selected(date, 'date'), true, this.node)

  set_time: (time) =>
    @setState {time: time.toFormat("HH:mm")}, =>
      @props.set_date(@concat_selected(time, 'time'), false, this.node)


export default ClickOutside(DateTimePicker)
