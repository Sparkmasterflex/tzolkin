React = require("react")
moment = require("moment")
map = require('lodash/collection/map')

class Selector extends React.Component
  displayName: "Selector"

  constructor: (props) ->
    super(props)
    this.state = { show: false }

  render: ->
    <div className='tzolkin-selector'>
      <a href="#select" onClick={this.toggle}>{this.props.selected}</a>
      {this.render_select()}
    </div>

  render_select: ->
    return "" unless this.state.show
    <ul className='tzolkin-selector__dropdown'>
      {map this.props.options, (opt) =>
        <li key="option-#{opt}" data-value={opt} onClick={@select}>{opt}</li>
      }
    </ul>

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