const nomnoml = require('nomnoml');

process.stdin.setEncoding('utf8');

let input = '';
process.stdin.on('data', chunk => {
    input += chunk;
});
process.stdin.on('end', () => {
    process.stdout.write(nomnoml.renderSvg(input));
});
