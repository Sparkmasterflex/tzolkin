# Tzolkin
React DateTime picker for Real Geeks' LeadManager and beyond!

## About the Name

Tzolk'in (Mayan pronunciation: [t͡sol ˈkʼin], formerly and commonly tzolkin) is the name bestowed by Mayanists on the 260-day Mesoamerican calendar originated by the Maya civilization of pre-Columbian Mesoamerica.

[read more](https://en.wikipedia.org/wiki/Tzolk%27in)

# *STILL IN DEVELOPMENT*


## Install

```bash
  npm install tzolkin --save
```

## React/JSX Usage

```jsx
  { Tzolkin } = require('tzolkin')

  render: => {
    <div>
      <Tzolkin type="datetime">
        <input defaultValue="3/09/2018" type="input" />
      </Tzolkin>
    </div>  
  }
```

## Standard JavaScript or jQuery Usage

#### HTML:

```html
  <input type='text' name='date' class='select-datetime' />
```

To prevent any browser Date/Time picker UI, use a standard text input vs date, time or datetime.

#### JS: 

```javascript
  { TzolkinPlugin } = require('tzolkin');

  TzolkinPlugin.create({
    type: 'datetime',
    input: '.select-datetime'
  })
```


### Multiple Instances

```html
  <label>Date</label>
  <input type='text' name='date' class='select-datetime' />

  <label>Time</label>
  <input type='text' name='time' class='select-datetime' />
```

If there are multiple inputs which need to use `Tzolkin` then set `input` key equal to a JavaScript selected element or have different classes for each and pass just the CSS class as a string.

```javascript
  Tzolkin  = require('tzolkin');

  dt_input = document.querySelectorAll('.select-datetime')[0];
  // or $('.select-datetime')[0]
  tm_input = document.querySelectorAll('.select-datetime')[1];
  // or $('.select-datetime')[1]

  Tzolkin.create({ type: 'date', input:  dt_input});
  Tzolkin.create({ type: 'time', input:  tm_input});
```



## Options

| Option  | Data Type  | Description                    | Acceptable options |
|---------|------------|--------------------------------|--------------------|
| input * | DOM element, String | `<input>` to trigger date picker and receive selected date/time | `document.querySelector('.select-date')` or '.select-date' |
| type   | String     | picker has date, time or both  | 'date', 'time', 'datetime' |
| date    | String | Date/time for Tzolkin to start with | "03/12/2018" |
| format  | String | Date/time format desired using [moment.js formating](http://momentjs.com/docs/#/displaying/format/) | "MM/DD/YYYY h:mm a" |
| trigger | DOM element, String | link, span, button, etc to trigger date picker | `document.querySelector('a.select-date-trigger')` or 'a.select-date-trigger' |
| step | Integer | For time picker, minutes increments between hours | 15, 30, etc |
| minDate | String | disable any dates earlier than this date | "01/01/2001" |
| maxDate | String | disable any dates later than this date | "12/31/2025" |
| onOpen  | callback | _see below_ | |
| onSelect | callback | _see below_ | |
| onClose | callback | _see below_ | |

\* non-React only

## Defaults

All options, minus `input` are optional and most have a default value that they fall back on if no value is passed in the configurations.

| Option | Default         | More... |
|--------|-----------------|---------|
| type   | 'date'          |         |
| format | depends on type | date: "MM/DD/YYYY" <br /> datetime: "MM/DD/YYYY h:mm a" <br /> time: "h:mm a" |
| minDate | -2 years | Jan 1st of 2 years ago |
| maxDate | +2 years | Dec 31st of 2 years in future |

## Callbacks

Tzolkin allows for 3 callbacks occurring at different points in the lifecycle of the date/time picker.

| callback | when                                                         |
|----------|--------------------------------------------------------------|
| onOpen   | during `componentDidMount` called on picker component        |
| onSelect | called immediately after a date or time has been clicked     |
| onClose  | during `componentWillUnmount` called on picker component     |

#### Example:

```javascript
  Tzolkin.create({
    type: 'datetime',
    input: '.select-datetime'

    onOpen: function(date, picker_el, input_el) {
      console.log("Opening date/time picker");
      console.log(date);
      // ... do something cool ...
    },

    onSelect: function(date, picker_el, input_el) {
      alert("You picked" + date);
      // ... do something EVEN cooler ...
    },

    onClose: function(date, picker_el, input_el) {
      console.log("Closing date/time picker")
      // ... do something mildly entertaining ...
    }
  })
```

