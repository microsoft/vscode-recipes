This recipe shows how to run and debug a VS Code TypeScript project in a Docker container.

Create a new project folder 'server' and open it in VS Code. Inside the project create a folder `src` with a file `index.ts`:

```ts
import * as http from 'http';

let reqCnt = 1;

http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/html' });
  res.end(`<html><head><meta http-equiv="refresh" content="3"></head><body>Request Count : ${reqCnt}</body></html>`);
  console.log("handled request: " + reqCnt++);
}).listen(3000);
```

This is a trivial http server that serves a self-refreshing page showing a request counter.

Add a `tsconfig.json` file in the `src` folder that tells the TypeScript compiler that we need source maps and where to put them:

```ts
{
  "compilerOptions": {
    "target": "es6",
    "module": "commonjs",
    "moduleResolution": "node",
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
    "build": "tsc -p ./src",
    "watch": "tsc -w -p ./src",
    "debug": "nodemon --watch ./dist --debug=5858 --nolazy ./dist/index.js",
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

- The `build` script uses the TypeScript compiler to translate the source into JavaScript in the 'dist' folder.
- The `watch` script runs the TypeScript compiler in 'watch' mode: whenever the TypeScript source is modified, it is transpiled into the 'dist' folder.
- The `debug` script uses 'nodemon' to watch for changes in the 'dist' folder and restart the node runtime in debug mode.
- The `docker-debug` script creates a docker image for debugging.
- The `start` script runs the server in production mode.

You can now run the server locally with these steps:
```
npm install
npm run build
npm run start
```
Then open a browser on localhost:3000 and watch the request counter increment every 3 seconds.

For running the server in a docker container we need a `Dockerfile` in the root of your project:

```dockerfile
FROM node:6.5.0-slim

WORKDIR /server

COPY . /server
RUN npm install
RUN npm run build

CMD [ "npm", "start" ]
```

This creates the docker image from a node runtime image, copies the VS Code project into a `/server` folder and runs `npm install` to load the required npm modules and the 'build' script to build the server. Finally it starts the server via the npm 'start' script.

You can build and run a docker image 'server' with these steps:

```
docker build -t server .
docker run -p 3000:3000 server
```

For debugging this server in the Docker container we could just make node's debug port 5858 available (via the '-p' flag) and attach VS Code to this.

But for a faster edit/compile/debug cycle we will use a more sophisticated approach by mounting the 'dist' folder of the VS Code workspace directly into the container running in Docker. Inside Docker we'll use 'nodemon' for tracking changes in the 'dist' folder and restart the node runtime automatically and in the VS Code workspace we'll use a watch task that automatically transpiles modified TypeScript source into the 'dist' folder.

Let's start with the 'watch' task by creating a `task.json` inside the `.vscode` folder:
```ts
{
  "version": "0.1.0",
  "tasks": [
    {
      "taskName": "tsc-watch",
      "command": "npm",
      "args": [ "run", "watch" ],
      "isBackground": true,
      "isBuildCommand": true,
      "problemMatcher": "$tsc-watch",
      "showOutput": "always"
    }
  ]
}
```
The 'tsc-watch' task runs the npm 'watch' script and registers as VS Code's 'build' command.
The build command will be automatically triggered whenever a debug session is started (but it can be triggered manually as well).

For the modified Docker setup we use 'docker-compose' because it allows to override individual steps in the 'Dockerfile'.

Create a `docker-compose.yml` file side-by-side to the `Dockerfile`:

```yml
version: "2"

services:
  web:
    build: .
    command: npm run nodemon
    volumes:
      - ./dist:/server/dist
    ports:
      - "3000:3000"
      - "5858:5858"
```

Here we mount the 'dist' folder of the workspace into the Docker container (which hides whatever was in that place before). And we replace the 'npm start' command from CMD in the Dockerfile by 'npm run nodemon'. In the ports section we add the node.js debug port.

The `docker-compose.yml` will be used when running the `docker-compose up` from the command line.

For attaching the VS Code node debugger to the server running in the Docker container create this launch configuration:

```ts
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "attach",
      "name": "Attach to Docker",
      "preLaunchTask": "tsc-watch",
      "protocol": "legacy",
      "port": 5858,
      "restart": true,
      "localRoot": "${workspaceRoot}",
      "remoteRoot": "/server",
      "outFiles": [
        "${workspaceRoot}/dist/**/*.js"
      ]
    },
  ]
}
```
- The `localRoot`/`remoteRoot` attributes are used to map file paths between the docker container and the local system:
`remoteRoot` is set to `/server` because that's the absolute path of the folder where the program lives in the docker container.

- The `restart` flag is set to `true` because VS Code should try to re-attach to node.js whenever it loses the connection to it. This typically happens when nodemon detects a file change and restarts node.js.

After running "Attach to Docker" you can debug the server in TypeScript source:
- set a breakpoint in `index.ts:9` and it will be hit as soon as the browser requests a new page,
- modify the message string in `index.ts:7` and after you have saved the file, the server running in Docker restarts and the browser shows the modified page.

Instead of launching Docker from the command line and then attaching the debugger to it, we can combine both steps in one launch configuration:
```ts
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Launch in Docker",
      "preLaunchTask": "tsc-watch",
      "protocol": "legacy",
      "runtimeExecutable": "npm",
      "runtimeArgs": [ "run", "docker-debug" ],
      "port": 5858,
      "restart": true,
      "timeout": 30000,
      "localRoot": "${workspaceRoot}",
      "remoteRoot": "/code",
      "outFiles": [
        "${workspaceRoot}/dist/**/*.js"
      ],
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen"
    }
  ]
}
```

- here we set the 'docker-debug' npm script as the runtime executable and its arguments. The node debugger doesn't care about what is used as the `runtimeExecutable` as long as it opens a debug port that the node debugger can attach to.

- we use the "integratedTerminal" because