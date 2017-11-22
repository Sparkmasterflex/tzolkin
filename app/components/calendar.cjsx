React = require("react")
moment = require("moment")
map = require('lodash/collection/map')

class Calendar extends React.Component
  displayName: "Calendar"

  render: ->
    <div className='tzolkin-calendar__container'>
      <div className='tzolkin-calendar__controls'>
        <a href='#prev-month' onClick={this.previous_month}>prev</a>
        <h3>{this.props.date.format("MMMM")}</h3>
        <a href='#next-month' onClick={this.next_month}>next</a>
      </div>
      <div className='tzolkin-month'>
        <div className='tzolkin-week--days'>
          { map moment.weekdaysShort(), (wday) ->
            <div className='tzolkin-day--names'>{wday}</div>
          }
        </div>
        {this.props.children}
      </div>
    </div>


  ###==================
         EVENTS
  ==================###
  previous_month: (e) =>
    e.preventDefault()
    @props.switch_month('subtract', 1)

  next_month: (e) =>
    e.preventDefault()
    @props.switch_month('add', 1)

module.exports = Calendar