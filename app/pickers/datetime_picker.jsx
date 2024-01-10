import React        from "react"
import ReactDOM     from 'react-dom'
import ClickOutside from 'react-click-outside'
import moment       from "moment"

import Calendar   from '../components/calendar'
import Week       from '../components/week'
import TimePicker from './time_picker'

import { MAX_BLOCKS } from '../../constants'

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
    first_day = this.selected_date().startOf('month')

    first_day_offset = first_day.day()
    days_in_month = first_day.daysInMonth()

    weeks  = Math.floor(this.selected_date().daysInMonth()/7)
    weeks += 1 if (first_day_offset + days_in_month) > MAX_BLOCKS

    [0..weeks].map (w) =>
      <Week
        week_num={w}
        first_day={first_day.format("YYYY-MM-DD")}
        key="week-#{w}"
        selected={this.props.selected}
        min_date={@props.min_date}
        max_date={@props.max_date}
        set_date={@set_date}
        disabler={this.props.disabler}
      />

  concat_selected: (val, part) ->
    if part is 'time'
      time = val.format("HH:mm")
      date = this.state.date or this.props.selected.format("YYYY-MM-DD")
    else
      date = val.format("YYYY-MM-DD")
      time = this.state.time or this.props.selected.format("HH:mm")

    moment("#{date} #{time}")

  handleClickOutside: (e) =>
    # horrible hack to prevent toggle before ready
    if @state.show
      @setState show: !@state.show
    else
      return if e.target.tagName.toUpperCase() == 'INPUT'
      @props.toggle()

  selected_date: ->
    moment(this.props.selected.format("YYYY-MM-DD"))

  ###==================
         EVENTS
  ==================###
  set_date: (date) =>
    @setState {date: date.format("YYYY-MM-DD")}, =>
      @props.set_date(@concat_selected(date, 'date'), true, this.node)

  set_time: (time) =>
    @setState {time: time.format("HH:mm")}, =>
      @props.set_date(@concat_selected(time, 'time'), false, this.node)


export default ClickOutside(DateTimePicker)
