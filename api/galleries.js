const fs = require("fs");
const { GALLERIES_ROOT_PATH } = require("./constants");
const { playGallery } = require("./processing");

exports.getGalleries = (_, response) => {
  fs.readdir(GALLERIES_ROOT_PATH, { withFileTypes: true }, (err, files) => {
    if (err) {
      console.error(err)
    } else {
      const galleries = files
        .filter(item => item.isDirectory())
        .map(dir => dir.name);

      response.send({ galleries });
    }
  })
};

exports.getGallery = (request, response) => {
  var gallery = request.params.gallery;

  fs.readdir(GALLERIES_ROOT_PATH + gallery, (err, files) => {
    if (err) {
      console.error(err)
    } else {
      const gifs = files
        .filter(file => file.indexOf('.gif') > 0)
        .map(file => file);

      response.send({ gifs });
    }
  })
};

exports.playGallery = (request, response) => {
  playGallery(request.params.gallery);
  response.send();
};
