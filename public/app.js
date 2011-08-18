function createUploader(){
  var uploader = new qq.FileUploader({
    element: document.getElementById('file-uploader'),
    action: '/',
    debug: true,
    onComplete: function(id, fileName, responseJSON){
      alert(responseJSON.message);
    }
  });
}

// in your app create uploader as soon as the DOM is ready
// don't wait for the window to load
window.onload = createUploader;
