import React  from "react"
import moment from "moment"

class Day extends React.Component
  displayName: "Day"

  render: ->
    klass  = 'tzolkin-day'
    klass += '--disabled' unless this.props.enabled
    klass += '--selected' if this.props.enabled and this.props.selected

    <div className={klass} onClick={this.select_date}>
      {this.props.day.format("DD")}
    </div>

  ###==================
         EVENTS
  ==================###
  select_date: (e) =>
    e.preventDefault()
    @props.set_date(@props.day)

export default Day
