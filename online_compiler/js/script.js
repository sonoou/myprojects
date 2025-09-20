let status = document.querySelector("#status");
const editor = document.querySelector("#editor");
const runbutton = document.querySelector("#run");

runbutton.addEventListener("click",() => {
  let code = "";
  console.log(editor.value.toString());
  const editornodes = editor.childNodes;
  let no = 0;
  for(let str of editornodes){
    if(`${str.nodeValue}` !== "null"){
      no++;
      code = code + `&line${no}=${str.nodeValue}`;
      console.log(code);
    }
  }
  postRequest(`compile.jsp?no=1${code}`);
});

function changeFont(size){
  editor.style.fontSize = size+"px";
}

editor.addEventListener("paste", event => {
  event.preventDefault();
  const text = (event.clipboardData || window.clipboardData).getData('text');
  const selection = window.getSelection();
  const range = selection.getRangeAt(0);
  const strarray = text.split("\n");
  console.log(strarray);
  range.deleteContents();
  for(let i=strarray.length-1;i>=0;i--){
    range.insertNode(document.createElement('br'))
    range.insertNode(document.createTextNode(strarray[i]));
  }
  selection.removeAllRanges();
});

// editor.addEventListener("keydown", event => {
//   if(event.key === 'Enter'){
//     event.preventDefault();
//     const br = document.createElement('br');
//     const selection = window.getSelection();
//     const range = selection.getRangeAt(0);
//     range.deleteContents();
//     range.insertNode(br);
//     range.setStartAfter(br);
//     range.setEndAfter(br);
//     selection.removeAllRanges();
//     selection.addRange(range);
//   }
//   if(event.key === 'Tab'){
//     event.preventDefault();
//     const br = document.createTextNode('\t');
//     const selection = window.getSelection();
//     const range = selection.getRangeAt(0);
//     range.deleteContents();
//     range.insertNode(br);
//     range.setStartAfter(br);
//     range.setEndAfter(br);
//     selection.removeAllRanges();
//     selection.addRange(range);
//   }
// });

function postRequest(url){
  let xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = function(){
    if(xmlhttp.readyState == 0){
      document.querySelector("#status").value = "Taking your code";
    }
    if(xmlhttp.readyState == 1){
      document.querySelector("#status").value = "Sending to server";
    }
    if(xmlhttp.readyState == 2){
      document.querySelector("#status").value = "Sent!";
    }
    if(xmlhttp.readyState == 3){
      document.querySelector("#status").value = "Receiving output";
    }
    if(xmlhttp.readyState == 4){
      document.querySelector("#status").value = "Received!"
      document.querySelector("#output").innerHTML = xmlhttp.responseText.trim();
      // console.log(xmlhttp.responseText.trim());
    }
  }
  xmlhttp.open("POST",url,true);
  xmlhttp.send();
}