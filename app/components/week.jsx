import React  from "react"
import moment from "moment"

import Day    from './day'

class Week extends React.Component
  displayName: "Week"

  render: ->
    {week_num, first_day} = this.props
    which_day = if week_num is 0
    then moment(first_day).add(week_num, 'week')
    else moment(first_day).add(week_num, 'week').startOf('week')

    <div className="tzolkin-week" key="week-#{week_num}">
      {[0..6].map (d) =>
        day = moment(which_day.format("YYYY-MM-DD")).startOf('week').add(d, 'day')
        <Day
          key="day-#{week_num}-#{d}"
          day={day}
          selected={day.format("YYYY-MM-DD") is @props.selected.format("YYYY-MM-DD")}
          enabled={@is_enabled(which_day.month(), day)}
          set_date={@props.set_date}
        />
      }
    </div>

  is_enabled: (curr_month, day) ->
    return false unless curr_month is day.month()
    return false if this.props.disabler.is_disabled(day)
    this.props.min_date <= day <= this.props.max_date

export default Week