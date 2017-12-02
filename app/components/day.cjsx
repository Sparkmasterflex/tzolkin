React = require("react")
moment = require("moment")

class Day extends React.Component
  displayName: "Day"

  render: ->
    klass  = 'tzolkin-day'
    klass += '--disabled' unless this.props.enabled

    <div className={klass} onClick={this.select_date}>
      {this.props.day.format("DD")}
    </div>

  ###==================
         EVENTS
  ==================###
  select_date: (e) =>
    e.preventDefault()
    @props.set_date(@props.day)
module.exports = Day