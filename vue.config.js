const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  configureWebpack: (config) => {

    config.module.rules.push({

      test: /\.glsl$/,

      use: [

        {

          loader: "@bartkus/glsl-loader",

        },

      ],

    });

  },
  transpileDependencies: true
})
