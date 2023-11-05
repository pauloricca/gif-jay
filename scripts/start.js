const { exec } = require("child_process");

var processingProcess, serverProcess;

const startProjection = () => {
  processingProcess = exec(
    `processing-java --sketch=${__dirname}/../projection --run`
  );
};

const startServer = () => {
  serverProcess = exec(`cd ${__dirname}/.. && npm run start-server`);
};

const isProcessRunning = (pid, callback) => {
  exec(`ps cax | grep ${pid}`, (_, stdout, __) => callback(!!stdout));
};

const restart = () => {
    try {
        processingProcess.kill();
    } catch (e) {}
    try {
        serverProcess.kill();
    } catch (e) {}
    startProjection();
    startServer();
}

startProjection();
startServer();

setInterval(() => {
    isProcessRunning(processingProcess.pid, (isRunning) => !isRunning && restart());
    isProcessRunning(serverProcess.pid, (isRunning) => !isRunning && restart());
}, 1000);
