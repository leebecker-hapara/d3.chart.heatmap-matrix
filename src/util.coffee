# Utility functions.
#

# Make an accessor/mutator function for the specified member variable.
#
exports.makeProp = (name, fn) ->
    (it) ->
        return this[name] unless it?
        this[name] = it
        fn.call(this, it) if fn?
        this

# Create a text-measuring function in the specified SVG context. `svgSel`
# must a d3.js selection on an SVG root or child element.
#
# TODO(jeanlauliac): extract this as a separate module, as it can be helpful
# for other charts.
#
exports.textRuler = (svgSel) ->
    onTmpText = (str, fn) ->
        el = svgSel.append('text').text str
        result = fn el
        el.remove()
        result
    ruler = ld.memoize (str) ->
        onTmpText str, (it) -> it.node().getComputedTextLength()
    ruler.extentOfChar = ld.memoize (char) ->
        if (char.length < 1)
            throw new Error 'char can\'t be empty'
        if (char.length > 1)
            throw new Error 'can get extent of a full string'
        onTmpText char, (it) -> it.node().getExtentOfChar 0
    ruler.onTmpText = onTmpText
    ruler

exports.layers = {}