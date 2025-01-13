function checkCookie(){
  document.cookie = "testcookie=1; SameSite=Lax; path=/";
  const cookiesEnabled = document.cookie.includes("testcookie=");
  if(cookiesEnabled == true){
      document.querySelector("#cookieInfo").style.display = "none";
  }
  else{
      document.querySelector("#cookieInfo").style.display = "block";
      
  }
  document.cookie = "testcookie=; expires=Thu, 01 Jan 1970 00:00:00 GMT";
}

let passviewer = document.querySelector("#passviewer");
passviewer.addEventListener("click", () => {
  if(pass.type === "password"){
    pass.type = "text";
    passviewer.src = "images/icons/pass-eye-close.png";
    passviewer.style.bottom = "13px";
  }
  else{
    pass.type = "password"
    passviewer.src = "images/icons/pass-eye-open.png";
    passviewer.style.bottom = "8px";
  }
});