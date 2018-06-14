#!/usr/bin/env node

const fs = require('fs')
const readline = require('readline')

let section = 'Favorites\\Files'

const lineReader = readline.createInterface({
    input: fs.createReadStream(process.argv[2]),
    output: fs.createWriteStream(process.argv[3]),
});
  
let start = false

lineReader.on('line', function (line) {
    if (line === '[Favorites\\Files]') {
        start = true
        this.output.write(`${line}\n`)
    }
    if (start === true) {
        if (line === '[FileFormats]') {
            start = false
            this.output.write(`${line}\n`)
        }
    } else {
        this.output.write(`${line}\n`)
    }
});

fs.unlinkSync(process.argv[2])
setTimeout(() => {
    fs.renameSync(process.argv[3], process.argv[2])
}, 100)