React    = require "react"
ReactDOM = require 'react-dom'
{ Tzolkin } = require './app'


class MyComponent extends React.Component
  constructor: (props) ->
    super(props)
    this.state =
      date_picker_show: false

  render: ->
    <div className="tzolkin">
      <label htmlFor="lead_activity_activity_date">
        My <em>React</em>ion Time
      </label>

      <Tzolkin type='datetime'>
        <span>Do it</span>
        <input defaultValue="4/01/2018 12:00 pm" type="text" />
      </Tzolkin>
    </div>

  update_date_state: (date, el) =>
    @setState
      date: date

  show_datepicker: (e) =>
    @setState
      date_picker_show: !@state.date_picker_show


 export default {
  create: (node) ->
    ReactDOM.render <MyComponent />, node
}
