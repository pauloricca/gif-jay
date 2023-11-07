$(() => {
  $("#search-btn").on('click', loadNewImages);
  $("#select-btn").on('click', addToSelection);
  $("#remove-btn").on('click', removeFromSelection);
  $("#save-btn").on('click', save);
  $("#play-btn").on('click', play);
  $("#query-input").on("keypress", (e) => { e.which == 13 && loadNewImages(); return true; }  );
  $("body").on("click", ".image", select)
  $("#galleries").on('change', openGallery);
  $("#colour").on('change', changeColour);
  showSelection();
  loadGalleries();
});

var lastQuery = '';
var selectedGallery = '';

var loadNewImages = () => {
  var queryTerm = $("#query-input").val();
  showGallery();
  if (lastQuery !== queryTerm) {
    $("#gallery").empty();
    $.getJSON("api/gifsearch/" + queryTerm, (data) =>
      $.each(data.images, (_, src) =>
        $("<div class='image'><img src='" + src + "'/></div>").appendTo("#gallery")
      )
    );
    lastQuery = queryTerm;
  }
};

var play = () => {
  if (selectedGallery) {
    $.getJSON("api/galleries/" + selectedGallery + '/play');
    loadGalleries();
  }
};

var select = ({ target }) => {
  $(target).closest('.image').toggleClass("selected");
};

var clearGallery = () => {
  $("#gallery").empty();
};

var showGallery = () => {
  $("#selection, #remove-btn, #save-btn, #play-btn").hide();
  $("#gallery, #select-btn").show();
};

var showSelection = () => {
  $("#selection, #remove-btn, #save-btn").show();
  $("#gallery, #select-btn, #play-btn").hide();
  $('#galleries option[value=""]').prop('selected', true);
};

var addToSelection = () => {
  $("#gallery .selected").clone().appendTo($("#selection"));
  $(".selected").removeClass("selected");
  showSelection();
};

var removeFromSelection = () => {
  $("#selection .selected").remove();
};

var save = () => {
  var name = '';
  do {
    name = prompt("Save as:");
  } while (name === '');

  if (name != null) {
    var payload = { images: [] };
    $("#selection img").map((_, el) => payload.images.push($(el).attr("src")))

    $.ajax({
      type: "POST",
      url: "api/save/" + name,
      data: JSON.stringify(payload),
      contentType: "application/json",
      dataType: "json",
    }).done(() => {
      loadGalleries();
      alert("Saved.");
    });
  }
};

var loadGalleries = () => {
  $("#galleries").empty();
  $("<option>", { value: '', text: '-- Galleries --' }).appendTo("#galleries")
  $.getJSON("api/galleries/", (data) =>
    $.each(data.galleries, (_, gallery) =>
      $("<option>", { value: gallery, text: gallery }).appendTo("#galleries")
    )
  );
};

var openGallery = () => {
  selectedGallery = $('#galleries').find(":selected").val();
  if (selectedGallery) {
    clearGallery();
    showGallery();
    $.getJSON("api/galleries/" + selectedGallery, (data) =>
      $.each(data.gifs, (_, gif) =>
        $("<div class='image'><img src='gif/" + selectedGallery + '/' + gif + "'/></div>").appendTo("#gallery")
      )
    );
    $("#play-btn").show();
  }
}

var changeColour = () => {
  selectedColour = $("#colour").find(":selected").val();
  if (selectedColour) {
    $.getJSON("api/setting/colour/" + selectedColour);
  }
  $("#colour").val("");
}
