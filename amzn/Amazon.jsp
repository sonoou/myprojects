<%@ page session="false" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Amazon - Home page</title>
    <link rel="stylesheet" href="style/Common.css">
    <link rel="stylesheet" href="style/AmazonHeader.css">
    <link rel="stylesheet" href="style/Amazon.css">
  </head>
  <body>
    <% 
      HttpSession session = request.getSession(false);
      Class.forName("com.mysql.cj.jdbc.Driver");
      Connection c = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/amazon",
        "sonu",
        "15061999"
      );
      ResultSet rs = c.createStatement().executeQuery("SELECT * FROM products_table");
    %>
    <div class="main display-flex">
      <jsp:include page="AmazonHeader.jsp" />
      <div class="product-grid">
        <%
          while(rs.next()){
            String productId = rs.getString(1);
            String productImage = rs.getString(2);
            String productName = rs.getString(3);
            String productPriceCents = String.format("%.2f",((double)Integer.parseInt(rs.getString(4))/100));
        %>
        <div class="product-container display-flex">
          <a href="SingleProduct.jsp?productid=<%= productId %>" id="<%= productId %>-product-image" class="product-image display-flex">
            <img src="<%= productImage %>" alt="<%= productName %>">
          </a>
          <a href="SingleProduct.jsp?productid=<%= productId %>" id="<%= productId %>-product-name" class="product-name font-black text-decoration-none">
            <%= productName %>
          </a>
          <div class="ratings display-flex">
            <img class="ratings-image" src="images/ratings/rating-45.png" alt="">
            <div class="ratings-count">127</div>
          </div>
          <div class="product-price">$<%= productPriceCents %></div>
          <div class="quantity-container">
            <select id="<%= productId %>-quantity">
              <option value="1">1</option>
              <option value="2">2</option>
              <option value="3">3</option>
              <option value="4">4</option>
              <option value="5">5</option>
              <option value="6">6</option>
              <option value="7">7</option>
              <option value="8">8</option>
              <option value="9">9</option>
              <option value="10">10</option>
            </select>
          </div>
          <div class="cart-button-container display-flex">
            <div id="<%= productId %>-cart-info-container" class="dislay-flex justify-center">
              <img src="images/icons/checkmark.png" alt="" id="<%= productId %>-cart-info-image">
              <div id="<%= productId %>-cart-info-text">
              </div>
            </div>
            <button class="add-to-cart-button" id="<%= productId %>-add-cart-button" onclick="updateCart(this)">Add to Cart</button>
          </div>
        </div>
        <% } %>
      </div>
    </div>
    <script src="script/Amazon.js"></script>
  </body>
</html>
