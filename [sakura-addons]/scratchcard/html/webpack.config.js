const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const CopyPlugin = require('copy-webpack-plugin')

module.exports = {
    mode: 'production',
    entry: './src/index.js',
    stats: 'minimal',
    module: {
        rules: [
            {
                test: /\.(js|jsx)$/,
                exclude: /node_modules/,
                loader: 'babel-loader',
                options: {
                    presets: ['@babel/preset-react']
                }
            }
        ]
    },
    plugins: [
        new HtmlWebpackPlugin({template: './src/index.html'}),
        new CopyPlugin({
            patterns: [
              { from: "./src/assets", to: "assets" },
              { from: "./src/index.css", to: "index.css" }
            ],
        }),
    ],
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'app.js',
        clean: true
    },
    performance: {
        hints: false
    },
    // devtool: 'inline-source-map'
}