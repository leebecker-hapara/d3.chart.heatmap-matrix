# d3.chart.heatmap-matrix

A heatmap-matrix chart, given a matrix of range 0-1, this will populate a grid with cells filled according to their magnitude.

#[![Build Status](https://travis-ci.org/benbria/d3.chart.bubble-matrix.png?branch=master)](https://travis-ci.org/benbria/d3.chart.bubble-matrix)

#![bubble matrix](https://raw.githubusercontent.com/benbria/d3.chart.bubble-matrix/master/doc/screenshot.png)

  * useful to represent data on two dimensions, each datum's magnitude is represented by its color intensity
  * based on the powerful [Data-Driven Documents](http://d3js.org/) library;
  * based on the [d3.chart](http://misoproject.com/d3-chart/) abstraction,
    making the chart fairly flexible;
  * forked from d3.chart.bubble-matrix
  * can dynamically change data, keeping track or removed/added rows and
    columns and animating headers & bubbles.

## Install

With [npm]:

    npm install d3.chart.heatmap-matrix

You can then use [browserify](https://github.com/substack/node-browserify)
to use the library in your client-side javascript (recommended).

If you want to use the library with any other module system, you can generate
a standalone package with browserify. In the project directory:

    browserify src/chart.js --standalone

Additionally you should include the styles provided at the npm package
root:

  * `style.css` — mandatory CSS;
  * `theme.css` — theme CSS, can be replaced by a custom one.

## Sample Use

    browserify example.js > example.bundle.js

```html
<!-- index.html -->
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" type="text/css"
              href="d3.chart.heatmap-matrix.css">
        <link rel="stylesheet" type="text/css"
              href="d3.chart.heatmap-matrix.default.css">
    </head>
    <body>
        <div id='vis'>
        <script src="example.bundle.js"></script>
    </body>
</html>
```

```js
/*! example.js */
var d3 = require('d3');
var chart = require('d3.heatmap.heatmap-matrix');

var chart = d3.select('#vis').append('svg')
              .chart('HeatmapMatrix')
              .width(400).height(200);

chart.draw(require('./data'));
```

```js
/*! data.js */
module.exports = {
    columns: ['the', 'cake', 'is', 'a', 'lie'],
    rows: [
        {name: 'foo', values: [0.13, 0.84, 0.31, 0.75, .64]},
        {name: 'bar', values: [0.98, 0.13, 0.27, 0.17, 0.94]},
        {name: 'baz', values: [0.94, 0.39, 0.07, 0.25, 0.44]},
        {name: 'glo', values: [0.27, 0.47, 0.87, 0.62, 0.22]},
    ]
};
```

This will draw a simple heatmap matrix, with the default color palette.
You can find this example in the [example/minimal](/example/minimal) folder.

When nothing is configured except `width` and `height`, the library makes a lot
of assumptions about how is organized your data. However, you can customize a
lot data organization with the provided interface.

To play with the example in live, clone the repo, grab the packages `npm
install`, run `npm run example` and go to
[localhost:3000](http://localhost:3000/). See also
[CONTRIBUTING](CONTRIBUTING.md).

## API

### Methods

#### chart.draw(data)

  * `data` *Object* Data to represent.

Draw the chart.

### Properties

Each configuration function returns the current value of the property when
called with no argument, and sets the value otherwise.

#### chart.rows([fn])

  * `fn(data)` *Function* Called with the data, must return an *Array* of
    rows.

Required. Default: `function(d) { return d.rows; }`.

#### chart.rowHeader([fn])

  * `fm(datum)` *Function* Called for each row, must return a *String*
    to be displayed as the row header.

Required. Default: `function(d) { return d.name; }`.

#### chart.rowKey([fn])

  * `fn(datum)` *Function* Called for each row, must return a *String*
    that identifies uniquely the row.

When rows are updated by subsequent calls to `draw`, rows will be removed,
added; or updated/moved when a key match an existing row. Optional.

#### chart.rowData([fn])

  * `fn(datum)` *Function* Called for each row, must return an `Object`
    containing cell data for this row.

Required.

#### chart.columns([fn])

  * `fn(data)` *Function* Called with the data, must return an `Array`
    containing each column datum.

Note you don't specifically have to store the column array into the data
provided to `draw`. You can build on-the-fly the column data in this function
if you wish. For instance, in `example/example.js`, we build column information
from a range stored in the data:

```js
chart.columns(function (d) { return d3.range(d.dayHours[0],
                                             d.dayHours[1]); })
     .colKey(function(d) { return d; })
     .colHeader(utils.hourName)
```

Required. Default: `function(d) { return d.columns;}`.

#### chart.colHeader([fn])

  * `fn(datum)` *Function* Called for each column, must return a
    *String* to be displayed as the column header.

Required. Default: `function(d) { return d; }`.

#### chart.colKey([fn])

  * `fn(datum)` *Function* Called for each column, must return a
    *String* that identifies uniquely the column.

When columns and cells are updated by subsequent calls to `draw`, columns
will be removed, added; or updated/moved when a key match an existing column.
Optional.

#### chart.color([fn])

  * `fn(datum)` *Function* Called for each bubble, must return a
    *Number* driving the bubble color.

Note, if you want, you can return a fixed value and only use the size
feature of the bubbles; or, you can return a value correlated with the
size.

Required. Default: `function(d) { return d[1]; }`.

#### chart.colorScale([fn])

  * `fn(value)` *Function* Color scale used to translate color values to actual
    colors. Must return a color.

You may want to create the scale with d3.js, eg.

```js
var palette = ['#ff0000', '#00ff00', '#0000ff'];

chart.colorScale(d3.scale.quantize().domain([0,1])
                   .range(palette));
```

Required. A default color scale from red to blue is provided.

### Events

Listen to events with the method `on` of d3.chart.

#### margin(value)

  * `value` *Number* the margin width.
  * `this` the chart itself.

Sent when the left margin width changes. It is useful to align the SVG
element on your paragraphs. Example:

```js
var chart = d3.select('#vis').append('svg')
              .chart('BubbleMatrix');

chart.on('margin', function (value) {
    this.base.style('margin-left', '-' + value + 'px');
});
```

The value `base` in the chart is the root d3 selection, generally the SVG.

## Compatibility and Limitations

  * Tested on Chrome 30, Firefox 22 and IE10;
  * does not resize the headers font, if the chart is dynamically resized to be
    tiny, it may not be very good-looking (but you can change the font with CSS
    or via d3.chart layer events);
  * does not support — yet — slanted headers to accomodate long texts;
  * animations might become slow if you have a lot of cells displayed.

Please feel free to open pull requests to make any change.
See [CONTRIBUTING](CONTRIBUTING.md).
