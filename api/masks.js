const fs = require("fs");
const { MASKS_ROOT_PATH } = require("./constants");
const { playMask } = require("./processing");

exports.getMasks = (_, response) => {
  fs.readdir(MASKS_ROOT_PATH, (err, files) => {
    if (err) {
      console.error(err);
    } else {
      response.send({
        masks: files.filter(
          (file) =>
            file.toLowerCase().indexOf(".gif") >= 0 ||
            file.toLowerCase().indexOf(".jpeg") >= 0 ||
            file.toLowerCase().indexOf(".jpg") >= 0 ||
            file.toLowerCase().indexOf(".png") >= 0
        ),
      });
    }
  });
};

exports.playMask = (request, response) => {
  playMask(request.params.mask);
  response.send();
};
