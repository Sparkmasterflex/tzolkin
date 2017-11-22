React = require("react")
moment = require("moment")

class Day extends React.Component
  displayName: "Day"

  render: ->
    klass  = 'tzolkin-day'
    klass += '--disabled' unless this.props.enabled

    <div className={klass}>
      {this.props.day.format("DD")}
    </div>

module.exports = Day