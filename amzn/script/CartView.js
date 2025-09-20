let itemsprice = document.querySelector(".items-price");

function updateOrderTotal(beforeTax, estimateTax){
  const orderTotal = document.querySelector(".order-total-price");
  let beforeTaxPrice = parseInt(beforeTax.dataset.beforeTaxPrice);
  let estimateTaxPrice = parseInt(estimateTax.dataset.estimateTaxPrice);
  orderTotal.innerHTML = `${((beforeTaxPrice + estimateTaxPrice)/100).toFixed(2)}`;
  
}

function updateEstimateTax(beforeTax){
  const estimateTax = document.querySelector(".estimate-tax-price");
  let beforeTaxPrice = parseInt(beforeTax.dataset.beforeTaxPrice);
  estimateTax.dataset.estimateTaxPrice = `${beforeTaxPrice*10/100}`;
  estimateTax.innerHTML = `${((beforeTaxPrice*10/100)/100).toFixed(2)}`;
  updateOrderTotal(beforeTax, estimateTax);
}

function updateBeforeTaxPrice(totalShippingCharge){
  const beforeTax = document.querySelector(".before-tax-price");
  let itemsPrice = parseInt(itemsprice.dataset.itemsPrice);
  beforeTax.setAttribute("data-before-tax-price",`${itemsPrice+totalShippingCharge}`);
  beforeTax.innerHTML = ((itemsPrice+totalShippingCharge)/100).toFixed(2);
  updateEstimateTax(beforeTax);
}

function updateShippingCharges(){
  let totalShippingCharge = 0;
  const productList = document.querySelectorAll(".product-list");
  productList.forEach(product => {
    let shipping = parseInt(product.dataset.productDeliveryCharge);
    totalShippingCharge += shipping;
  });
  const shippingPrice = document.querySelector(".shipping-price");
  shippingPrice.innerHTML = `${(totalShippingCharge/100).toFixed(2)}`;
  updateBeforeTaxPrice(totalShippingCharge);
}

function updateDeliveryOption(obj){
  const productId = obj.getAttribute("name").split("-")[0];
  let data = obj.dataset;
  const deliveryDate = data.deliveryDate;
  const deliveryCharge = data.deliveryCharge;
  const product = document.querySelector(`#${productId}-product`);
  product.dataset.productDeliveryDate = deliveryDate;
  product.dataset.productDeliveryCharge = deliveryCharge;
  document.querySelector(`#${productId}-delivery-date`).innerHTML = deliveryDate
  updateShippingCharges();
}

function updateItems(){
  let totalItems = 0;
  let totalPrice = 0;
  const productList = document.querySelectorAll(".product-list");
  productList.forEach(product => {
    let quantity = parseInt(product.dataset.productQuantity);
    let price = parseInt(product.dataset.productPriceCents);
    totalItems += quantity;
    totalPrice += (quantity * price);
  });

  const itemsCount = document.querySelector(".items-count");
  itemsCount.innerHTML = `${totalItems}`;
  itemsprice.setAttribute("data-items-price",`${totalPrice}`);
  itemsprice.innerHTML = `${(totalPrice/100).toFixed(2)}`;
  updateShippingCharges();  
}

function showCartUpdateInfo(total) {
  const cart_quantity = document.querySelector(".cart-quantity");
  if (total.length == 1) {
    total = `0${total}`;
  }
  cart_quantity.innerHTML = total;
}

function removeProduct(deleteButton){
  const productId = deleteButton.dataset.productId;
  const url = `Action.jsp?url=removeproduct&productid=${productId}`;
  let xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = () => {
    if(xmlhttp.readyState == 4){
      if(xmlhttp.responseText.includes("login")){
        alert("Please! login");
      }
      else if(xmlhttp.responseText.includes("total")){
        let total = xmlhttp.responseText.split(":")[1].trim();
        let productContainer = document.querySelector(`#${productId}-product`);
        if(`${total}` == "0"){
          document.querySelector(".product-list-container").innerHTML = "<h1>Your cart is empty</h1>";
        }
        productContainer.remove();
        updateItems();
        showCartUpdateInfo(`${total}`);
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

function updateCart(saveButton, deleteButton){
  const productId = saveButton.dataset.productId;
  const quantityObj = document.querySelector(`#${productId}-product-quantity`);
  const quantity = quantityObj.firstChild.nodeValue;
  const url = `Action.jsp?url=quantityupdate&productid=${productId}&quantity=${quantity}`;
  let xmlhttp = new XMLHttpRequest();
  xmlhttp.onreadystatechange = () => {
    if(xmlhttp.readyState == 4){
      if(xmlhttp.responseText.includes("login")){
        alert("Please! login");
      }
      else if(xmlhttp.responseText.includes("total")){
        let total = xmlhttp.responseText.split(":")[1].trim();
        quantityObj.removeAttribute("contenteditable");    
        quantityObj.style.border = "none";
        quantityObj.style.backgroundColor = "transparent";
        deleteButton.style.display = "block";
        saveButton.innerHTML = "Update";
        showCartUpdateInfo(`${total}`);
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
function quantityUpdateButton(updateButton){
  const productId = updateButton.dataset.productId;
  const quantityInput = document.querySelector(`#${productId}-product-quantity`);
  let buttonLabel = updateButton.firstChild.nodeValue;
  const deleteButton = document.querySelector(`#${productId}-delete-button`);

  if(buttonLabel === "Update"){
    quantityInput.setAttribute("contenteditable","");
    quantityInput.style.border = "1px solid black";
    quantityInput.style.backgroundColor = "rgb(128 128 128 / 31%)";
    deleteButton.style.display = "none";
    updateButton.innerHTML = "Save";
  }
  else{
    updateCart(updateButton, deleteButton);
  }
}

function quantityValidation(obj,event){
  const symbols = "~`!@#$%^&*()_+-=[]{}:\";<>?,./\\|'";
  const upperLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  const lowerLetters = upperLetters.toLowerCase();
  const numbers = "123456789";
  if(symbols.includes(`${event.key}`) || 
     upperLetters.includes(`${event.key}`) ||
     lowerLetters.includes(`${event.key}`)
    ){
    let text = obj.firstChild.nodeValue;
    obj.innerHTML = `${text.replace(`${event.key}`,"")}`;
  }
  else if(parseInt(obj.firstChild.nodeValue) < 1){
    obj.innerHTML = "1";
  }
  else if(`${event.key}` === " "){
    obj.innerHTML = obj.firstChild.nodeValue.trim();
  }
  else if(obj.firstChild.nodeValue == null){
    obj.innerHTML = "1";
  }
  else if(event.key == "ArrowUp"){
    obj.innerHTML = `${parseInt(obj.firstChild.nodeValue)+1}`;
  }
  else if(event.key == "ArrowDown"){
    obj.innerHTML = `${parseInt(obj.firstChild.nodeValue)-1}`;
    if(parseInt(obj.firstChild.nodeValue) < 1){
      obj.innerHTML = "1";
    }
  }
  else{
    if(obj.firstChild.nodeValue == null){
      obj.innerHTML = "1";
    }
  }
}

function updateQuantity(obj, event){
  event.preventDefault(true);
  quantityValidation(obj,event);
}
