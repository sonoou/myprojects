function checkEmpty(){
  let flag = true;
  for( const element of [email,pass]){
    if(element.value.length < 1 ){
      message.innerHTML = `${element.placeholder} can not be empty`;
      message.style.animationName = "showmessage";
      flag = false;
      break;
    }
    else{
      message.style.animationName = "hidemessage";
      flag = true;
    }
  }
  return flag;
}


document.querySelector("#submit").addEventListener("focus", () => {
  checkEmpty();
});

function togglebutton(input, button){
    if(input.value === "false"){
        input.value = "true";
        button.style.backgroundColor = "rgb(0, 136, 255)";
        button.childNodes[1].style.animationName = "on";
    }
    else{
        input.value = "false";
        button.childNodes[1].style.animationName = "off";
        button.style.backgroundColor = "rgb(124, 125, 125)";
    }
}

const button = document.querySelector("#togglebutton");
button.addEventListener("click", () => {
    let inputVal = document.querySelector("#cooki");
    togglebutton(inputVal, button);
});

document.querySelector("#submit").addEventListener("click", () => {
  let cooki = document.querySelector("#cooki");
  const xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = function(){
    if(xmlhttp.readyState == 4){
      if(xmlhttp.responseText.includes("invalid")){
        let message = document.querySelector("#message");
        message.innerHTML = "Wrong: Passsword or username or phone";
        if(message.style.aimationName != "showmessage"){
          message.style.animationName = "showmessage";
        }
      }
      else{
        window.location.assign(xmlhttp.responseText);
      }
    }
  }
  if(checkEmpty()){
    xmlhttp.open("POST",`Action.jsp?cooki=${cooki.value}&user=${email.value}&pass=${pass.value}&url=Validate`,true);
    xmlhttp.send();
  }
});



function checkPhoneEmail(fieldObj, event){
  const specialChar = "`~!#$%^&*()-_+={}[]|\\:;\"'<>?,/ ";
  let str = fieldObj.value;
  let charresult;
  if(event.key == "Shift" || event.key == "Enter"){
    // none
  }
  else{
    charresult = specialChar.includes(event.key);
    message.style.animationName = "hidemessage";
  }
  if(charresult){
    fieldObj.value = str.substr(0,str.length-1);
    message.innerHTML = "Special Characters are not allowed";
    message.style.animationName = "showmessage";
  }
}