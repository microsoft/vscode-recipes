# Debugging TypeScript in a Docker Container

This recipe shows how to run and debug a VS Code TypeScript project in a Docker container.

The recipe assumes that you have a recent version of [Docker](https://www.docker.com) installed.

You can either follow the manual steps in the next section or you can 'clone' the setup from a repository:
```sh
git clone https://github.com/Microsoft/vscode-recipes.git
cd vscode-recipes/Docker-TypeScript
npm install
code .
```
Inside VS Code press 'F5' to start the debug session.
Then open a browser on localhost:3000 and watch the request counter increment every 3 seconds.

To learn what's going on, please read the following detailed explanation.

## Create Setup Manually

Create a new project folder 'server' and open it in VS Code. Inside the project create a folder `src` with a file `index.ts`:

```ts
import * as http from 'http';

let reqCnt = 1;

http.createServer((req, res) => {

  const message = `Request Count: ${reqCnt}`;

  res.writeHead(200, { 'Content-Type': 'text/html' });
  res.end(`<html><head><meta http-equiv="refresh" content="2"></head><body>${message}</body></html>`);

  console.log("handled request: " + reqCnt++);
}).listen(3000);

console.log('server running on port 3000');
```

This is a trivial http server that serves a self-refreshing page showing a request counter.

Add a `tsconfig.json` file in the `src` folder that tells the TypeScript compiler that we need source maps and where to put them:

```ts
{
  "compilerOptions": {
    "outDir": "../dist",
    "sourceMap": true
  }
}
```

Add this `package.json` which lists the dependencies and defines some scripts for building and running the server:

```json
{
  "name": "server",
  "version": "0.0.0",
  "scripts": {
    "postinstall": "tsc -p ./src",
    "watch": "tsc -w -p ./src",
    "debug": "nodemon --watch ./dist --inspect=0.0.0.0:9222 --nolazy ./dist/index.js",
    "docker-debug": "docker-compose up",
    "start": "node ./dist/index.js"
  },
  "devDependencies": {
    "@types/node": "^6.0.50",
    "typescript": "^2.3.2",
    "nodemon": "^1.11.0"
  },
  "main": "./dist/index.js"
}
```

- The `postinstall` script uses the TypeScript compiler to translate the source into JavaScript in the 'dist' folder.
- The `watch` script runs the TypeScript compiler in 'watch' mode: whenever the TypeScript source is modified, it is transpiled into the 'dist' folder.
- The `debug` script uses 'nodemon' to watch for changes in the 'dist' folder and restart the node runtime in debug mode.
- The `docker-debug` script creates a docker image for debugging.
- The `start` script runs the server in production mode.

You can now run the server locally with these steps:
```sh
npm install
npm start
```
Then open a browser on localhost:3000 and watch the request counter increment every 3 seconds.

## Running in Docker

For running the server in a docker container we need a `Dockerfile` in the root of your project:

```dockerfile
FROM node:8-slim

WORKDIR /server

COPY . /server
RUN npm install

EXPOSE 3000
CMD [ "npm", "start" ]
```

This creates the docker image from a node runtime image, copies the VS Code project into a `/server` folder and runs `npm install` to load the required npm modules and the 'build' script to build the server. Finally it starts the server via the npm 'start' script.

You can build and run a docker image 'server' with these steps:

```sh
docker build -t server .
docker run -p 3000:3000 server
```

## Debugging in Docker

For debugging this server in the Docker container we could just make node's debug port 9222 available (via the '-p' flag from above) and attach VS Code to this.

But for a faster edit/compile/debug cycle we will use a more sophisticated approach by mounting the 'dist' folder of the VS Code workspace directly into the container running in Docker. Inside Docker we'll use 'nodemon' for tracking changes in the 'dist' folder and restart the node runtime automatically and in the VS Code workspace we'll use a watch task that automatically transpiles modified TypeScript source into the 'dist' folder.

Let's start with the 'watch' task by creating a `tasks.json` inside the `.vscode` folder:
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "tsc-watch",
      "command": "npm",
      "args": [ "run", "watch" ],
      "type":"shell",
      "isBackground": true,
      "group":"build",
      "problemMatcher": "$tsc-watch",
      "presentation":{
        "reveal": "always",
      }
    }
  ]
}
```
The `tsc-watch` task runs the npm `watch` script and registers as VS Code's 'build' command.
The build command will be automatically triggered whenever a debug session is started (but it can be triggered manually as well).

For the modified Docker setup we use 'docker-compose' because it allows us to override individual steps in the 'Dockerfile'.

Create a `docker-compose.yml` file side-by-side to the `Dockerfile`:

```yml
version: "2"

