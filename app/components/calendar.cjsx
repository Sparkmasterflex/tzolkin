React = require("react")
moment = require("moment")
map = require('lodash/collection/map')

Selector = require('./ui/selector')

class Calendar extends React.Component
  displayName: "Calendar"

  render: ->
    current_year = moment().year()
    <div className='tzolkin-calendar__container'>
      <div className='tzolkin-calendar__controls'>
        <a href='#prev-month' className='tzolkin-calendar__nav tzicon tzprevious' onClick={this.previous_month}></a>

        <Selector
          selected={moment(this.props.date).format("MMMM")}
          options={moment.months()}
          change_selection={this.select_month}
        />
        <Selector
          selected={moment(this.props.date).format("YYYY")}
          options={[(current_year-2)..(current_year+5)]}
          change_selection={this.select_year}
        />

        <a href='#next-month' className='tzolkin-calendar__nav tzicon tznext' onClick={this.next_month}></a>
      </div>

      <div className='tzolkin-month'>
        <div className='tzolkin-week--days'>
          { map moment.weekdaysShort(), (wday) ->
            <div key={wday} className='tzolkin-day--names'>{wday}</div>
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

  select_year: (e) =>
    e.preventDefault()
    new_year     = moment().year(e.target.dataset.value).year()
    current_year = @props.date.year()
    args = if new_year > current_year then ['add', (new_year - current_year)]
    else if new_year < current_year then ['subtract', (current_year - new_year)]
    else null

    @props.switch_year(args...) if args?

  select_month: (e) =>
    e.preventDefault()
    new_month     = moment().month(e.target.dataset.value).month()
    current_month = @props.date.month()
    args = if new_month > current_month then ['add', (new_month - current_month)]
    else if new_month < current_month then ['subtract', (current_month - new_month)]
    else null

    @props.switch_month(args...) if args?


module.exports = Calendar