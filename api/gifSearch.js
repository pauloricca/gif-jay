var GphApiClient = require("giphy-js-sdk-core");

const gifSearch = (request, response) => {
  var query = request.params.query;

  const giphyClient = GphApiClient("nLul61o562oQHJABqxI4E1VlEBEO0Qx0");

  /// Gif Search
  giphyClient
    .search("gifs", { q: query })
    .then(({ data }) => {
      const images = data.map(
        (gifObject) => gifObject.images.downsized_large.url
      );

      response.send({ images });
    })
    .catch((err) => {});
};

module.exports = gifSearch;
