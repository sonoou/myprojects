<%@ page session="false" %>
<%@ page import="java.sql.ResultSet" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Checkout</title>
  <link rel="stylesheet" href="style/Common.css">
  <link rel="stylesheet" href="style/AmazonHeader.css">
  <link rel="stylesheet" href="style/CartView.css">
</head>
<body>
  <div class="main display-flex flex-column align-center">
    <jsp:include page="AmazonHeader.jsp" />
    <div class="review-label">Review your order</div>
    <div class="checkout-container display-flex">
      <div class="product-list-container display-flex flex-column">
        <% 
          HttpSession session = request.getSession(false);
          if(session == null){
            out.println("<h2>Please! Login</h2>");
          }
          else{
            String customerId = (String)session.getAttribute("customer_id");
        %>
        <jsp:useBean id="date" class="date.MyDate" />
        <jsp:useBean id="cartTable" class="cart.CartTable" />
        <jsp:setProperty name="cartTable" property="customerId" value="<%= customerId %>" />
        <%
            double totalPrice = 0.00;
            int totalItems = 0;
            String estimateTaxStr = "0.0";
            String orderTotal = "0.0";
            ResultSet rs = cartTable.getProductList();
            if(rs.next()){
              while(true){
                String productId = rs.getString(1);
                String productImage = rs.getString(2);
                String productName = rs.getString(3);
                String productPriceCents = rs.getString(4);
                String productPrice = String.format("%.2f",(Double.parseDouble(productPriceCents)/100));
                String productQuantity = rs.getString(5);
                totalItems += Integer.parseInt(productQuantity);
                totalPrice += Double.parseDouble(productPriceCents) * Integer.parseInt(productQuantity);
        %>
        <div class="product-list" id="<%= productId %>-product" data-product-id="<%= productId %>" data-product-delivery-date="<%= date.getFutureDate(9) %>" data-product-price-cents="<%= productPriceCents %>" data-product-quantity="<%= productQuantity %>" data-product-delivery-charge="00">
          <div class="delivery-date-container font-green font-bold">
            Delivery date: <span class="delivery-date" id="<%= productId %>-delivery-date"><%= date.getFutureDate(9) %></span>
          </div>
          <div class="display-flex justify-space-around ">
            <div class="product-container display-flex">
              <div class="product-image-container">
                <img src="<%= productImage %>" alt="<%= productName %>" id="product-image">
              </div>
              <div>
                <div class="product-name font-bold">
                  <%= productName %>
                </div>
                <div class="product-price-container font-maroon font-bold">
                  $<span class="product-price"><%= productPrice %></span>
                </div>
                <div class="product-quantity-container display-flex align-center">
                  Quantity: <span class="product-quantity" id="<%= productId %>-product-quantity"  onkeyup="updateQuantity(this,event)"><%= productQuantity %></span> <span class="update-button link" data-product-id="<%= productId %>" onclick="quantityUpdateButton(this)">Update</span> <span class="delete-button link" onclick="removeProduct(this)" data-product-id="<%= productId %>" id="<%= productId %>-delete-button">Delete</span>
                </div>
              </div>
            </div>
            <div class="delivery-option-container">
              <div class="option-heading font-bold">Choose a delivery option</div>
              <div class="zero-charge display-flex align-center">
                <input type="radio" onclick="updateDeliveryOption(this)" checked name="<%= productId %>-delivery-charge" data-delivery-charge="00" data-delivery-date="<%= date.getFutureDate(9) %>">
                <div class="date-charge-info">
                  <div class="date-info font-green"><%= date.getFutureDate(9) %></div>
                  <div class="charge-info font-grey">FREE Shipping</div>
                </div>
              </div>
              <div class="medium-charge display-flex align-center">
                <input type="radio" onclick="updateDeliveryOption(this)" name="<%= productId %>-delivery-charge" data-delivery-charge="499" data-delivery-date="<%= date.getFutureDate(4) %>">
                <div class="date-charge-info">
                  <div class="date-info font-green"><%= date.getFutureDate(4) %></div>
                  <div class="charge-info font-grey">$4.99 - Shipping</div>
                </div>
              </div>
              <div class="high-charge display-flex align-center">
                <input type="radio" onclick="updateDeliveryOption(this)" name="<%= productId %>-delivery-charge" data-delivery-charge="999" data-delivery-date="<%= date.getFutureDate(1) %>">
                <div class="date-charge-info">
                  <div class="date-info font-green"><%= date.getFutureDate(1) %></div>
                  <div class="charge-info font-grey">$9.99 - Shipping</div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <%
                if(!rs.next()){
                  break;
                }
              }
              estimateTaxStr = String.format("%.2f",(totalPrice*10/100)/100);
              orderTotal = String.format("%.2f",(totalPrice+(totalPrice*10/100))/100);
            }
            else{
        %>
            <h1>Your cart is empty</h1>
        <%
            }
        %>
      </div>
      <div class="order-summary-container display-flex flex-column">
        <div class="order-heading font-bold">Order Summary</div>
        <div class="items-container display-flex justify-space-between">
          <span class="items-label">Items (<span class="items-count" data-items-count="<%= totalItems %>"><%= totalItems %></span>):</span><span class="items-price-container">$<span class="items-price" data-items-price="<%= totalPrice %>"><%= totalPrice/100 %></span></span>
        </div>
        <div class="shipping-container display-flex justify-space-between">
          <span class="shipping-label">Shipping & handling</span><span class="shipping-price-container">$<span class="shipping-price">0.0</span></span>
        </div>
        <hr class="next-to-shipping">
        <div class="before-tax-container display-flex justify-space-between">
          <span class="before-tax-label">Total before tax:</span><span class="before-tax-price-container">$<span class="before-tax-price" data-before-tax-price="<%= totalPrice/100 %>"><%= totalPrice/100 %></span></span>
        </div>
        <div class="estimate-tax-container display-flex justify-space-between">
          <span class="estimate-tax-label">Estimated tax (<span class="estimate-tax-rate">10</span>%):
          </span>
          <span class="estimate-tax-price-container">
            $<span class="estimate-tax-price" data-estimate-tax-price="<%= estimateTaxStr %>"><%= estimateTaxStr %></span>
          </span>
        </div>
        <hr>
        <div class="order-total-container font-maroon font-bold display-flex justify-space-between">
          <span class="order-total-label">Order total:</span><span class="order-total-price-container">$<span class="order-total-price"><%= orderTotal %></span></span>
        </div>
        <div class="place-order-container">
          <button class="place-order-button">Place your order</button>
        </div>
      </div>
      <%
        }
      %>
    </div>
  </div>
  <script src="script/CartView.js"></script>
  <script src="script/PlaceOrder.js"></script>
</body>
</html>