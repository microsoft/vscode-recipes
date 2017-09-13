# Electron debugging (main and renderer process)

by [Kenneth Auchenberg](https://twitter.com/auchenberg)

This recipe shows how to use the built-in Node Debugger and the [Debugger for Chrome](https://github.com/Microsoft/vscode-chrome-debug) extension with VS Code to debug [Electron](https://electron.atom.io) applications.

[Electron](https://electron.atom.io) applications can consists of two process types: A Main process type running in NodeJS and a render process type in Chromium. This means that you'll need to use two debugger instances within VS Code to debug both processes. This is the reason for why you both the built-in Node Debugger and the [Debugger for Chrome](https://github.com/Microsoft/vscode-chrome-debug).

**Note:** Please make sure you are using **Electron 1.7.4 or newer**, as our debuggers relies on the Inspector protocol.

## Getting Started

1. Make sure to have the latest version of VS Code installed.

2. Make sure to the latest version of [Debugger for Chrome](https://marketplace.visualstudio.com/items?itemName=msjsdiag.debugger-for-chrome) extension installed in VS Code.

3. This guide assumes that you are using the [electron-Quick-start project](https://github.com/electron/electron-quick-start). Clone the repo to get started
    > 
    ```
    git clone git@github.com:electron/electron-quick-start.git
    cd electron-quick-start
    npm install
    code .
    ```

## Configure launch.json File

- Click on the Debugging icon in the Activity Bar to bring up the Debug view.
Then click on the gear icon to configure a launch.json file, selecting **Chrome** for the environment:

   ![configure_launch](configure_launch.png)

- Replace content of the generated launch.json with the following two configurations:

  ```json
    {
        "version": "0.2.0",
        "configurations": [
            {
                "type": "node",
                "request": "launch",
                "name": "Electron: Main",
                "protocol": "inspector",
                "runtimeExecutable": "${workspaceRoot}/node_modules/.bin/electron",
                "runtimeArgs": [
                    "--remote-debugging-port=9223",
                    "."
                ],
                "windows": {
                    "runtimeExecutable": "${workspaceRoot}/node_modules/.bin/electron.cmd"
                }
            },
            {
                "name": "Electron: Renderer",
                "type": "chrome",
                "request": "attach",
                "port": 9223,
                "webRoot": "${workspaceRoot}",
                "timeout": 30000
            }
        ],
        "compounds": [
            {
                "name": "Electron: All",
                "configurations": [
                    "Electron: Main",
                    "Electron: Renderer"
                ]
            }
        ]
    }
  ```

  ## Debugging of the main process
  
  1. Go ahead and set a breakpoint in **main.js** on `line 16` within the `createWindow` function.

  2. Go to the Debug view, select the **'Electron: Main'** configuration, then press F5 or click the green play button.

  3. VS Code should now attempt to start your Electron app, and your breakpoint on `line 16` in `main.js` should be hit.

![breakpoint-main](breakpoint_main.png)

## Debugging of the renderer process

  1. Update the contents of `renderer.js` to
 ```javascript
    // This file is required by the index.html file and will
    // be executed in the renderer process for that window.
    // All of the Node.js APIs are available in this process.

    function test() {
        console.log('test')
    }

    test()
```

  2. While your debug session is running you can go to the Debug view, select the **'Electron: Renderer'**, which will connect VS Code to the Electron renderer process. 

  3. When connected go to `renderer.js` and set a breakpoint on `line 6`

  4. Now go to your Electron app window and  reload the page (View -> reload or CMD+R) to make sure the breakpoints are set.

  5. Your breakpoint in `renderer.js` on `line 6` should now be hit, and you can debug the Renderer process

![breakpoint-renderer](breakpoint_renderer.png)

## Debugging of both processes at the same time

Now that you have learned to debug both the Main and the Renderer process you can take advantage of our [`compounds configurations`](https://code.visualstudio.com/updates/v1_8#_multitarget-debugging) that enables you to start multiple debugging sessions at the same time. 

1. Go to the Debug view, select the **'Electron: All'**, which will connect VS Code to the both Main and Renderer process, and enable you to have a smooth development workflow.
2. Set breakpoints in any of the files like above.
3. Party 🎉🔥 

Note: This scenario is blocked by https://github.com/Microsoft/vscode-chrome-debug/issues/501



