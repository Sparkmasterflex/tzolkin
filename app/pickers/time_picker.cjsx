React = require("react")
moment = require("moment")
{ each, map } = require('lodash/collection')

Calendar = require('../components/calendar')
Week = require('../components/week')

SCROLL_JUMP = 116

class TimePicker extends React.Component
  displayName: "TimePicker"

  constructor: (props) ->
    super(props)
    this.state =
      top: 0

  componentDidMount: ->
    this.setState
      top: document.querySelector('.tzolkin-selected').offsetTop*-1

  render: ->
    <div className="tzolkin-timepicker">
      <a href='#up' className='tzolkin-time__scroll tzicon tzup' onClick={this.scroll_up} />
      {this.render_hours()}
      <a href='#up' className='tzolkin-time__scroll tzicon tzdown' onClick={this.scroll_down} />
    </div>

  render_hours: ->
    hours = this.hours()
    if hours.length > 2 # if 1-24 vs 2 arrays
      hours_el = map hours, (h) =>
        map ["00", "15", "30", "45"], (m) => @render_time_li(h, m)
    else
      ampm = 'am'
      hours_el = []
      each hours, (hour_block, i) =>
        each hour_block, (h) =>
          each ["00", "15", "30", "45"], (m) => hours_el.push @render_time_li(h, m, ampm)
        ampm = 'pm'
    <div className='tzolkin-timelist'>
      <ul
        className='tzolkin-timelist-ul'
        style={{top: "#{this.state.top}px"}}
      >{hours_el}</ul>
    </div>

  render_time_li: (hour, minute, ampm=null) ->
    hour_24 = if ampm? and ampm is 'pm' then hour+12 else hour
    is_current_hour = hour_24 is this.props.selected.hour()
    is_closest_minute = this.props.selected.minute()-15 < parseInt(minute) <= this.props.selected.minute()
    klass = "tzolkin-selected" if is_current_hour and is_closest_minute

    <li
      onClick={this.select_time}
      key="#{hour_24}#{minute}"
      data-time="#{hour_24}:#{minute}"
      className={klass}
    >{hour}:{minute}{ampm}</li>

  hours: ->
    if /H/.test this.props.format
      [0..23]
    else
      arr = [1..11]
      arr.unshift(12)
      [arr, arr]

  ###==================
         EVENTS
  ==================###
  scroll_up: (e) =>
    e.preventDefault()
    top = @state.top
    return if top is 0
    @setState { top: top+SCROLL_JUMP }

  scroll_down: (e) =>
    e.preventDefault()
    top = @state.top
    @setState { top: top-SCROLL_JUMP }

  select_time: (e) =>
    today = moment().format("YYYY-MM-DD")
    @props.set_date moment("#{today} #{e.target.dataset.time}")

module.exports = TimePicker