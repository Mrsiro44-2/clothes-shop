<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${empty ctx}"><c:set var="ctx" value="${pageContext.request.contextPath}"/></c:if>
<div class="mb-shop-empty">
    <img src="./user/img/no-product-found.png" alt="Không tìm thấy sản phẩm" onerror="this.style.display='none'"/>
    <h3>${empty emptyTitle ? 'Không tìm thấy sản phẩm phù hợp' : emptyTitle}</h3>
    <p>${empty emptyMessage ? 'Thử từ khóa khác hoặc xem toàn bộ cửa hàng.' : emptyMessage}</p>
    <a href="${ctx}/product" class="mb-shop-empty-btn">Xem tất cả sản phẩm</a>
</div>
