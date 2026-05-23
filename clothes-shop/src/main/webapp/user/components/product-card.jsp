<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="Utils.ProductCardJsp, jakarta.servlet.http.HttpServletRequest" %>
<%
    if (!ProductCardJsp.prepare((HttpServletRequest) pageContext.getRequest())) {
        return;
    }
%>
<div class="product mb-product-card">
    <div class="product-img mb-product-card__media">
        <a href="${cardCtx}/product/detail/${cardProduct.ID}" class="mb-product-card__img-link">
            <img class="mb-img" src="${imgUrl.resolve(cardProduct.mainImg, cardCtx)}" alt="${cardProduct.name}" onerror="mbImgOnError(this)"/>
        </a>
        <div class="product-label mb-product-card__badges">
            <c:if test="${cardBadgePct > 0}">
                <span class="sale">-${cardBadgePct}%</span>
            </c:if>
            <c:if test="${cardBadgePct == 0 && cardPriceMin <= 0}">
                <span class="new">Mới</span>
            </c:if>
            <c:if test="${cardProduct.priority == 3}">
                <span class="hot">Nổi bật</span>
            </c:if>
        </div>
        <div class="mb-product-card__wish-slot">
            <c:if test="${not empty cardWishlistId}">
                <a href="${cardCtx}/wishlist/remove?id=${cardWishlistId}&amp;pathUrl=${fn:escapeXml(cardPathUrl)}"
                   class="mb-product-card__wish mb-product-card__wish--saved mb-confirm"
                   title="Bỏ yêu thích" aria-label="Bỏ yêu thích"
                   data-confirm-key="wishlist-remove">
                    <i class="fa fa-heart"></i>
                </a>
            </c:if>
            <c:if test="${empty cardWishlistId && not empty cardVariant}">
                <form class="mb-product-card__wish-form" method="post" action="${cardCtx}/wishlist/add">
                    <input type="hidden" name="productVariantID" value="${cardVariant.ID}"/>
                    <input type="hidden" name="pathUrl" value="${cardPathUrl}"/>
                    <button type="submit" class="mb-product-card__wish" title="Yêu thích" aria-label="Yêu thích">
                        <i class="fa fa-heart-o"></i>
                    </button>
                </form>
            </c:if>
        </div>
        <div class="add-to-cart mb-product-card__overlay">
            <a class="mb-product-card__choose" href="${cardCtx}/product/detail/${cardProduct.ID}">Chọn tùy chọn</a>
            <a class="mb-product-card__quick" href="${cardCtx}/product/detail/${cardProduct.ID}" title="Xem nhanh">
                <i class="fa fa-eye"></i>
            </a>
            <c:choose>
                <c:when test="${not empty cardVariant}">
                    <a class="mb-product-card__cart add-to-cart-btn" style="border: none"
                       href="${cardCtx}/cart/add?productVariantID=${cardVariant.ID}&quantity=1&pathUrl=${cardPathUrl}">
                        <i class="fa fa-shopping-cart"></i>
                    </a>
                </c:when>
                <c:otherwise>
                    <a class="mb-product-card__cart add-to-cart-btn" style="border: none" href="${cardCtx}/product/detail/${cardProduct.ID}">
                        <i class="fa fa-shopping-cart"></i>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="product-body mb-product-card__body">
        <h3 class="product-name">
            <a href="${cardCtx}/product/detail/${cardProduct.ID}">${cardProduct.name}</a>
        </h3>
        <h4 class="product-price mb-product-card__price">${cardPriceHtml}</h4>
        <c:if test="${not empty cardColors}">
            <div class="mb-product-card__swatches">
                <c:forEach items="${cardColors}" var="co">
                    <c:set var="hex" value="${empty co.hexCode ? '#cccccc' : co.hexCode}"/>
                    <c:if test="${!fn:startsWith(hex, '#')}">
                        <c:set var="hex" value="#${hex}"/>
                    </c:if>
                    <span class="mb-product-card__swatch" style="background-color:${hex};" title="${co.name}"></span>
                </c:forEach>
            </div>
        </c:if>
    </div>
</div>
