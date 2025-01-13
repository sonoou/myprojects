let cart_info_container;
function rmattr() {
  cart_info_container.removeAttribute("class");
}

function showCartUpdateInfo(productid, displayType, msg, bgcolor, total) {
  const cart_info_image = document.querySelector(`#${productid}-cart-info-image`);
  const cart_info_text = document.querySelector(`#${productid}-cart-info-text`);
  cart_info_container = document.querySelector(`#${productid}-cart-info-container`);
  const cart_quantity = document.querySelector(".cart-quantity");
  cart_info_image.style.display = displayType;
  cart_info_text.innerHTML = msg;
  cart_info_container.style.backgroundColor = bgcolor;
  cart_info_container.setAttribute("class", "cart-added-info");
  if (total.length == 1) {
    total = `0${total}`;
  }
  cart_quantity.innerHTML = total;
  window.setTimeout("rmattr()", 1500);
}

function updateCart(addCartButton){
  const productid = addCartButton.getAttribute("id").split("-")[0];
  const quantity = document.querySelector(`#${productid}-quantity`);
  const url = `Action.jsp?url=cartupdate&productid=${productid}&quantity=${quantity.value}`;
  let xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = () => {
    if(xmlhttp.readyState == 4){
      if(xmlhttp.responseText.includes("login")){
        showCartUpdateInfo(productid, "none", "Please! Login", "grey", "0");
      }
      else if(xmlhttp.responseText.includes("total")){
        let total = xmlhttp.responseText.split(":")[1].trim();
        showCartUpdateInfo(productid, "inline-block", "Added", "#00805e", `${total}`);
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
