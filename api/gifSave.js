const https = require("https");
const http = require("http");
const fs = require("fs");
//const path = require("path");
const processingPort = 10002;

const gifSave = (request, response) => {
  var dir = '';
  var tries = '';
  let name = ''
  console.log('start');
  do {
    name = request.params.name + tries;
    console.log('trying directory ' + name);
    dir = __dirname + "/../projection/data/" + name + '/';
    tries = tries === '' ? 2 : tries + 1;
  } while (fs.existsSync(dir));

  console.log(dir);

  fs.mkdirSync(dir);

  
  // if (!fs.existsSync(dir)) {
  //   fs.mkdirSync(dir);
  // } else {
  //   fs.readdir(dir, (err, files) => {
  //     if (!err) for (const file of files) {
  //       console.log('removing ' + path.join(dir, file));
  //       fs.unlink(path.join(dir, file), () => {});
  //     }
  //   });
  // }

  let nDowloads = 0;
  request.body.images.forEach((url, index) => {
    try {
      const file = fs.createWriteStream(dir + index + ".gif");
      https.get(url, (resp) => {
        resp.pipe(file);
        file.on("finish", () => {
          file.close();
          console.log(index + " download Completed");
          nDowloads++;
          if (nDowloads === request.body.images.length) {
            console.log("All downloads finished");
            //http.post(processingUrl);
            const post_options = {
              hostname: "localhost",
              port: processingPort,
              path: "/upload",
              method: "POST",
              headers: {
                "Content-Type": "application/json",
                "Content-Length": Buffer.byteLength(name),
              },
            };
            try {
              // Set up the request and post the dir name
              var post_req = http.request(post_options);
              post_req.shouldKeepAlive = false
              request.on('error', function(err) {
                console.log('error completing request to Processing');
              });
              post_req.write(name);
              post_req.end();
            } catch (e) {
              console.log('error completing request to Processing');
            }
          }
        });
      });
    } catch (e) {
      console.log('error downloading gif');
    }
  });

  response.write('ok');
};

module.exports = gifSave;
