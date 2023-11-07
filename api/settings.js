const { setSetting } = require("./processing");

exports.setSetting = (request, response) => {
  console.log(request.params.setting, request.params.value);
  setSetting(request.params.setting, request.params.value);
  response.send();
};
