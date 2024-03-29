import React from "react"
import moment from "moment"

import Selector from './ui/selector'

class Calendar extends React.Component
  displayName: "Calendar"

  render: ->
    <div className='tzolkin-calendar__container'>
      <div className='tzolkin-calendar__controls'>
        <a
          href='#prev-month'
          className='tzolkin-calendar__nav tzicon tzprevious'
          onClick={this.previous_month}
          title={this.month_name('previous')}
        ></a>

       <a
          href='#today'
          className='tzolkin-calendar__nav tzicon tzhome'
          onClick={this.set_today}
          title={moment().format(this.props.format)}
        ></a>

        <Selector
          selected={moment(this.props.date).format("MMMM")}
          list='month'
          options={moment.months()}
          change_selection={this.select_month}
          disabler={this.props.disabler}
        />
        <Selector
          selected={moment(this.props.date).format("YYYY")}
          list='year'
          options={[this.props.min_date.year()..this.props.max_date.year()]}
          change_selection={this.select_year}
          disabler={this.props.disabler}
        />

        <a
          href='#next-month'
          className='tzolkin-calendar__nav tzicon tznext'
          onClick={this.next_month}
          title={this.month_name('next')}
        ></a>
      </div>

      <div className='tzolkin-month'>
        <div className='tzolkin-week--days'>
          { moment.weekdaysShort().map (wday) ->
            <div key={wday} className='tzolkin-day--names'>{wday}</div>
          }
        </div>
        {this.props.children}
      </div>
    </div>

  month_name: (prev_next) ->
    dt = moment(this.props.date)
    alt_dt = if prev_next is 'previous'
    then dt.subtract(1, 'month')
    else dt.add(1, 'month')

    alt_dt.format("MMMM")

  ###==================
         EVENTS
  ==================###
  previous_month: (e) =>
    e.preventDefault()
    @props.switch_month('subtract', 1)

  next_month: (e) =>
    e.preventDefault()
    @props.switch_month('add', 1)

  set_today: (e) =>
    e.preventDefault()
    @props.set_date(moment(), true)

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


export default Calendar
