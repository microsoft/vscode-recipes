# Node.js debugging in VS Code with Nodemon

by [Kenneth Auchenberg](https://twitter.com/auchenberg)

This recipe shows how to use the built-in Node Debugger to debug Nodejs applications that's using [Nodemon](https://nodemon.io/).

Nodemon is a utility that will monitor for any changes in your source and automatically restart your server, and our Node debugger for VS Code supports automatic re-attaching to the Node process.

We recommend that you use our Node debugger in an `attach` configuration that's attaching to your Node process running.

## Getting Started

1. Make sure to have the latest version of VS Code installed.

2. This guide assumes that you are using the official sample app [nodejs-shopping-cart](https://github.com/gtsopour/nodejs-shopping-cart). Clone the repo to get started
    > 
    ```
    git clone git@github.com:gtsopour/nodejs-shopping-cart.git
    cd nodejs-shopping-cart
    npm install
    code .
    ```

## Configure Nodemon to run in Debug mode

Nodemon can be started in `debug mode` by using the `--inspect` flag like regular Node processes. The easiest way to enable the debug mode is to add an `npm debug script` that starts `nodemon` with the right flag.

Update your `package.json` section to:

```json
"scripts": {
    "start": "node ./bin/www",
    "debug": "nodemon --inspect ./bin/www"
}
```  

## Configure VS Code debugging with a launch.json file

1. Click on the Debugging icon in the Activity Bar to bring up the Debug view.
Then click on the gear icon to configure a launch.json file, selecting **Node** for the environment:

   ![configure_launch](configure_launch.png)

2. Replace content of the generated launch.json with the following two configurations:

    ```json
    {
        "version": "0.2.0",
        "configurations": [
            {
                "type": "node",
                "request": "attach",
                "name": "Node: Nodemon",
                "processId": "${command:PickProcess}",
                "restart": true,
                "protocol": "inspector",
            },
        ]
    }
    ```

 Notice the `restart` property. This setting is key as it tells our debugger to re-attach to the Node process, if the process get's terminated. Read more about the setting [here in our docs](https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_restarting-debug-sessions-automatically-when-source-is-edited).   

## Start your node app via your new NPM script

The next step is to start your Node app via your new `npm run debug` script. We can highly recommend using the integrated console in VS Code.

![terminal](terminal.png)

## Debugging the Node process
  
  1. Go to the Debug view, select the **'Node: Nodemon'** configuration, then press F5 or click the green play button.

  2. VS Code should now list all of your running node processes.

  ![processes](processes.png)

  3. Select the node process that's started with the `--inspect` flag.
  
  3. Go ahead and set a breakpoint in **routes/index.js** on `line 10` within the `route handler` function.

![breakpoint-main](breakpoint.png)

  4. Open your favorite browser and go to `http://localhost:3000`

  5. Your breakpoint should now be hit.

  6. Try to make a change to **routes/index.js**. 
  
  7. Nodemon should kick in after the change, and you should see VS Code re-attach to the newly spawned Node process automatically.

  8. Party 🎉🔥 

