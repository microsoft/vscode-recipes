# Chrome Debugging with Angular CLI

by [Sorokin Vladislav (@parabolabam)](https://github.com/parabolabam)

This recipe shows how to use the [Debugger for Chrome](https://github.com/Microsoft/vscode-chrome-debug) extension with VS Code to debug
an Angular application created via using [Webpack Dev Server](https://webpack.js.org/configuration/dev-server/) and [Angular 2+](https://angular.io/).

## Getting Started
****
- Make sure to have [Google Chrome](https://www.google.com/chrome) installed in its default location.

- Make sure to have version **3.1.4** or greater of the [Debugger for Chrome](https://marketplace.visualstudio.com/items?itemName=msjsdiag.debugger-for-chrome) extension installed in VS Code.

- Use [NPM](https://www.npmjs.com) to install [Angular CLI](https://cli.angular.io) version **6.0** or greater globally.

- Change to the newly created application directory and open VS Code.

    ```
    cd my-dream-app
    code .
    ```

## Configure launch.json File

- Click on the Debug icon in the Activity Bar of VS Code to bring up the Debug view.
Then click on the gear icon to configure a launch.json file, selecting **Chrome** for the environment:

   ![add-chrome-debug](https://user-images.githubusercontent.com/2836367/27004175-77582668-4dca-11e7-9ce8-30ef3af64a36.png)

- Replace content of the generated launch.json with the following three configurations:

  ```json
  {
    "version": "0.2.0",
    "configurations": [
        {
            "type": "chrome",
            "request": "launch",
            "name": "webpack-dev-server",
            "url": "http://localhost:9090/",
            "webRoot": "${workspaceRoot}",
            "sourceMapPathOverrides": {
                "webpack:///./*": "${webRoot}/*",
                "webpack:///src/*": "${webRoot}/*",
                "webpack:///*": "*",
                "webpack:///./~/*": "${webRoot}/node_modules/*",
                "meteor://💻app/*": "${webRoot}/*"
            }
        },
        
    ]
}

> **Please note**: in **"webRoot"** field you should mention the root location of your angular app because webpack-dev-server works in memory and by default it uses the current project location.

> **Please note**: in **"url"** field make sure to turn the port into one you lunch you application on.

> **Please note**: Before you start debugging you should launch your app. It is something like:
```
test-user@test> NODE_ENV=webpack-dev-server webpack-dev-server --config 'path/to/config' -d --inline --hot --progress --port YOUR_PORT
```

  ## Start Debugging

- Set a breakpoint in component you want on the line that you want.

- Go to the Debug view, select the **'webpack-dev-server'** configuration, then press F5 or click the green play button to start 'Webpack Live Development Server'.

- A console window should appear where `webpack-dev-server` will run. Once the app is served, or if the task encounters an error, a browser window will appear. Use it to trigger your breakpoint!
- PROFIT!

