const { exec } = require("child_process");

var projectionProcess, serverProcess;

const startProjection = () => {
  projectionProcess = exec(
    `processing-java --sketch=${__dirname}/../projection --run`
  );
};

const startServer = () => {
  serverProcess = exec(`cd ${__dirname}/.. && npm run start-server`);
};

const isProcessRunning = (pid, callback) => {
  exec(`ps cax | grep ${pid}`, (_, stdout, __) => callback(!!stdout));
};

startProjection();
startServer();

setInterval(() => {
    isProcessRunning(projectionProcess.pid, (isRunning) => {
        if (!isRunning) {
            try {
                projectionProcess.kill();
                startProjection();
            } catch (e) {}
        }
    });
    isProcessRunning(serverProcess.pid, (isRunning) => {
        if (!isRunning) {
            try {
                serverProcess.kill();
                startServer();
            } catch (e) {}
        }
    });
}, 1000);
