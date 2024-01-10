import React        from "react"
import ReactDOM     from 'react-dom'
import ClickOutside from 'react-click-outside'
import moment       from "moment"

import Calendar from '../components/calendar'
import Week     from '../components/week'

import { MAX_BLOCKS } from '../../constants'

class DatePicker extends React.Component
  displayName: "DatePicker"

  constructor: (props) ->
    super(props)
    this.state = { show: true }

  componentDidMount: ->
    this.node = ReactDOM.findDOMNode(this)
    this.props.on_open this.node
    this.props.set_readonly 'add'

  componentWillUnmount: ->
    this.props.on_close this.node
    this.props.set_readonly 'remove'

  render: ->
    <div className="tzolkin-datepicker" style={this.props.styles}>
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
    </div>

  render_weeks: ->
    date      = this.props.selected
    first_day = date.startOf('month')
    first_day_offset = first_day.day()
    days_in_month = first_day.daysInMonth()

    weeks  = Math.floor(this.selected_date().daysInMonth()/7)
    weeks += 1 if (first_day_offset + days_in_month) > MAX_BLOCKS

    [0..weeks].map (w) =>
      <Week
        key="week-#{w}"
        week_num={w}
        first_day={first_day.format("YYYY-MM-DD")}
        selected={@props.selected}
        min_date={@props.min_date}
        max_date={@props.max_date}
        disabler={this.props.disabler}
        set_date={@set_date}
      />

  selected_date: ->
    moment(this.props.selected.format("YYYY-MM-DD"))

  ###==================
         EVENTS
  ==================###
  set_date: (date, show) =>
    @props.set_date(date, show, @node)

  handleClickOutside: (e) =>
    # horrible hack to prevent toggle before ready
    if @state.show
      @setState show: !@state.show
    else
      return if e.target.tagName.toUpperCase() == 'INPUT'
      @props.toggle()

export default ClickOutside(DatePicker)
