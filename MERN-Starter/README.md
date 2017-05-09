# Developing the MERN Starter in VS Code

MERN is a scaffolding tool which makes it easy to build apps using Mongo, Express, React and NodeJS. The MERN Starter is a boilerplate project for building a universal React app.

This recipe shows how to run and debug the MERN Starter in VS Code.

## Create Starter project and open it in VS Code

- Make sure your MongoDB is running. For MongoDB installation guide see [this](https://docs.mongodb.com/v3.0/installation/).

- Visit [MERN v2.0](http://mern.io) and install the MERN Starter v2.0:
  ```bash
  git clone https://github.com/Hashnode/mern-starter.git
  cd mern-starter
  npm install
  ```

- Open the starter project in VS Code:
  ```
  code .
  ```

- We recommend to install these VS Code extensions:
  [Babelrc](https://marketplace.visualstudio.com/items?itemName=waderyan.babelrc), [Docker](https://marketplace.visualstudio.com/items?itemName=PeterJausovec.vscode-docker), [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint).

## Launch and Debug the Starter

In VS Code open the Debug viewlet and press the gear icon. A QuickPick UI appears and shows the available debugging environments. Select **Node.js**.

VS Code automatically detects a MERN based project and creates this launch configuration:

```js
{
    "type": "node",
    "request": "launch",
    "name": "Launch Program",
    "protocol": "inspector",
    "runtimeExecutable": "nodemon",
    "runtimeArgs": [
        "--inspect=9222"
    ],
    "program": "${workspaceRoot}/index.js",
    "port": 9222,
    "restart": true,
    "env": {
        "BABEL_DISABLE_CACHE": "1",
        "NODE_ENV": "development"
    },
    "console": "integratedTerminal",
    "internalConsoleOptions": "neverOpen"
}
```

This configuration closely follows the npm `start` script from the package.json and enables debugging support.

Instead of the `node` runtime executable, `nodemon` is used which watches file modifications and restarts the node program automatically. The `restart` attribute configures the VS Code node debugger to re-attach automatically whenever node terminates.

With this setup it is possible to edit the source while the server is running: source edits automatically trigger a rebuild and restart the server. Because these restarts are quite expensive, we recommend that you change VS Code's `files.autoSave` setting from `after delay` to any of the other values. With this saves no longer occur automatically.

The launch config uses the integrated terminal because `nodemon` is an interactive tool that reads from stdin and reading from stdin is not supported in the default debug console.

> Please note: there is an unfortunate redundancy (and potential inconsistency) between the `protocol`, `runtimeArgs`, and `port` attributes. If the value of `protocol` is changed to `legacy`, the values for `runtimeArgs` and `port` must be changed as well, otherwise a problematic inconsistency will occur. This redundancy can be eliminated after we have implemented this [feature](https://github.com/Microsoft/vscode/issues/26315).
