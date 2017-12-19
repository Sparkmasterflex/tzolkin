var path = require('path');
var webpack = require('webpack');

module.exports = {
  entry: [
    './app/app'
  ],
  devtool: 'eval',
  output: {
    path: __dirname,
    filename: "index.js",
    library: 'tzolkin',
    libraryTarget: 'umd'
  },
  resolveLoader: {
    modules: ['..', 'node_modules']
  },
  plugins: [
    new webpack.DefinePlugin({
      // This has effect on the react lib size.
      "process.env": {
        NODE_ENV: JSON.stringify("production")
      }
    }),
    new webpack.IgnorePlugin(/vertx/),
    new webpack.IgnorePlugin(/configs/),
    new webpack.IgnorePlugin(/un~$/),
    new webpack.optimize.UglifyJsPlugin(),
  ],
  resolve: {
    extensions: ['.js', '.cjsx', '.coffee', '.css', '.scss'],
    alias: {
      React: path.resolve(__dirname, 'node_modules/react'),
      ReactDOM: path.resolve(__dirname, 'node_modules/react-dom'),
    }
  },
  externals: {
    'react':     "React",
    'react-dom': 'ReactDOM',
    'lodash':    'lodash',
  },
  module: {
    loaders: [
      { test: /\.cjsx$/, loaders: ['coffee-loader', 'cjsx-loader']},
      { test: /\.coffee$/, loader: 'coffee-loader' },
      { test: /\.scss$/, loaders: ['style-loader', 'css-loader', 'sass-loader'] },
      { test: /\.json$/, loader: 'json-loader' }
    ]
  },
  node: {
    fs: 'empty',
    net: 'empty',
    tls: 'empty'
  }
};
