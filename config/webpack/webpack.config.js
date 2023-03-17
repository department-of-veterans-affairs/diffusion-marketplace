// use the new NPM package name, `shakapacker`.
// merge is webpack-merge from https://github.com/survivejs/webpack-merge
const { webpackConfig, merge } = require('shakapacker')
const sass = require('./loaders/sass')

const options = {
    resolve: {
        extensions: ['.css', '.scss', '.js']
    }
}

// Copy the object using merge b/c the baseClientWebpackConfig is a mutable global
// If you want to use this object for client and server rendering configurations,
// having a new object is essential.
module.exports = merge(sass, options, webpackConfig)
