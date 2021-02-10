var fs = require('fs');
var nomnoml = require("nomnoml");

var [_, _, filename, outfile] = process.argv;

var svg = nomnoml.renderSvg(fs.readFileSync(filename, 'utf-8'));
fs.writeFileSync(outfile, svg);
