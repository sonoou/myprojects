const spchar = "`~!@#$%^&*()-_+={}[]|\\:;\"'<>?,./ ";
const numberseq = "0123456789";


function showError(msg){
  register.setAttribute("disabled","");
  message.innerHTML = `${msg}`;
  message.style.animationName = "showmessage";
}
function checkEmpty(){
  for(const element of [fname,email,contact,pass]){
    if(element.id === "fname"){
      if(element.value.length < 3){
        showError("Name should contain atleast 3 character");
        break;
      }
      else{
        register.removeAttribute("disabled");
      }
    }
    else if(element.id === "email"){
      let regex = "/[A-Z]/";
      let str = element.value;
      if(!str.includes("@") || !str.includes(".com")){
        console.log("inside email condition");
        showError("Email should contain @example.com, like @gmail.com, @hotmail.com, @yahoo.com");
        break;
      }
      else{
        register.removeAttribute("disabled");
      }
    }
    else if(element.id === "contact"){
      let str = element.value;
      if(str.length == 0){
        console.log("inside contact condition");
        showError("Contact can not be empty");
        break;
      }
      else if(str.length > 10 ){
        // contact.value = contact.value.toString().substr(0,10);
        console.log("inside contact condition");
        showError("Contact must contain 10 digits");
        break;
      }
      else if(str.length < 10 && str.length > 0){
        console.log("inside contact condition");
        showError("Contact must contain 10 digits");
        break;
      }
      else{
        register.removeAttribute("disabled");
      }
    }
    else if(element.id === "pass"){
      let str = pass.value;
      if(str.length == 0){
        showError("Password can not be empty");
      }
      else if(cpass.value.toString() !== pass.value.toString()){
        showError("Password does not match");
        break;
      }
      else{
        register.removeAttribute("disabled");
      }
    }
    else{
      register.removeAttribute("disabled");
    }
  }
}

function checkValid(event){
  let str = event.target.value;
  let charresult;
  let numresult;
  if(event.key == "Shift" || event.key == "Enter"){
    // none
  }
  else{
    charresult = spchar.includes(event.key);
    numresult = numberseq.includes(event.key);
  }
  if(charresult || numresult){
    event.target.value = str.substr(0,str.length-1);
    message.innerHTML = numresult?"Numbers are not allowed":"Special Characters are not allowed";
    message.style.animationName = "showmessage";
  }
}

fname.addEventListener("keyup", event => {
  checkValid(event);
});

lname.addEventListener("keyup", event => {
  checkValid(event);
});

register.addEventListener("mousemove", () => {
  checkEmpty();
});

register.addEventListener("click",() => {
  let url = `Action.jsp?fname=${fname.value.trim()}&lname=${lname.value.trim()}&email=${email.value.trim()}&contact=${contact.value.trim()}&pass=${pass.value.trim()}&url=register`;
  console.log(url);
  let xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = () => {
    if(xmlhttp.readyState == 4){
      let result = xmlhttp.responseText;
      if(result.includes("email")){
        message.innerHTML = "Email address already exists";
      }
      else if(result.includes("contact")){
        message.innerHTML = "Contact number already exists";
      }
      else if(result.includes("both")){
        message.innerHTML = "Email address and Contact number both already exists";
      }
      else if(result.includes("login")){
        message.innerHTML = `Registration Successful<br>Now you can <a href='login.html' style='color:#00fffd'>login</a>`;
      }
      else{
        let newTab = window.open('','_blank');
        newTab.document.write(result);
      }
      message.style.animationName = "showmessage";
    }
  }
  xmlhttp.open("POST",url,true);
  xmlhttp.send();
});

document.addEventListener("click", () => {
  message.style.animationName  = "hidemessage";
});
