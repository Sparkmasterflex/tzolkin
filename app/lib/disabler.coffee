moment   = require "moment"

{
  each,
  filter,
  find,
} = require('lodash/collection')
keys = require('lodash/object/keys')
flatten = require('lodash/array/flatten')

class Disabler
  constructor: (disable) ->
    this.configs = disable
    {
      @days,
      @dates,
      @months,
      @years,
      @hours
    } = this.configs

  is_disabled: (to_check, type=null) ->
    switch type
      when 'month' then this.disabled_month(to_check)
      when 'year'  then this.disabled_year(to_check)
      when 'hour'  then this.disabled_hour(to_check)
      else
        this.disabled_date(to_check)

  disabled_date: (dt) ->
    disabled_list = []
    disable = {}
    each keys(this.configs), (type) =>
      list = @configs[type]
      return false if list?.length is 0
      disable[type] = switch type
        when 'years'  then @disabled_year(dt.format("YYYY"))
        when 'months' then @disabled_month(dt.format("MMMM"))
        when 'days'   then list.indexOf(dt.format("dddd")) >= 0
        when 'dates'  then list.indexOf(parseInt(dt.format("DD"))) >= 0
        when 'hours'  then @disabled_hour(dt.format("h:mma"))

      disables = filter disable, (value, key) -> value
      disabled_list.push(disables)
    this.used = true

    return true if flatten(disabled_list).length
    false

  disabled_hour: (hour) ->
    today = moment().format("YYYY-MM-DD")
    matched_hour = find this.configs.hours, (h) =>
      return null if @used
      disabled_hour = moment("#{today} #{h}", "YYYY-MM-DD h:mma").format("H")
      parseInt(disabled_hour) is parseInt(hour)

    matched_hour?

  disabled_month: (month) ->
    matched_month = find this.configs.months, (m) -> m is month
    matched_month?

  disabled_year: (year) ->
    matched_year = find this.configs.years, (y) -> y is year
    matched_year?

module.exports = Disabler