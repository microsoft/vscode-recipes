# Debugging React App

by [Akshay Avinash (@akshay11298)](https://github.com/akshay11298)

This recipe shows how to use the [Debugger for Chrome](https://github.com/Microsoft/vscode-chrome-debug) extension with VS Code to debug
a [React](https://reactjs.org/) application.

## Getting Started

- Download the latest version of [Google Chrome](https://google.com/chrome) .

- Download the latest version of [VS Code] (http://code.visualstudio.com/Download) .

- Download the latest version of the [Debugger for Chrome](https://marketplace.visualstudio.com/items?itemName=msjsdiag.debugger-for-chrome) extension for VS Code.

- Use [NPM](https://www.npmjs.com) to install latest version of [create-react-app](https://reactjs.org) globally.
    ```
    npm install -g create-react-app
    ```

- Use `create-react-app` to create a new React App
    ```
    create-react-app hello-world
    ```

- Change to the newly created application directory and open VS Code.

    ```
    cd hello-world
    code .
    ```

## Configure launch.json File

- Use the following config for `launch.json` in `.vscode` .

  ```json
  {
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Chrome",
            "type": "chrome",
            "request": "launch",
            "url": "http://localhost:3000",
            "webRoot": "${workspaceRoot}/src"
        }
    ]
  }
  ```

## Launch the app

- Start your react app `npm start`

- Press `F5` to start debugging.