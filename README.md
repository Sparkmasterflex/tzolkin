# tzolkin
React DateTime picker for LeadManager and beyond

# *STILL IN DEVELOPMENT*

## Install

```
  npm install tzolkin --save
```

## Usage

#### HTML:

```
  <input type='text' name='date' class='select-datetime' />
```

To prevent any browser Date/Time picker UI, use a standard text input vs date, time or datetime.

#### JS: 

```
  Tzolkin  = require('tzolkin');

  Tzolkin.create({
    type: 'datetime',
    input: '.select-datetime'
  })
```


### Multiple Instances

```
  <label>Date</label>
  <input type='text' name='date' class='select-datetime' />

  <label>Time</label>
  <input type='text' name='time' class='select-datetime' />
```

If there are multiple inputs which need to use `Tzolkin` then set `input` key equal to a JavaScript selected element or have different classes for each and pass just the CSS class as a string.

```
  Tzolkin  = require('tzolkin');

  dt_input = document.querySelectorAll('.select-datetime')[0];
  // or $('.select-datetime')[0]
  tm_input = document.querySelectorAll('.select-datetime')[1];
  // or $('.select-datetime')[1]

  Tzolkin.create({ type: 'date', input:  dt_input});
  Tzolkin.create({ type: 'time', input:  tm_input});
```