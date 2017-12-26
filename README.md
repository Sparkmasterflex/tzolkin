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
