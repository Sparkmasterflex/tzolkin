React = require("react")
ReactDOM = require 'react-dom'
moment = require("moment")
map   = require('lodash/collection/map')
clone = require('lodash/lang/clone')

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

  componentWillUnmount: ->
    this.props.on_close this.node

  render: ->
    <div className="tzolkin-datetimepicker" style={this.props.styles}>
      <Calendar
        date={this.props.selected}
        switch_month={this.props.switch_month}
        switch_year={this.props.switch_year}
      >
        {this.render_weeks()}
      </Calendar>

      <TimePicker
        selected={this.props.selected}
        format={this.props.format}
        set_date={this.set_time}
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
        set_date={@set_date}
      />

  concat_selected: (val, part) ->
    if part is 'time'
      time = val.format("HH:mm")
      date = this.state.date or this.props.selected.format("YYYY-MM-DD")
    else
      date = val.format("YYYY-MM-DD")
      time = this.state.time or this.props.selected.format("HH:mm")

    moment("#{date} #{time}")


  ###==================
         EVENTS
  ==================###
  set_date: (date) =>
    @setState {date: date.format("YYYY-MM-DD")}, =>
      @props.set_date(@concat_selected(date, 'date'), !@state.time?, this.node)

  set_time: (time) =>
    @setState {time: time.format("HH:mm")}, =>
      @props.on_select(this.node)
      @props.set_date(@concat_selected(time, 'time'), !@state.date?, this.node)


module.exports = DateTimePicker