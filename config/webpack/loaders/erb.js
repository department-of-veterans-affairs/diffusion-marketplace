module.exports = {
    module: {
        rules: [
            {
                test: /\.erb$/,
                enforce: "pre",
                exclude: /node_modules/,
                loader: "rails-erb-loader",
                options: {
                    runner: (/^win/.test(process.platform) ? 'ruby ' : '') + 'bin/rails runner'
                }
            }
        ]
    }
}