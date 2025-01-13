let itemsprice = document.querySelector(".items-price");

function updateOrderTotal(beforeTax, estimateTax){
  const orderTotal = document.querySelector(".order-total-price");
  let beforeTaxPrice = parseInt(beforeTax.dataset.beforeTaxPrice);
  console.log(beforeTax.dataset.beforeTaxPrice);
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
    quantityInput.removeAttribute("contenteditable");    
    quantityInput.style.border = "none";
    quantityInput.style.backgroundColor = "transparent";
    deleteButton.style.display = "block";
    updateButton.innerHTML = "Update";
  }
}

let quantityInputAll = document.querySelectorAll(".product-quantity");

function updateQuantity(obj, event){
  const regex = "~`!@#$%^&*()_+-=[]{}:\";<>?,./\\|'/[A-Z]//[a-z]";
  const reg = "/[A-Z]"
  console.log(event.key);
  if(regex.includes(`${event.key}`)){
    let text = obj.firstChild.nodeValue;
    console.log(text);
    obj.innerHTML = `${text.substring(0,text.length-1)}`;
  }
}