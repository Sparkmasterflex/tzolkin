React = require("react")
moment = require("moment")
map = require('lodash/collection/map')

Calendar = require('../components/calendar')
Week = require('../components/week')

class DatePicker extends React.Component
  displayName: "DatePicker"

  render: ->
    <div className="tzolkin-datepicker">
      <Calendar date={this.props.selected} switch_month={this.props.switch_month}>
        {this.render_weeks()}
      </Calendar>
    </div>

  render_weeks: ->
    date      = this.props.selected
    first_day = date.startOf('month')
    weeks     = Math.floor(date.daysInMonth()/7)
    map [0..weeks], (w) ->
      <Week week_num={w} first_day={first_day.format("YYYY-MM-DD")} key="week-#{w}" />



module.exports = DatePicker