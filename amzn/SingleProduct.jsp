<%@ page session="false" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.format.TextStyle" %>

<% 
  HttpSession session = request.getSession(false);
  Class.forName("com.mysql.cj.jdbc.Driver");
  Connection c = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/amazon",
    "sonu",
    "15061999"
  );
  String customerName = "";
  if(session != null){
    String customerId = (String)session.getAttribute("customer_id");
    ResultSet rs = c.createStatement().executeQuery("SELECT fname FROM customer_table WHERE id='"+customerId+"'");
    if(rs.next()){
      customerName = rs.getString(1);
    }
  }
  String productId = request.getParameter("productid");
  ResultSet rs1 = c.createStatement().executeQuery("SELECT * FROM products_table WHERE id='"+productId+"'");
  rs1.next();
  String productImage = rs1.getString(2);
  String productName = rs1.getString(3);
  double price = Double.parseDouble(rs1.getString(4))/100;
  String productPriceCents = String.format("%.2f",price);
  String withoutDiscountPrice = String.format("%.2f",(price+(price*22/100)));

  LocalDate currentDate = LocalDate.now();
  LocalDate futureDate = currentDate.plusDays(3);
  String dayName = futureDate.getDayOfWeek().getDisplayName(TextStyle.FULL,Locale.ENGLISH);
  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM");
  String formattedDate = futureDate.format(formatter);
  String finalDate = dayName+", "+formattedDate;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= productName %></title>
  <link rel="stylesheet" href="style/Common.css">
  <link rel="stylesheet" href="style/AmazonHeader.css">
  <link rel="stylesheet" href="style/SingleProduct.css">
