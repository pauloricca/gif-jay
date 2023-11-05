const { Client } = require('node-osc');

const processingPort = 10002;

exports.playGallery = (name) => {
  const client = new Client('127.0.0.1', processingPort);
  client.send('/play', name, () => {
    client.close();
  });
}
