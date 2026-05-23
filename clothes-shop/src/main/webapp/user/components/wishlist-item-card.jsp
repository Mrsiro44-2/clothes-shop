<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="DAO.ProductDAO, Model.Product, Model.WishlistItem" %>
<%
    WishlistItem w = (WishlistItem) request.getAttribute("wishlistItem");
    if (w == null) {
        return;
    }
    Product p = new ProductDAO().statusIsActive(w.getProductID());
    if (p == null) {
        p = new ProductDAO().getProductByID(w.getProductID());
    }
    if (p == null) {
        return;
    }
    String ctx = request.getContextPath();
    request.setAttribute("cardProduct", p);
    request.setAttribute("cardVariantId", w.getProductVariantID());
    request.setAttribute("cardWishlistId", w.getId());
    request.setAttribute("cardPathUrl", ctx + "/wishlist");
%>
<jsp:include page="product-card.jsp"/>
