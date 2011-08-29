var data;
function saveData(json){
  data = JSON.parse(json);
  $('#gallery').galleria({height:400,dataSource: data});
};
$(document).ready(
  $.post('/gallery-data',saveData)
)
