React        = require("react")
ReactDOM     = require 'react-dom'
ClickOutside = require('react-click-outside')
moment       = require("moment")

map      = require('lodash/collection/map')
clone    = require('lodash/lang/clone')

Calendar   = require('../components/calendar')
Week       = require('../components/week')
TimePicker = require('./time_picker')

class DateTimePicker extends React.Component
  displayName: "DateTimePicker"

  constructor: (props) ->
    super(props)
    this.state =
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
    date      = moment(this.props.selected.format("YYYY-MM-DD"))
    first_day = date.startOf('month')
    weeks     = Math.floor(date.daysInMonth()/7)
    map [0..weeks], (w) =>
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

  handleClickOutside: => @props.toggle()

  ###==================
         EVENTS
  ==================###
  set_date: (date) =>
    @setState {date: date.format("YYYY-MM-DD")}, =>
      @props.set_date(@concat_selected(date, 'date'), !@state.time?, this.node)

  set_time: (time) =>
    @setState {time: time.format("HH:mm")}, =>
      @props.set_date(@concat_selected(time, 'time'), !@state.date?, this.node)


module.exports = ClickOutside(DateTimePicker)