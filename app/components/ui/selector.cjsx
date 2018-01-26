React = require("react")
moment = require("moment")
map = require('lodash/collection/map')
{
  PICKER_HEIGHT,
  PICKER_WIDTHS,
  SELECTOR_OPTION_HEIGHT
} = require('../../../constants')

class Selector extends React.Component
  displayName: "Selector"

  constructor: (props) ->
    super(props)
    this.state = { show: false }

  render: ->
    klass  = "tzolkin-selector"
    klass += "--#{this.props.list}" if this.props.list?
    <div ref='selector' className={klass}>
      <a href="#select" className='tzicon--with tzdown--after' onClick={this.toggle}>{this.props.selected}</a>
      {this.render_select()}
    </div>

  render_select: ->
    return "" unless this.state.show
    <ul className='tzolkin-selector__dropdown' style={this.calculate_position()}>
      {map this.props.options, (opt) =>
        disabled = @props.disabler.is_disabled(opt, this.props.list)
        on_click = if !disabled then @select else null
        klass = 'disabled' if disabled
        <li key="option-#{opt}" className={klass} data-value={opt} onClick={on_click}>{opt}</li>
      }
    </ul>

  calculate_position: ->
    selector = this.refs.selector
    {x, y, width, height} = selector.getBoundingClientRect()
    height += 5 # padding

    selector_height = (SELECTOR_OPTION_HEIGHT * this.props.options.length)
    top = if y + selector_height > window.innerHeight
    then (height + selector_height) * -1
    else height

    { top: "#{top}px" }


  ###==================
         EVENTS
  ==================###
  toggle: (e) =>
    @setState
      show: !@state.show

  select: (e) =>
    @toggle()
    @props.change_selection(e)


module.exports = Selector