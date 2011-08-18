function resetInput(){
  $("#upload-input").replaceWith("<input id='upload-input' type='file' name='file'/>");
  $("#upload-input").blur(resetInput);
};
function sendFile(){
  
};
function uploadIt(){
  sendFile();
  resetInput();
  $("span").text("file uploaded").show().fadeOut(1000);
};

$(function() {
  $("#upload-input").change(uploadIt);
});
