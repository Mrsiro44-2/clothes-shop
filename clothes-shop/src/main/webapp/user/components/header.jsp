<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:useBean id="currency" class="Utils.CurrencyConverter"></jsp:useBean>
<jsp:useBean id="getDao" class="Utils.GetDAO"></jsp:useBean>
<jsp:useBean id="imgUrl" class="Utils.ImageUrl" scope="application"></jsp:useBean>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="navUri" value="${pageContext.request.requestURI}"/>
<c:set var="navRel" value="${fn:replace(navUri, ctx, '')}"/>
<c:if test="${empty navRel}"><c:set var="navRel" value="/"/></c:if>
<c:set var="navHome" value="${navRel == '/' || navRel == '/index.jsp'}"/>
<c:set var="navShop" value="${fn:indexOf(navRel, '/product') == 0 || fn:indexOf(navRel, '/filter') == 0}"/>
<c:set var="navBlog" value="${fn:indexOf(navRel, '/blog') == 0}"/>
<c:set var="navContact" value="${fn:indexOf(navRel, '/contact') == 0}"/>
<c:set var="navAbout" value="${fn:indexOf(navRel, '/about') == 0}"/>
<c:set var="navCheckout" value="${fn:indexOf(navRel, '/checkout') == 0}"/>
<!DOCTYPE html>
    <html lang="vi">
        <head>
            <meta charset="utf-8" />
            <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${ctx}/" />
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

            <title>Clothes shop</title>

            <!-- Google font -->
            <link
                href="https://fonts.googleapis.com/css?family=Montserrat:400,500,700"
                rel="stylesheet"
                />

            <!-- Bootstrap -->
            <link type="text/css" rel="stylesheet" href="./user/css/bootstrap.min.css" />

            <!-- Slick -->
            <link type="text/css" rel="stylesheet" href="./user/css/slick.css" />
            <link type="text/css" rel="stylesheet" href="./user/css/slick-theme.css" />

            <!-- nouislider -->
            <link type="text/css" rel="stylesheet" href="./user/css/nouislider.min.css" />

            <!-- Font Awesome Icon -->
            <link rel="stylesheet" href="./user/css/font-awesome.min.css" />

            <!-- Custom stlylesheet -->
            <link type="text/css" rel="stylesheet" href="./user/css/style.css" />
            <link type="text/css" rel="stylesheet" href="./user/css/mb-theme.css" />
            <link type="text/css" rel="stylesheet" href="./user/css/mb-header-nav.css" />
            <link type="text/css" rel="stylesheet" href="./user/css/product-card-v2.css" />
            <%@include file="../../components/image-fallback.jsp" %>
        </head>
        <body>
            <!-- HEADER -->
            <header>
                <!-- TOP HEADER -->
                <div id="top-header">
                    <div class="container">
                        <ul class="header-links text-center">
                            <p>
                                Ưu đãi mùa hè — giảm đến 50% và miễn phí giao hàng nhanh!
                                <a href="${ctx}/product">Mua ngay</a>
                            </p>
                        </ul>
                        <!-- Language Selector -->
                        <!-- /Language Selector -->
                    </div>
                </div>
                <!-- /TOP HEADER -->

                <!-- MAIN HEADER -->
                <div id="header">
                    <div class="container">
                        <div class="row mb-header-row">
                            <div class="col-md-3 col-sm-4">
                                <div class="header-logo">
                                    <a href="${ctx}/" class="logo">
                                        <img src="./user/img/logo_nen.png" alt="LA">
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-6 col-sm-8 mb-header-nav-col">
                                <nav id="navigation">
                                    <div id="responsive-nav">
                                        <ul class="main-nav nav navbar-nav">
                                            <li class="${navHome ? 'active' : ''}"><a href="${ctx}/">Trang chủ</a></li>
                                            <li class="${navShop ? 'active' : ''}"><a href="${ctx}/product">Cửa hàng</a></li>
                                            <li class="${navBlog ? 'active' : ''}"><a href="${ctx}/blog">Blog</a></li>
                                            <li class="${navContact ? 'active' : ''}"><a href="${ctx}/contact">Liên hệ</a></li>
                                            <li class="${navAbout ? 'active' : ''}"><a href="${ctx}/about">Giới thiệu</a></li>
                                        </ul>
                                    </div>
                                </nav>
                            </div>
                            <div class="col-md-3 col-sm-12 clearfix">
                                <div class="header-ctn">
                                <c:set var="userLogin" value="${getDao.getAccount(sessionScope.usernameUser)}" />
                                <!-- Wishlist -->
                                <div>
                                    <a href="${pageContext.request.contextPath}/wishlist" title="Yêu thích">
                                        <i class="fa fa-heart-o"></i>
                                    </a>
                                </div>
                                <!-- /Wishlist -->
                                <c:if test="${userLogin != null}">
                                <c:set var="carts" value="" />
                                </c:if>
                                <!-- Cart -->
                                <div class="dropdown">
                                    <a
                                        class="dropdown-toggle"
                                        data-toggle="dropdown"
                                        aria-expanded="true"
                                        >
                                        <i class="fa fa-shopping-cart"></i>
                                        <div class="qty">${empty carts ? 0 : carts.size()}</div>
                                    </a>
                                    <div class="cart-dropdown">
                                        <div class="cart-list">
                                            <c:set var="totalCart" value="0" />
                                            <c:forEach items="${carts}" var="cart">
                                                <c:set var="lineTot" value="${cart.displayUnitPrice * cart.quantity}" />
                                                <c:set var="totalCart" value="${totalCart + lineTot}" />
                                                <div class="product-widget">
                                                    <div class="product-img">
                                                        <c:if test="${not empty cart.mainImg}">
                                                            <img class="mb-img" src="${imgUrl.resolve(cart.mainImg, ctx)}" alt="${cart.productName}" onerror="mbImgOnError(this)"/>
                                                        </c:if>
                                                    </div>
                                                    <div class="product-body">
                                                        <h3 class="product-name">
                                                            <a href="${ctx}/product/detail/${cart.productID}">${cart.productName}</a>
                                                        </h3>
                                                        <p class="mb-cart-meta" style="margin:0;font-size:11px;color:#8d99ae">
                                                            <c:if test="${not empty cart.colorName}">Màu: ${cart.colorName}</c:if>
                                                            <c:if test="${not empty cart.sizeLabel}"> · Size: ${cart.sizeLabel}</c:if>
                                                        </p>
                                                        <h4 class="product-price">
                                                            <span class="qty">${cart.quantity}x</span>
                                                            ${currency.currencyFormat(lineTot)}
                                                        </h4>
                                                    </div>
                                                    <button class="delete">
                                                        <i class="fa fa-close"></i>
                                                    </button>
                                                </div>
                                            </c:forEach>
                                            <c:if test="${carts.size() == 0}">
                                                <p style="padding:12px 15px;margin:0;font-size:13px;color:#8d99ae">Giỏ hàng trống</p>
                                            </c:if>
                                        </div>
                                        <c:if test="${carts.size() > 0}">
                                            <div class="cart-summary">
                                                <small>${carts.size()} sản phẩm đã chọn</small>
                                                <h5>Tạm tính: ${currency.currencyFormat(totalCart)}</h5>
                                            </div>
                                            <div class="cart-btns">
                                                <a href="${ctx}/cart">Xem giỏ hàng</a>
                                                <a href="${ctx}/checkout"
                                                   >Thanh toán <i class="fa fa-arrow-circle-right"></i
                                                    ></a>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                                <!-- /Cart -->

                                <!-- Account -->

                                <div class="dropdown">
                                    <c:set var="userLoginRole" value="${sessionScope.usernameRole}" />
                                    <c:set var="userLoginUsername" value="${sessionScope.usernameUser}" />
                                    <c:if test="${!(userLoginUsername != null && userLoginRole != null)}">
                                        <a href="${ctx}/login"
                                           class="dropdown-toggle"
                                           >
                                            <i class="fa fa-user-o"></i>
                                        </a>
                                    </c:if>
                                    <c:if test="${userLoginUsername != null && userLoginRole != null}">
                                        <a 
                                            class="dropdown-toggle"
                                            data-toggle="dropdown"
                                            aria-expanded="true"
                                            >
                                            <i class="fa fa-user-o"></i>
                                        </a>
                                        <div class="account-dropdown">
                                            <div>
                                                <a href="${pageContext.request.contextPath}/account">
                                                    <i class="fa fa-user-o" style="margin-right: 15px"></i>
                                                    Tài khoản
                                                </a>
                                            </div>
                                            <div>
                                                <a href="${pageContext.request.contextPath}/orders"><i class="fa fa-shopping-cart" style="margin-right: 15px"></i>Đơn hàng</a>
                                            </div>
                                            <div>
                                                <a href="${pageContext.request.contextPath}/orders?tab=cancelled"><i class="fa fa-times-circle" style="margin-right: 15px"></i>Đơn đã hủy</a>
                                            </div>
                                            <div>
                                                <a href="${pageContext.request.contextPath}/orders?tab=reviews"><i class="fa fa-star" style="margin-right: 15px"></i>Đánh giá</a>
                                            </div>
                                            <div>
                                                <a href="${pageContext.request.contextPath}/logout"><i class="fa fa-sign-out" style="margin-right: 15px"></i>Đăng xuất</a>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                                <!-- /Account -->

                                <!-- Menu Toogle -->
                                <div class="menu-toggle">
                                    <a href="#">
                                        <i class="fa fa-bars"></i>
                                        <span>Danh mục</span>
                                    </a>
                                </div>
                                <!-- /Menu Toogle -->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /MAIN HEADER -->
        </header>
        <!-- /HEADER -->

