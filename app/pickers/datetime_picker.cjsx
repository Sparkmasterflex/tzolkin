React = require("react")
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
    console.log props.selected
    this.state =
      date: null
      time: null

  render: ->
    <div className="tzolkin-datetimepicker">
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

  ###==================
         EVENTS
  ==================###
  set_date: (date) =>
    @setState {date: date.format("YYYY-MM-DD")}, =>
      @props.set_date(date, !@state.time?)

  set_time: (time) =>
    @setState {time: time.format("HH:mm")}, =>
      @props.set_date(time, !@state.date?)


module.exports = DateTimePicker