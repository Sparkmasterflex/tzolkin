import { DateTime } from "luxon"

import {
  each,
  filter,
  find,
}       from 'lodash/collection'
import keys    from 'lodash/object/keys'
import flatten from 'lodash/array/flatten'

import { SQL_FORMAT } from '../../constants'

class Disabler
  constructor: (disable) ->
    if disable?
      this.configs = disable
      {
        @days,
        @dates,
        @months,
        @years,
        @hours
      } = this.configs

  is_disabled: (to_check, type=null) ->
    return false unless this.configs?
    switch type
      when 'month' then this.disabled_month(to_check)
      when 'year'  then this.disabled_year(to_check)
      when 'hour'  then this.disabled_hour(to_check)
      else
        this.disabled_date(to_check)

  disabled_date: (dt) ->
    return false unless this.configs?
    disabled_list = []
    disable = {}
    each keys(this.configs), (type) =>
      list = @configs[type]
      return false if list?.length is 0
      disable[type] = switch type
        when 'years'  then @disabled_year(dt.toFormat("yyyy"))
        when 'months' then @disabled_month(dt.toFormat("LLLL"))
        when 'days'   then list.indexOf(dt.toFormat("cccc")) >= 0
        when 'dates'  then list.indexOf(parseInt(dt.toFormat("dd"))) >= 0

      disables = filter disable, (value, key) -> value
      disabled_list.push(disables)

    return true if flatten(disabled_list).length
    false

  disabled_hour: (hour) ->
    return false unless this.configs?
    today = DateTime.local().toFormat(SQL_FORMAT)
    matched_hour = find this.configs.hours, (h) =>

      disabled_hour = DateTime.fromFormat("#{today} #{h}", "#{SQL_FORMAT} ha").toFormat("H")
      parseInt(disabled_hour) is parseInt(hour)

    matched_hour?

  disabled_month: (month) ->
    return false unless this.configs?
    matched_month = find this.configs.months, (m) -> m is month
    matched_month?

  disabled_year: (year) ->
    return false unless this.configs?
    matched_year = find this.configs.years, (y) -> y is parseInt(year)
    matched_year?

export default Disabler