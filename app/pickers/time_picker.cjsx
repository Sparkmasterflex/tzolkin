React        = require("react")
ReactDOM     = require 'react-dom'
ClickOutside = require('react-click-outside')
moment       = require("moment")

{ each, map } = require('lodash/collection')
flatten       = require('lodash/array/flatten')

Calendar = require('../components/calendar')
Week = require('../components/week')

SCROLL_JUMP = 145

class TimePicker extends React.Component
  displayName: "TimePicker"

  constructor: (props) ->
    super(props)
    this.state =
      top: 0
      show: true

  componentDidMount: ->
    this.node = ReactDOM.findDOMNode(this)
    this.props.on_open?(this.node)
    this.props.set_readonly?('add') # b/c sometimes it's nested

    this.setState
      top: this.set_top()

  componentWillUnmount: ->
    this.props.on_close?(this.node)
    this.props.set_readonly?('remove') # b/c sometimes it's nested

  render: ->
    <div className="tzolkin-timepicker" style={this.props.styles}>
      <a href='#up' className='tzolkin-time__scroll tzicon tzup' onClick={this.scroll_up} />
      {this.render_hours()}
      <a href='#up' className='tzolkin-time__scroll tzicon tzdown' onClick={this.scroll_down} />
    </div>

  render_hours: ->
    hours = this.hours()
    if hours.length > 2 # if 1-24 vs 2 arrays
      hours_el = this.build_time_options(hours)
    else
      ampm = 'am'
      hours_el = []
      each hours, (hour_block, i) =>
        options = @build_time_options(hour_block, ampm)
        hours_el.push options
        ampm = 'pm'

    <div className='tzolkin-timelist' style={{width: this.list_width()}}>
      <ul
        className='tzolkin-timelist-ul'
        style={{top: "#{this.state.top}px"}}
      >{flatten(hours_el)}</ul>
    </div>

  format: ->
    return this.props.format if this.props.type is 'time'
    this.props.format.match(/[hH].*$/)[0]

  list_width: ->
    format = this.format()
    format_len = format.length
    format_len += 1 if format.match(/\bh:/)
    format_len += 1 if format.match(/a/i)

    width = 10 * format_len
    return 60 if width <= 60
    width

  build_time_options: (hours, ampm=null) ->
    i = 0
    lis = []
    each hours, (h) =>
      i += 1
      min = 0
      while min < 60
        lis.push @render_time_li(h, min, ampm)
        min += @props.step
    return flatten(lis)

  render_time_li: (hour, minute, ampm) ->
    hour_24 = if ampm? and ampm is 'pm' then hour+12 else hour
    is_current_hour = hour_24 is this.props.selected.hour()
    is_closest_minute = this.props.selected.minute()-this.props.step < parseInt(minute) <= this.props.selected.minute()
    klass = ""
    klass += "tzolkin-selected" if is_current_hour and is_closest_minute
    klass += " disabled" if this.props.disabler.is_disabled(hour_24, 'hour')
    minute = "0#{minute}" if minute.toString().length is 1

    date_time = moment().set {
      hour: hour_24,
      minute: minute
    }

    <li
      onClick={this.select_time}
      key="#{hour_24}#{minute}"
      data-hour={hour_24}
      data-minute={minute}
      className={klass}
      style={{width: this.list_width() - 2}}
    >{date_time.format(this.format())}</li>

  hours: ->
    if /H/.test this.props.format
      [0..23]
    else
      arr = [0..11]
      [arr, arr]

  set_top: ->
    selected_el = document.querySelector('.tzolkin-selected')
    return 0 unless selected_el?

    desired_top = selected_el.offsetTop
    pos = if desired_top < this.max_height()
    then desired_top
    else this.max_height()
    pos*-1

  max_height: ->
    container_height = document.querySelector('.tzolkin-timelist').offsetHeight
    list_height      = document.querySelector('.tzolkin-timelist-ul').offsetHeight
    list_height - container_height

  handleClickOutside: =>
    if @state.show
      @setState show: !@state.show
    else
      @props.toggle()

  ###==================
         EVENTS
  ==================###
  scroll_up: (e) =>
    e.preventDefault()
    top = @state.top
    new_value = top+SCROLL_JUMP
    new_value = 0 if new_value >= 0
    @setState { top: new_value }

  scroll_down: (e) =>
    e.preventDefault()
    top = @state.top
    new_top = top-SCROLL_JUMP
    new_top = @max_height()*-1 if new_top < @max_height()*-1
    @setState { top: new_top }

  select_time: (e) =>
    data = e.target.dataset
    date_time = moment().set {
      hour: data.hour
      minute: data.minute
    }
    @props.set_date date_time, null, this.node

module.exports = ClickOutside(TimePicker)