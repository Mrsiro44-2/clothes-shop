<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:useBean id="sale" class="Utils.Sale"></jsp:useBean>
<jsp:useBean id="calculateStar" class="Utils.CalculateFeedback"></jsp:useBean>
<%@include file="./components/header.jsp" %>
<link type="text/css" rel="stylesheet" href="./user/css/product-detail-variant.css" />
<link type="text/css" rel="stylesheet" href="./user/css/product-detail-v2.css" />
<c:set var="category" value="${getDao.getCategoryById(product.categoryID)}" />
<c:set var="brand" value="${getDao.getBrandById(product.brandID)}" />
<c:set var="totalStar" value="${calculateStar.totalStar(feedbacks)}" />
<c:set var="soldCount" value="${product.sold != null ? product.sold : 0}" />

<div class="section mb-pd-page">
    <div class="container">
        <ul class="mb-pd-breadcrumb">
            <li><a href="${ctx}/home">Trang chủ</a></li>
            <li><a href="${ctx}/product">Cửa hàng</a></li>
            <c:if test="${category != null}">
                <li><a href="${ctx}/product?type=category&id=${category.ID}">${category.name}</a></li>
            </c:if>
            <li class="active">${product.name}</li>
        </ul>

        <div class="row">
            <div class="col-md-6 mb-pd-gallery">
                <div class="mb-pd-main-wrap">
                    <div class="mb-pd-side-actions">
                        <c:if test="${not empty defaultVariant}">
                            <form method="post" action="${ctx}/wishlist/add" style="margin:0">
                                <input type="hidden" name="productVariantID" id="mb-wish-variant-id" value="${defaultVariant.ID}"/>
                                <input type="hidden" name="pathUrl" value="${ctx}/product/detail/${product.ID}"/>
                                <button type="submit" class="mb-pd-icon-btn" title="Yêu thích" aria-label="Yêu thích">
                                    <i class="fa fa-heart-o"></i>
                                </button>
                            </form>
                        </c:if>
                    </div>
                    <div id="product-main-img" class="mb-pd-main-slider">
                        <div class="product-preview">
                            <img class="mb-img" src="${imgUrl.resolve(product.mainImg, ctx)}" alt="${product.name}" onerror="mbImgOnError(this)"/>
                        </div>
                        <c:forEach items="${imgDesc}" var="img">
                            <div class="product-preview">
                                <img class="mb-img" src="${imgUrl.resolve(img.imgUrl, ctx)}" alt="${product.name}" onerror="mbImgOnError(this)"/>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <div id="product-imgs" class="mb-pd-thumbs">
                    <div class="product-preview">
                        <img class="mb-img" src="${imgUrl.resolve(product.mainImg, ctx)}" alt="" onerror="mbImgOnError(this)"/>
                    </div>
                    <c:forEach items="${imgDesc}" var="img">
                        <div class="product-preview">
                            <img class="mb-img" src="${imgUrl.resolve(img.imgUrl, ctx)}" alt="" onerror="mbImgOnError(this)"/>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="col-md-6">
                <p class="mb-pd-brand">
                    <c:if test="${brand != null}">
                        <a href="${ctx}/product?type=brand&id=${brand.ID}">${brand.name}</a>
                    </c:if>
                    <c:if test="${brand == null}">Clothing shop</c:if>
                </p>
                <h1 class="mb-pd-title">${product.name}</h1>

                <div class="mb-pd-price-row">
                    <div id="mb-detail-price" style="display:flex;flex-wrap:wrap;align-items:center;gap:10px">
                        <c:choose>
                            <c:when test="${not empty defaultVariant}">
                                <c:set var="dvNew" value="${defaultVariant.newPrice > 0 ? defaultVariant.newPrice : defaultVariant.oldPrice}" />
                                <span class="mb-pd-price-current">${currency.currencyFormat(dvNew)}</span>
                                <c:if test="${defaultVariant.newPrice > 0 && defaultVariant.oldPrice > defaultVariant.newPrice}">
                                    <span class="mb-pd-price-old">${currency.currencyFormat(defaultVariant.oldPrice)}</span>
                                    <span class="mb-pd-badge-sale">${sale.saleBadge(defaultVariant.newPrice, defaultVariant.oldPrice)}</span>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${product.newPrice > 0}">
                                        <span class="mb-pd-price-current">${currency.currencyFormat(product.newPrice)}</span>
                                        <span class="mb-pd-price-old">${currency.currencyFormat(product.oldPrice)}</span>
                                        <span class="mb-pd-badge-sale">${sale.saleBadge(product.newPrice, product.oldPrice)}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="mb-pd-price-current">${currency.currencyFormat(product.oldPrice)}</span>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <span class="mb-pd-meta-item"><strong>${soldCount}</strong> đã bán</span>
                    <span class="mb-pd-meta-item mb-pd-rating">
                        <c:forEach begin="1" end="${totalStar}"><i class="fa fa-star"></i></c:forEach>
                        <c:forEach begin="${totalStar + 1}" end="5"><i class="fa fa-star-o"></i></c:forEach>
                        <strong>${totalStar}/5</strong> · ${feedbacks.size()} đánh giá
                    </span>
                    <span class="mb-pd-meta-item" id="mb-stock-label">&#272;ang t&#7843;i...</span>
                </div>

                <c:if test="${not empty product.description}">
                    <div class="mb-pd-desc-block">
                        <h4>Mô tả:</h4>
                        <div class="mb-pd-desc-text" id="mb-pd-desc">${product.description}</div>
                        <button type="button" class="mb-pd-see-more" id="mb-pd-see-more" style="display:none">Xem thêm...</button>
                    </div>
                </c:if>

                <c:if test="${not empty variants}">
                    <div class="mb-pd-option">
                        <label class="mb-pd-color-label">Màu: <span id="mb-color-name">—</span></label>
                        <div id="mb-color-options"></div>
                    </div>
                    <div class="mb-pd-option">
                        <div class="mb-pd-option-head">
                            <label>Kích cỡ: <span id="mb-size-name">—</span></label>
                        </div>
                        <div id="mb-size-options"></div>
                        <select id="mb-size-select" class="mb-variant-size-select" aria-hidden="true" tabindex="-1"></select>
                    </div>
                </c:if>
                <p id="mb-no-variant-msg"><c:if test="${empty variants}">${variantStockNote}</c:if></p>

                <form action="${ctx}/cart/add" method="post" id="mb-pd-cart-form">
                    <input type="hidden" name="productVariantID" id="mb-variant-id"
                           value="${not empty defaultVariant ? defaultVariant.ID : ''}"/>
                    <input name="productID" value="${product.ID}" type="hidden"/>
                    <input name="pathUrl" value="${ctx}/product/detail/${product.ID}" type="hidden"/>

                    <div class="mb-pd-qty-row">
                        <label style="margin:0;font-weight:600">Số lượng</label>
                        <div class="mb-pd-qty-wrap">
                            <button type="button" class="value-button" id="decrease">−</button>
                            <input class="qty-input" type="number" name="quantity" id="number" value="1" min="1"
                                   max="${not empty defaultVariant ? defaultVariant.quantity : product.quantity}"/>
                            <button type="button" class="value-button" id="increase">+</button>
                        </div>
                    </div>

                    <div class="mb-pd-actions">
                        <button type="submit" id="mb-add-cart-btn" class="mb-pd-btn-primary" name="add-to-cart"
                                ${empty variants ? 'disabled' : ''}>
                            <i class="fa fa-shopping-cart"></i> Thêm vào giỏ hàng
                        </button>
                        <a href="${ctx}/checkout" class="mb-pd-btn-outline">Mua ngay</a>
                    </div>
                    <p class="mb-pd-delivery-note">
                        <a href="${ctx}/contact">Chính sách giao hàng &amp; đổi trả</a>
                    </p>
                </form>
            </div>
        </div>
    </div>
