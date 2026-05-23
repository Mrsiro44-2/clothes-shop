<%-- Thanh tìm kiếm — dùng trên trang Cửa hàng / Kết quả tìm kiếm --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${empty ctx}"><c:set var="ctx" value="${pageContext.request.contextPath}"/></c:if>
<div class="mb-shop-search-wrap">
    <form class="mb-shop-search" action="${ctx}/product/search" method="get">
        <input class="input" type="text" name="keyword" id="shop-search"
               placeholder="Tìm sản phẩm bạn cần..."
               value="${not empty keyword ? keyword : (not empty key ? key : '')}"/>
        <button type="submit" class="mb-shop-search-btn">
            <i class="fa fa-search"></i> Tìm kiếm
        </button>
    </form>
</div>