</head>
<body>
  <div class="main dislay-flex">
    <jsp:include page="AmazonHeader.jsp" />
    <div class="product-container display-flex">
      <div class="product-image-container display-flex">
        <div class="display-flex justify-center align-center">
          <img class="product-image" src="<%= productImage %>" alt="<%= productName %>">
        </div>
      </div>
      <div class="product-info-container display-flex flex-column">
        <div class="product-name">
          <%= productName %>
        </div>
        <div class="product-ratings-container display-flex">
          <div class="ratings-star">
            <img src="images/ratings/rating-20.png" alt="">
          </div>
          <div class="link">
            127
          </div>
        </div>
        <div class="amazon-choice-container">
          <span class="font-white">Amazon's</span>
          <span>choice</span>
        </div>
        <div class="sell-count-container">
          <span>1K+ bought</span>
          <span>in past month</span>
        </div>
        <hr>
        <div class="price-container">
          <span class="discount-container font-red">-22</span>
          <span class="percente-container font-red">%</span>
          <span class="dollar-container">$</span>
          <span class="amount-container"><%= productPriceCents %></span>
        </div>
        <div class="real-amount-container">
          <span>M.R.P.:</span>
          <span>$<%= withoutDiscountPrice %></span>
        </div>
        <div class="fulfilled-container display-flex">
          <img src="images/amazon-mobile-logo-white.png" alt="">
          <span class="font-white">Fulfilled</span>
        </div>
        <div class="tax-container">
          Inclusive of all taxes
        </div>
        <div class="emi-container">
          <span class="font-bold">EMI</span>
          <span>starts at $580. No cost EMI available</span>
          <span class="link">EMI options</span>
        </div>
        <div class="coupon-container display-flex">
          <div class="coupon-tag font-bold display-flex">
            Coupon:
          </div>
          <input type="checkbox" class="coupon-checkbox">
          <div class="coupon-checkbox-label">Apply $500 coupon</div>
          <div class="coupon-terms link text-underline">Terms</div>
        </div>
        <div class="amazon-business-container">
          With <span class="font-bold">Amazon Business</span>, you would have <span class="font-bold">saved $</span><span class="font-bold">138.86</span> in the last year. <span class="link">Create a free account</span> and <span class="font-bold">save up to</span> <span class="font-bold">15%</span> today.
        </div>
        <hr>
        <div class="offer-container display-flex flex-column">
          <div class="offer-heading display-flex">
            <div class="offer-icon">%</div>
            <div class="offer-label font-bold">Offers</div>
          </div>
          <div class="offer-list-container">
            <div class="bank-offer-container display-flex flex-column">
              <div class="label font-bold">Bank Offer</div>
              <div class="description">Upto $1,000.00 discount on select Credit Cards</div>
              <div class="counts link"> 4 offers</div>
            </div>
            <div class="no-cost-emi-container display-flex flex-column">
              <div class="label font-bold">No Cost EMI</div>
              <div class="description">Upto $667.80 EMI interest savings on select Credit Cards...</div>
              <div class="counts link">3 offers</div>
            </div>
            <div class="partner-offer-container display-flex flex-column">
              <div class="label font-bold">Parter Offers</div>
              <div class="description">Get GST invoice and save up to 25% on business purchase</div>
              <div class="counts link">1 offers</div>
            </div>
          </div>
        </div>
        <hr>
        <div class="write-review-container">
          <button class="write-review-button">Write a review</button>
        </div>
      </div>
      <div class="product-cart-container">
        <div class="with-exchange-container display-flex flex-column">
          <div class="with-exchange display-flex">
            <label for="with-exchange-radio">
              <span class="font-bold">With Exchange</span>
            </label>
            <input type="radio" name="exchange" id="with-exchange-radio" >
          </div>
          <div class="exchange-offer font-maroon">
            Up to $1,830.00 off
          </div>
        </div>
        <div class="without-exchange-container">
          <div class="with-exchange display-flex">
            <label for="without-exchange-radio">
              <span class="font-bold">Without Exchange</span>
            </label>
            <input type="radio" name="exchange" checked id="without-exchange-radio" >
          </div>
          <div class="without-exchange-offer">
            <span class="font-maroon">
              $ <span class="font-bold"><%= productPriceCents %></span> 
            </span>
            <span class="font-grey">
              $ <span class="font-bold text-line-through"><%= withoutDiscountPrice %></span>
            </span>
          </div>
          <div class="fulfilled-container display-flex">
            <img src="images/amazon-mobile-logo-white.png" alt="">
            <span class="font-white">Fulfilled</span>
          </div>
          <div class="delivery-info-container">
            <div>
              FREE scheduled delivery as soon
            </div>
            <div>
              as <span class="font-bold"><%= finalDate %>,</span>
            </div>
            <div class="font-bold">
              7 am - 3 pm
            </div>
          </div>
          <div class="delivery-address-container display-flex">
            <div class="location-icon-container">
              <img src="images/icons/location.png" alt="">
            </div>
            <div class="delivery-address link">
              <% if(session != null){ %>
                Deliver to <%= customerName %> Jahangir Puri 110033.
              <% }else{ %>
                <span><a href="login.html">Login</a></span> to see available delivery in your area.
              <% } %>
            </div>
          </div>
          <div class="in-stock-container">
            In stock
          </div>
          <div class="seller-info-container">
            <table>
              <tr>
                <td class="font-grey">Payment</td>
                <td class="link">Secure transaction</td>
              </tr>
              <tr>
                <td class="font-grey">Ships from</td>
                <td>Amazon</td>
              </tr>
              <tr>
                <td class="font-grey display-flex">Sold by</td>
                <td class="link">DAWNTECH ELECTRONICS PRIVATE LIMITED</td>
              </tr>
            </table>
          </div>
          <!-- <div class="protection-plan-container">
            <div class="protection-plan-label font-bold">Add a Protection Plan:</div>
            <div class="extended-warranty-container display-flex">
              <input type="checkbox" class="extended-warranty-checkbox">
              <div class="extended-warranty-label"><span class="link">Extended Warranty</span> for <span class="font-maroon">$199.00</span></div>
            </div>
            <div class="total-protection-container display-flex">
              <input type="checkbox" class="total-protection-checkbox">
              <div class="total-protection-label"><span class="link">Total Protection Plan</span> for <span class="font-maroon">$449.00</span></div>
            </div>
          </div> -->
          <div class="quantity-container display-flex">
            <div class="quantity-label">Quantity: </div>
            <select id="quantity" class="quantity-drop-down">
              <option selected value="1">1</option>
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
          <div class="add-cart-container">
            <button class="add-cart-button display-flex" id="<%= productId %>-add-cart-button" onclick="updateCart(this)" >
              Add to Cart
            </button>
            <div id="cart-added-info">
              <img id="cart-added-image" src="images/icons/checkmark.png" alt="">
              <span id="cart-added-message">Added</span>
            </div>
          </div>
          <div class="buy-now-container">
            <button class="buy-now-button">Buy Now</button>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script src="script/SingleProduct.js"></script>
</body>
</html>