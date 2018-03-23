var path = require('path'),
    webpack = require('webpack'),
    BrowserSyncPlugin = require('browser-sync-webpack-plugin');

module.exports = {
  entry: "./app/main.coffee",
  devtool: "eval",
  output: {
    path: path.join(__dirname, "public"),
    filename: 'bundle.js'
  },
  plugins: [
    new BrowserSyncPlugin({
      host: 'localhost',
      port: 8080,
      server: { baseDir: ['public'] }
    })
  ],

  module: {
    loaders: [
      { test: /\.coffee$/, loader: 'coffee-loader'},
      {
        test: /\.cjsx$/,
        exclude: /node_modules/,
        loaders: ['coffee-loader', 'cjsx-loader']
      },
      { test: /\.scss$/, loaders: ['style-loader', 'css-loader', 'sass-loader']},
      { test: /\.json$/, loader: 'json-loader' }
    ]
  },

  resolve: {
    extensions: [".js", '.cjsx', ".coffee", ".scss", ".css"],
    alias: {
      React: path.resolve(__dirname, 'node_modules/react'),
      ReactDOM: path.resolve(__dirname, 'node_modules/react-dom')
    }
  },
  node: {
    fs: 'empty',
    net: 'empty',
    tls: 'empty'
  }
};
