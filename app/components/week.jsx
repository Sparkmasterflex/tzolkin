import React  from "react"
import map    from 'lodash/collection/map'
import { DateTime } from "luxon"

import { SQL_FORMAT } from '../../constants'

import Day    from './day'

class Week extends React.Component
  displayName: "Week"

  render: ->
    {week_num, first_day} = this.props
    which_day = DateTime.fromFormat(first_day, SQL_FORMAT).plus(weeks: week_num)

    <div className="tzolkin-week" key="week-#{week_num}">
      {map [0..6], (d) =>
        day = which_day.startOf('week').plus(days: d)
        <Day
          key="day-#{week_num}-#{d}"
          day={day}
          selected={day.toFormat(SQL_FORMAT) is @props.selected.toFormat(SQL_FORMAT)}
          enabled={@is_enabled(which_day.month, day)}
          set_date={@props.set_date}
        />
      }
    </div>

  is_enabled: (curr_month, day) ->
    return false unless curr_month is day.month
    return false if this.props.disabler.is_disabled(day)
    this.props.min_date <= day <= this.props.max_date

export default Week