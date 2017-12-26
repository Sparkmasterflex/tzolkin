React = require("react")
moment = require("moment")
map = require('lodash/collection/map')

Calendar = require('../components/calendar')
Week = require('../components/week')

class DatePicker extends React.Component
  displayName: "DatePicker"

  render: ->
    <div className="tzolkin-datepicker" style={this.props.styles}>
      <Calendar
        date={this.props.selected}
        switch_month={this.props.switch_month}
        switch_year={this.props.switch_year}
      >
        {this.render_weeks()}
      </Calendar>
    </div>

  render_weeks: ->
    date      = this.props.selected
    first_day = date.startOf('month')
    weeks     = Math.floor(date.daysInMonth()/7)
    map [0..weeks], (w) =>
      <Week
        key="week-#{w}"
        week_num={w}
        first_day={first_day.format("YYYY-MM-DD")}
        selected={@props.selected}
        set_date={@props.set_date}
      />



module.exports = DatePicker