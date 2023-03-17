module.exports = {
    module: {
        rules: [
            {
                test: /\.s[ac]ss$/i,
                use: [
                    'style-loader',
                    {
                        loader: "css-loader",
                        options: {
                            sourceMap: true,
                        }
                    },
                    {
                        loader: "sass-loader",
                        options: {
                            // Prefer `dart-sass`
                            implementation: require("sass"),
                            sassOptions: {
                                includePaths: [
                                    "./node_modules/@uswds",
                                    "./node_modules/@uswds/uswds/packages",
                                    "./app/assets/stylesheets"
                                ],
                            },
                        }
                    }
                ],
            },
        ]
    },
}