$(() => {
  $("#search-btn").on('click', loadNewImages);
  $("#add-to-selection-btn").on('click', addToSelection);
  $("#remove-from-selection-btn").on('click', removeFromSelection);
  $("#save-btn").on('click', save);
  $("#query-input").on("keypress", (e) => { e.which == 13 && loadNewImages(); return true; }  );
  $("body").on("click", ".image", select)
  showSelection();
});

var lastQuery = '';

var loadNewImages = () => {
  var queryTerm = $("#query-input").val();
  showGallery();
  if (lastQuery !== queryTerm) {
    $("#gallery").empty();
    $.getJSON("api/gifsearch/" + queryTerm, (data) =>
      $.each(data.images, (key, src) =>
        $("<div class='image'><img src='" + src + "'/></div>")
          .appendTo("#gallery")
      )
    );
    lastQuery = queryTerm;
  }
};

var select = ({ target }) => {
  $(target).closest('.image').toggleClass("selected");
};

var clearGallery = () => {
  $("#gallery").empty();
};

var showGallery = () => {
  $("#selection, #remove-from-selection-btn, #save-btn").hide();
  $("#gallery, #add-to-selection-btn").show();
};

var showSelection = () => {
  $("#selection, #remove-from-selection-btn, #save-btn").show();
  $("#gallery, #add-to-selection-btn").hide();
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
  var payload = { images: [] };
  $('#selection img').map(function(){
    payload.images.push($(this).attr('src'));
  });
  var name = prompt("Save as:");
  $.ajax({
    type: 'POST',
    url: "api/save/" + name,
    data: JSON.stringify(payload),
    contentType: "application/json",
    dataType: 'json'
});
};