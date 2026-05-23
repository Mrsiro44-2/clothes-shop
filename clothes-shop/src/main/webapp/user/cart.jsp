<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="./components/header.jsp" %>
<link type="text/css" rel="stylesheet" href="./user/css/cart-v2.css" />

<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${ctx}/home">Trang chủ</a></li>
            <li class="active">Giỏ hàng</li>
        </ul>
    </div>
</div>

<div class="section mb-cart-page">
    <div class="container">
        <c:set var="totalCartPage" value="0" />
        <c:set var="totalQty" value="0" />
        <c:forEach items="${carts}" var="cart">
            <c:set var="lineTot" value="${cart.displayUnitPrice * cart.quantity}" />
            <c:set var="totalCartPage" value="${totalCartPage + lineTot}" />
            <c:set var="totalQty" value="${totalQty + cart.quantity}" />
        </c:forEach>

        <div class="mb-cart-layout">
            <div class="mb-cart-main">
                <div class="mb-cart-head">
                    <h2>Giỏ hàng</h2>
                    <span class="mb-cart-count">${carts.size()} sản phẩm · ${totalQty} món</span>
                </div>

                <c:if test="${empty carts}">
                    <div class="mb-cart-empty">
                        <p>Giỏ hàng trống.</p>
                        <a href="${ctx}/product" class="mb-cart-continue">Tiếp tục mua sắm →</a>
                    </div>
                </c:if>

                <c:if test="${not empty carts}">
                    <form action="${ctx}/cart" method="post" id="mbCartForm">
                        <div class="mb-cart-table-head">
                            <span>Sản phẩm</span>
                            <span>Số lượng</span>
                            <span>Đơn giá</span>
                            <span style="text-align:right">Thành tiền</span>
                        </div>

                        <c:forEach items="${carts}" var="cart">
                            <c:set var="unitPrice" value="${cart.displayUnitPrice}" />
                            <c:set var="lineTotal" value="${unitPrice * cart.quantity}" />
                            <div class="mb-cart-row">
                                <div class="mb-cart-product">
                                    <a href="${ctx}/product/detail/${cart.productID}">
                                        <img class="mb-img" src="${imgUrl.resolve(cart.mainImg, ctx)}"
                                             alt="${cart.productName}" onerror="mbImgOnError(this)"/>
                                    </a>
                                    <div class="mb-cart-product-info">
                                        <h4><a href="${ctx}/product/detail/${cart.productID}">${cart.productName}</a></h4>
                                        <p class="mb-cart-variant-meta">
                                            <c:if test="${not empty cart.colorName}">Màu: ${cart.colorName}</c:if>
                                            <c:if test="${not empty cart.sizeLabel}">
                                                <c:if test="${not empty cart.colorName}"> · </c:if>
                                                Size: ${cart.sizeLabel}
                                            </c:if>
                                        </p>
                                        <button type="button" class="mb-cart-remove"
                                                onclick="confirmRemove('${cart.ID}')">Xóa</button>
                                    </div>
                                </div>
                                <div>
                                    <div class="mb-cart-qty">
                                        <button type="button" class="mb-qty-dec">−</button>
                                        <input type="number" class="qty-input" name="qty_v_${cart.productVariantID}"
                                               value="${cart.quantity}" min="1" max="${cart.stockQty}"/>
                                        <button type="button" class="mb-qty-inc">+</button>
                                    </div>
                                </div>
                                <div class="mb-cart-price">${currency.currencyFormat(unitPrice)}</div>
                                <div class="mb-cart-line-total" style="text-align:right">
                                    ${currency.currencyFormat(lineTotal)}
                                </div>
                            </div>
                        </c:forEach>

                        <button type="submit" name="btn-update-cart" class="mb-cart-update-btn">Cập nhật giỏ hàng</button>
                        <a href="${ctx}/product" class="mb-cart-continue">← Tiếp tục mua sắm</a>
                    </form>
                </c:if>
            </div>

            <div class="mb-cart-summary-panel">
                <h3>Tóm tắt đơn</h3>
                <div class="mb-cart-summary-line">
                    <span>SẢN PHẨM (${totalQty})</span>
                    <strong>${currency.currencyFormat(totalCartPage)}</strong>
                </div>
                <div class="mb-cart-summary-line">
                    <span>PHÍ GIAO HÀNG</span>
                    <strong>Miễn phí</strong>
                </div>
                <div class="mb-cart-promo">
                    <label>MÃ GIẢM GIÁ</label>
                    <form action="${ctx}/voucher" method="post" class="mb-cart-promo-row">
                        <input type="text" name="couponCode" placeholder="Nhập mã voucher"/>
                        <button type="submit" name="use-voucher">ÁP DỤNG</button>
                    </form>
                    <c:if test="${sessionScope.couponStatus == 'invalid'}">
                        <p style="color:#d10024;font-size:12px;margin-top:8px">Mã không hợp lệ.</p>
                    </c:if>
                    <c:if test="${sessionScope.couponStatus == 'expired'}">
                        <p style="color:#d10024;font-size:12px;margin-top:8px">Mã đã hết hạn.</p>
                    </c:if>
                    <c:if test="${sessionScope.couponStatus == 'applied'}">
                        <p style="color:#DB4444;font-size:12px;margin-top:8px">Đã áp dụng mã giảm giá.</p>
                    </c:if>
                </div>
                <c:if test="${sessionScope.discount != null && sessionScope.discount > 0}">
                    <div class="mb-cart-summary-line">
                        <span>GIẢM GIÁ</span>
                        <strong>-${currency.currencyFormat(sessionScope.discount)}</strong>
                    </div>
                </c:if>
                <div class="mb-cart-summary-total">
                    <span>TỔNG CỘNG</span>
                    <span>
                        <c:choose>
                            <c:when test="${sessionScope.newTotal != null}">
                                ${currency.currencyFormat(sessionScope.newTotal)}
                            </c:when>
                            <c:otherwise>
                                ${currency.currencyFormat(totalCartPage)}
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <c:if test="${not empty carts}">
                    <a href="${ctx}/checkout" class="mb-cart-checkout">THANH TOÁN</a>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
    document.querySelectorAll('.mb-cart-qty').forEach(function (wrap) {
        var input = wrap.querySelector('input');
        var dec = wrap.querySelector('.mb-qty-dec');
        var inc = wrap.querySelector('.mb-qty-inc');
        if (!input) return;
        dec.addEventListener('click', function () {
            var v = parseInt(input.value, 10) || 1;
            input.value = Math.max(1, v - 1);
        });
        inc.addEventListener('click', function () {
            var v = parseInt(input.value, 10) || 1;
            var max = parseInt(input.max, 10) || 999;
            input.value = Math.min(max, v + 1);
        });
    });

    document.querySelectorAll('.qty-input').forEach(function (input) {
        input.addEventListener('change', function () {
            var min = parseInt(this.min, 10) || 1;
            var max = parseInt(this.max, 10) || 999;
            var value = parseInt(this.value, 10);
            if (isNaN(value) || value < min || value > max) {
                if (typeof Swal !== 'undefined') {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Số lượng',
                        text: 'Số lượng không hợp lệ hoặc vượt tồn kho.',
                        confirmButtonColor: '#D10024'
                    });
                }
                this.value = value < min ? min : (value > max ? max : min);
            }
        });
    });

    function confirmRemove(cartId) {
        Swal.fire({
            title: 'Xóa sản phẩm?',
            text: 'Bạn có chắc muốn xóa khỏi giỏ hàng?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#D10024',
            cancelButtonColor: '#8d99ae',
            confirmButtonText: 'Xóa',
            cancelButtonText: 'Hủy'
        }).then(function (result) {
            if (result.isConfirmed) {
                window.location.href = '${ctx}/cart/remove?cartId=' + cartId;
            }
        });
    }

    (function () {
        var params = new URLSearchParams(window.location.search);
        if (params.get('act') !== 'add-cart') return;
        var st = params.get('status');
        var text = 'Không thể thêm vào giỏ.';
        var icon = 'error';
        if (st === '1') { text = 'Đã thêm vào giỏ hàng.'; icon = 'success'; }
        else if (st === '2') { text = 'Số lượng vượt tồn kho.'; icon = 'warning'; }
        if (typeof Swal !== 'undefined') {
            Swal.fire({ icon: icon, title: 'Giỏ hàng', text: text, confirmButtonColor: '#D10024' });
        }
    })();
</script>
<%@include file="./components/footer.jsp" %>
