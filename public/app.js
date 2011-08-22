function xmlHttpPost(action,data, callback){
  var req = false;
  // Mozilla/Safari
  if (window.XMLHttpRequest) {
    req = new XMLHttpRequest();
  }
  // IE
  else if (window.ActiveXObject) {
    req = new ActiveXObject("Microsoft.XMLHTTP");
  }
  req.open('POST', action, true);
  req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
  req.onreadystatechange = function() {
    if (req.readyState == 4 && req.status == 200) {
      callback(req.responseText);
    }
  }
  req.send(data);
};
function createList(json){
  var div  = document.getElementById('image-list');
  var data = JSON.parse(json);
  for ( var i=data.length-1; i>=0; --i ){
    var e = data[i];
    addListEntry(div,e.link, e.filename);
  }
};
function sendDelete(){
  var name = "doo";
  xmlHttpPost('/remove','filename=' + name + '&_method=delete',function(json){})
};
function addListEntry(list, link, name){
  var item = document.createElement('li');
  var imageLink = document.createElement('a');
  imageLink.innerHTML = '<a class="link" href="' + link + '">' + name + '</a>'
  var removeLink = document.createElement('a');
  removeLink.innerHTML = '<a class="remove-link" href="" data-name="' + name + '" data-action="/remove">remove</a>';
  removeLink.onclick = sendDelete;
  var removeForm = document.createElement('form');
  removeForm.innerHTML = '<form action="/remove" method="post">' +
                            '<input name="filename" type="hidden" value="' + name + '">' +
                            '<input name="_method" type="hidden" value="delete">' +
                            '<input type="submit" value="remove">' +
                          '</form>'
  item.appendChild(imageLink);
  item.appendChild(removeLink);
  list.appendChild(item);
};

function createUploader(){
  var uploader = new qq.FileUploader({
    element: document.getElementById('file-uploader'),
    action: '/',
    allowedExtensions: ['jpg','jpeg','png'],
    onComplete: function(id, fileName, responseJSON){
      var list = document.getElementById('image-list');
      if(responseJSON.success === true){
        addListEntry(list,responseJSON.link,fileName);
      }
    },
    messages: {
      typeError: "{file} has invalid extension. Only {extensions} are allowed.",
      sizeError: "{file} is too large, maximum file size is {sizeLimit}.",
      minSizeError: "{file} is too small, minimum file size is {minSizeLimit}.",
      emptyError: "{file} is empty, please select files again without it.",
      onLeave: "The files are being uploaded, if you leave now the upload will be cancelled."
    },
    showMessage: function(message){
      alert(message);
    }
  });
}

// in your app create uploader as soon as the DOM is ready
// don't wait for the window to load
window.onload = createUploader;

xmlHttpPost('/filelist','test=true',createList);
