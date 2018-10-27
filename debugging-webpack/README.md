# Debugging webpack application

This procedure is tested with: 
 - webpack 2.2.1 - `devtool` option set to `eval-source-map`
 - Google Chrome 70.0.3538.67 
 - Ubuntu 16.04 LTS
 
1. Make you sure you have installed [chrome debug extension](https://github.com/Microsoft/vscode-chrome-debug)
2. Open debug section in Visual Studio Code
3. click on "Configuration" selector and select "add Config (your project's name)"
4. Select "Chrome" as environment 

Edit the .vscode/launch.json as following: 

```
{
    "version": "0.2.0",
    "configurations": [
        {
          "type": "chrome",
          "request": "launch", // this launches a new browser's instance
          "name": "Launch Chrome against localhost",
          "url": "http://localhost:8081", // Your chrome URL 
          "webRoot": "${workspaceFolder}",
          "sourceMapPathOverrides": {
            "webpack:///*": "${workspaceRoot}/*" // indicate the src base folder, in my case the root of the project
          }
        }
    ]
}
```
After this you can launch your application with webpack and run the visual studio debugger entry. (Clicking on the play button). 
A new browser's window will start

To verify the correctness of your settings, try to put a breakpoint in your code, when the debugger is running. If your breakpoint becomes grey, maybe you did something wrong. 

## Troubleshooting
Webpack can be configured in many ways.

Here some hints to check your configuration. 
 - Try to check how the files are mapped in chrome dev tools and try to edit `sourceMapPathOverrides` accordingly to the path of your files
 - `devtool` configuration in webpack need to be have source maps. This has `'source-map'`. If your project is big, you may evaluate to use `'eval-source-map'`, `'inline-source-map'` or `'cheap-module-eval-source-map'` modes. 
 - Some webpack's versions seem to be affected by an issue with sourcemaps, at least using windows. You may need to add a configuration like this to work-around the problem: 
 ```
 output: {
  devtoolModuleFilenameTemplate(info) {
    return `file:///${info.absoluteResourcePath.replace(/\\/g, '/')}`;
  },
}
```
