const https = require("https");
const fs = require("fs");
const ffmpegInstaller = require("@ffmpeg-installer/ffmpeg");
const ffprobe = require("@ffprobe-installer/ffprobe");
const { GALLERIES_ROOT_PATH } = require("./constants");
const { playGallery } = require("./processing");


const gifSave = (request, response) => {
  var dir = '';
  var tries = '';
  let name = ''
  console.log('saving...');
  do {
    name = request.params.name + tries;
    console.log('trying directory ' + name);
    dir = GALLERIES_ROOT_PATH + name + '/';
    tries = tries === '' ? 2 : tries + 1;
  } while (fs.existsSync(dir));

  fs.mkdirSync(dir);

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
        console.log("Video " + index + " convertion complete");
        finishedProcessing();
      })
      .on("error", (e) => console.log(e))
      .run();
  }

  const finishedProcessing = () => {
    nCompletedFiles++;
    if (nCompletedFiles === request.body.images.length) {
      console.log("Done. Sending to Processing.");
      playGallery(name);
    }
  }

  request.body.images.forEach((url, index) => {
    const gifPath = dir + index + ".gif";

    // Gif from another gallery?
    if (url.indexOf('gif/') === 0) {
      fs.copyFileSync(GALLERIES_ROOT_PATH + url.substring(4), gifPath);
      console.log("Gif " + index + " move complete");
      postProcessDownload(index);
    } else {
      try {
        const file = fs.createWriteStream(gifPath);
        https.get(url, (resp) => {
          resp.pipe(file);
          file.on("finish", () => {
            file.close();
            console.log("Gif " + index + " download complete");
            postProcessDownload(index);
          });
        });
      } catch (e) {
        console.log('error downloading gif');
      }
    }
  });

  response.write('ok');
};

module.exports = gifSave;
