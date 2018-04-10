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

      <Tzolkin type='datetime' onError={this.error_that_shit}>
        <input defaultValue="4/01/2018 12:00 pm" type="text" order={1} />
        <input defaultValue="4/04/2018 12:00 pm" type="text" order={2} />
        <input defaultValue="4/04/2018 12:00 pm" type="text" order={3} />
      </Tzolkin>
    </div>

  update_date_state: (date, el) =>
    @setState
      date: date

  show_datepicker: (e) =>
    @setState
      date_picker_show: !@state.date_picker_show

  error_that_shit: (date, errors, node, input) =>
    console.log date
    console.log errors
    console.log node
    console.log input



 export default {
  create: (node) ->
    ReactDOM.render <MyComponent />, node
}
