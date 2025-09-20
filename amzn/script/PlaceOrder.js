
document.querySelector(".place-order-button").addEventListener("click", () => {
  let products = document.querySelectorAll(".product-list");
  let productArray = [];
  products.forEach(product => {
    const productJson = JSON.stringify(product.dataset);
    productArray.push(productJson);
  });
  let productsJson = JSON.stringify(productArray);
  productsJson.forEach(productJson => {
    for(let key in productJson){
      console.log(productJson[key])
    }
    console.log("\n");
  });
});