</div>
<div class="section">
    <!-- container -->
    <div class="container" style="margin-bottom: 20px; margin-top: 20px">
        <!-- row -->
        <div class="row">
            <div class="col-md-12">
                <h4>Đánh giá từ khách hàng</h4>
                <div class="feedback-container">
                    <div class="statatis-feedback">
                        <div class="feadback-total">
                            <h4>${totalStar}<span>/5</span></h4>
                        </div>
                        <div class="feedback-star">
                            <ul class="list-star">
                                <c:if test="${totalStar > 0}">
                                    <c:forEach begin="0" end="${totalStar - 2}">
                                        <li class="star-item active">
                                            <i class="fa fa-star"></i>
                                        </li>
                                    </c:forEach>
                                </c:if>
                                <c:if test="${totalStar <= 5}">
                                    <c:forEach begin="0" end="${4 - totalStar}">
                                        <li class="star-item">
                                            <i class="fa fa-star"></i>
                                        </li>
                                    </c:forEach>
                                </c:if>
                            </ul>
                        </div>
                        <div class="number-feedback">
                            <c:choose>
                                <c:when test="${feedbacks.size() > 0}">
                                    Have <c:out value="${feedbacks.size()}" /> feedbacks
                                </c:when>
                                <c:otherwise>
                                    Chưa có đánh giá cho sản phẩm này
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <c:if test="${feedbacks.size() > 0}">
                        <div class="wrapper-feedback">
                            <ul class="list-feedback">
                                <c:forEach items="${feedbacks}" var="feed">
                                    <c:set var="user" value="${getDao.getUser(feed.userID)}" />
                                    <li class="feedback-item">
                                        <div class="feedback-avatar">
                                            <img src="${user.avatar}"
                                                 alt=""
                                                 />
                                        </div>
                                        <div class="info-feedback">
                                            <h4>${user.fullname != null ? user.fullname : user.username}</h4>
                                            <div class="start-item-feedback">
                                                <c:set var="userStar"  value="${user.star}" />
                                                <ul class="list-star">
                                                    <c:if test="${userStar > 0}">
                                                        <c:forEach begin="0" end="${userStar - 2}">
                                                            <li class="star-item active">
                                                                <i class="fa fa-star"></i>
                                                            </li>
                                                        </c:forEach>
                                                    </c:if>
                                                    <c:if test="${userStar <= 5}">
                                                        <c:forEach begin="0" end="${4 - userStar}">
                                                            <li class="star-item">
                                                                <i class="fa fa-star"></i>
                                                            </li>
                                                        </c:forEach>
                                                    </c:if>
                                                </ul>
                                                <span>
                                                    <c:choose>
                                                        <c:when test="${feed.dateUpdate != null}">
                                                            Cập nhật ${feed.dateUpdate}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Đăng ${feed.datePost}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="feedback-content">
                                                <p>${feed.feedback}</p>
                                            </div>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>
                </div>
            </div>
            <!-- product -->
            <div class="col-md-12">
                <h4>Mô tả sản phẩm</h4>
                ${product.description}
            </div>
            <!-- /product -->
        </div>
        <!-- /row -->
    </div>
    <!-- /container -->