services:
  web:
    build: .
    command: npm run debug
    volumes:
      - ./dist:/server/dist
    ports:
      - "3000:3000"
      - "5858:5858"
```

Here we mount the `dist` folder of the workspace into the Docker container (which hides whatever was in that location before). And we replace the `npm start` command from CMD in the Dockerfile by `npm run debug`. In the ports section we add a mapping for the node.js debug port.

The `docker-compose.yml` will be used when running the docker-compose from the command line:
```sh
docker-compose up
```

For attaching the VS Code node debugger to the server running in the Docker container we use this launch configuration:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "attach",
      "name": "Attach to Docker",
      "preLaunchTask": "tsc-watch",
      "protocol":"auto",
      "port": 5858,
      "restart": true,
      "localRoot": "${workspaceFolder}/dist",
      "remoteRoot": "/server/dist",
      "outFiles": [
        "${workspaceFolder}/dist/**/*.js"
      ],
      "skipFiles": [
        "<node_internals>/**/*.js",
      ]
    }
  ]
}
```
- As a `preLaunchTask` we run the watch task that transpiles TypeScript into the `dist`folder. Since this task runs in background, the debugger does not wait for its termination.
- The `localRoot`/`remoteRoot` attributes are used to map file paths between the docker container and the local system: `remoteRoot` is set to `/server` because that's the absolute path of the folder where the program lives in the docker container.
- The `restart` flag is set to `true` because VS Code should try to re-attach to node.js whenever it loses the connection to it. This typically happens when nodemon detects a file change and restarts node.js.

After running "Attach to Docker" you can debug the server in TypeScript source:
- Set a breakpoint in `index.ts:9` and it will be hit as soon as the browser requests a new page,
- Modify the message string in `index.ts:7` and after you have saved the file, the server running in Docker restarts and the browser shows the modified page.

> **Please note**: when using Docker on Windows, modifying the source does not make nodemon restart node.js. On Windows nodemon cannot pick-up file changes from the mounted `dist` folder because of this [issue](https://github.com/docker/for-win/issues/56). The workaround is to add the `--legacy-watch` flag to nodemon in the `debug` npm script:
```json
"debug": "nodemon --legacy-watch --watch ./dist --inspect=0.0.0.0:5858 --nolazy ./dist/index.js",
```

## Further Simplifying the Debugging Setup

> **Please note**: the following requires VS Code 1.13.0

Instead of launching Docker from the command line and then attaching the debugger to it, we can combine both steps in one launch configuration:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Launch in Docker",
      "preLaunchTask": "tsc-watch",
      "runtimeExecutable": "npm",
      "runtimeArgs": [ "run", "docker-debug" ],
      "port": 5858,
      "restart": true,
      "timeout": 60000,
      "localRoot": "${workspaceFolder}/dist",
      "remoteRoot": "/server",
      "outFiles": [
        "${workspaceFolder}/dist/**/*.js"
      ],
      "skipFiles": [
        "<node_internals>/**/*.js",
      ],
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen"
    }
  ]
}
```
- Here we set the `docker-debug` npm script as the runtime executable and its arguments. The node debugger doesn't care about what is used as the `runtimeExecutable` as long as it opens a debug port that the node debugger can attach to.
- We use the `integratedTerminal` because we want to be able to kill docker-compose by using 'Control-C'. This is not possible with the Debug Console.
