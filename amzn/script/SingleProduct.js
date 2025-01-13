let cartAddedInfo;
function rmAttr(){
  cartAddedInfo.removeAttribute("class");
}

// update cart code
function updateCart(addCartButton){
  const productid = addCartButton.getAttribute("id").split("-")[0];
  const quantity = document.querySelector("#quantity");
  const cartAddedImage = document.querySelector("#cart-added-image");
  const cartAddedMessage = document.querySelector("#cart-added-message");
  cartAddedInfo = document.querySelector("#cart-added-info");
  const cartQuantity = document.querySelector(".cart-quantity");
  const url = `Action.jsp?url=cartupdate&productid=${productid}&quantity=${quantity.value}`;
  let xmlhttp = new XMLHttpRequest();
  console.log(url);
  xmlhttp.onreadystatechange = () => {
    if(xmlhttp.readyState == 4){
      if(xmlhttp.responseText.includes("login")){
        cartAddedImage.style.display = "none";
        cartAddedMessage.innerHTML = "Please! Login"
        cartAddedInfo.style.backgroundColor = "grey";
        cartAddedInfo.setAttribute("class","cart-added-anime");
        window.setTimeout("rmAttr()",2000);
      }
      else if(xmlhttp.responseText.includes("total")){
        let total = xmlhttp.responseText.split(":")[1].trim();
        cartAddedImage.style.display = "inline-block";
        cartAddedMessage.innerHTML = "Added"
        cartAddedInfo.style.backgroundColor = "#00805e";
        cartAddedInfo.setAttribute("class","cart-added-anime");
        if(total.length == 1){
          total = `0${total}`;
          console.log(`total: ${total}`);
        }
        cartQuantity.innerHTML = total;
        window.setTimeout("rmAttr()",2000);
      }
      else{
        const newTab = window.open('','_blank'); //Open new tab
        newTab.document.write(`<html><body>${xmlhttp.responseText}</body></html>`);
      }
    }
  }
  xmlhttp.open("POST",url,true);
  xmlhttp.send();
}