</div>
<!-- Section -->
<div class="section">
    <!-- container -->
    <div class="container" style="margin-bottom: 100px; margin-top: 40px">
        <!-- row -->
        <div class="row">
            <div class="col-md-12">
                <div class="section-title">
                    <h3 class="title">Sản phẩm liên quan</h3>
                </div>
            </div>

            <!-- product -->
            <c:forEach items="${productsRelative}" var="pro" varStatus="status">
                <div class="col-md-3 col-xs-6">
                    <c:set var="cardProduct" value="${pro}" scope="request"/>
                    <c:set var="cardPathUrl" value="${ctx}/product/detail/${product.ID}" scope="request"/>
                    <jsp:include page="components/product-card.jsp"/>
                </div>
                <!-- clearfix for responsive layout -->
                <c:if test="${status.index == 1}">
                    <div class="clearfix visible-sm visible-xs"></div>
                </c:if>
            </c:forEach>
            <!-- /product -->
        </div>
        <!-- /row -->
    </div>
    <!-- /container -->
</div>
<!-- /Section -->
<script src="./user/js/jquery.min.js"></script>
<script charset="UTF-8">
    window.MB_LABELS = {
        currency: "VN\u0111",
        inStock: "C\u00f2n h\u00e0ng",
        outStock: "H\u1ebft h\u00e0ng"
    };
    window.MB_PRODUCT_VARIANTS = ${empty variantsJson ? '[]' : variantsJson};
    window.MB_CTX = '${ctx}';
    window.MB_DEFAULT_VARIANT_ID = ${empty defaultVariant ? 0 : defaultVariant.ID};
    window.MB_MAIN_IMG = '${imgUrl.resolve(product.mainImg, ctx)}';
</script>
<script charset="UTF-8" src="./user/js/product-detail-variant.js"></script>
<script>
    $(document).ready(function () {
        var valueElement = $("#number");
        function incrementValue(e) {
            var max = parseInt(valueElement.attr("max"), 10) || 999;
            var next = parseInt(valueElement.val(), 10) + e.data.increment;
            valueElement.val(Math.min(Math.max(next, 1), max));
            return false;
        }
        $("#increase").bind("click", {increment: 1}, incrementValue);
        $("#decrease").bind("click", {increment: -1}, incrementValue);

        var desc = document.getElementById("mb-pd-desc");
        var seeMore = document.getElementById("mb-pd-see-more");
        if (desc && seeMore && desc.scrollHeight > 80) {
            seeMore.style.display = "inline-block";
            seeMore.addEventListener("click", function () {
                desc.classList.toggle("expanded");
                seeMore.textContent = desc.classList.contains("expanded") ? "Thu gọn" : "Xem thêm...";
            });
        }
    });
</script>
<script>
    document.querySelector('.qty-input').addEventListener('input', function () {
        const min = parseInt(this.min);
        const max = parseInt(this.max);
        const value = parseInt(this.value);

        if (value < min || value > max) {
            Swal.fire({
                title: 'Error!',
                text: 'Số lượng vượt tồn kho hoặc không hợp lệ',
                icon: 'error',
                confirmButtonText: 'OK'
            }).then(() => {
                // Optionally reset the input value to a valid state
                this.value = (value < min) ? min : max;
            });
        }
    });
</script>
<%@include file="./components/footer.jsp" %>

