const https = require("https");
const http = require("http");
const fs = require("fs");
const ffmpegInstaller = require("@ffmpeg-installer/ffmpeg");
const ffprobe = require("@ffprobe-installer/ffprobe");

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

  let nCompletedFiles = 0;

  const postProcessDownload = (index) => {
    const ffmpeg = require("fluent-ffmpeg")()
      .setFfprobePath(ffprobe.path)
      .setFfmpegPath(ffmpegInstaller.path);
    
    const gifPath = dir + index + ".gif";
    const vidPath = dir + index + ".mp4";

    // Sort this so that we only equest Processing when video convertions are complete
    // Convert to MP4
    ffmpeg
      .input(gifPath)
      .noAudio()
      .output(vidPath)
      .on("end", () => {
        console.log("Video convertion completed.");
        finishedProcessing();
      })
      .on("error", (e) => console.log(e))
      .run();
  }

  const finishedProcessing = () => {
    nCompletedFiles++;
    if (nCompletedFiles === request.body.images.length) {
      console.log("Done. Sending to Processing.");
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
        post_req.shouldKeepAlive = false;
        request.on("error", function (err) {
          console.log("error completing request to Processing");
        });
        post_req.write(name);
        post_req.end();
      } catch (e) {
        console.log("error completing request to Processing");
      }
    }
  }

  request.body.images.forEach((url, index) => {
    try {
      const gifPath = dir + index + ".gif";
      const file = fs.createWriteStream(gifPath);
      https.get(url, (resp) => {
        resp.pipe(file);
        file.on("finish", () => {
          file.close();
          console.log(index + " download completed");
          postProcessDownload(index);
        });
      });
    } catch (e) {
      console.log('error downloading gif');
    }
  });

  response.write('ok');
};

module.exports = gifSave;
