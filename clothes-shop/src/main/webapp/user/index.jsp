<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="./components/header.jsp" %>
<c:if test="${empty homeBanners}">
    <jsp:useBean id="appImagesFallback" class="Utils.AppImages"/>
    <c:set var="homeBanners" value="${appImagesFallback.homeBannerList}"/>
</c:if>
<jsp:useBean id="sale" class="Utils.Sale"></jsp:useBean>
    <!-- section -->
    <div class="section">
        <div class="container">
            <div class="row">
                <div
                    class="col-md-2"
                    style="border-right: 1px solid black; border-top: 1px solid black; max-height: 290px;
                    overflow-y: auto;
                    "
                    >
                <c:forEach items="${categories}" var="cate" varStatus="i">
                    <p style="${i.index == 0 ? "margin-top: 20px" : ""}">
                        <a href="${ctx}/product/?type=category&id=${cate.ID}">${cate.name}</a>
                    </p>
                </c:forEach>
            </div>
            <div class="col-md-10" style="border-top: 1px solid black">
                <div
                    id="carousel-example-generic"
                    class="carousel slide"
                    data-ride="carousel"
                    >
                    <!-- Indicators -->
                    <ol class="carousel-indicators">
                        <c:forEach items="${homeBanners}" var="banner" varStatus="i">
                            <li
                                data-target="#carousel-example-generic"
                                data-slide-to="${i.index}"
                                class="${i.index == 0 ? "active" : ""}"
                                ></li>
                            </c:forEach>
                    </ol>

                    <!-- Wrapper for slides -->
                    <div class="carousel-inner" role="listbox">
                        <c:forEach items="${homeBanners}" var="bannerUrl" varStatus="i">
                            <div class="item ${i.index == 0 ? 'active' : ''}">
                                <img src="${bannerUrl}" alt="Banner ${i.index + 1}" class="mb-img" onerror="mbImgOnError(this)" style="width:100%;height:320px;object-fit:cover"/>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Controls -->
                    <a
                        class="left carousel-control"
                        href="#carousel-example-generic"
                        role="button"
                        data-slide="prev"
                        style="top: 50%; transform: translateY(-50%)"
                        >
                        <i
                            class="fa fa-chevron-left"
                            aria-hidden="true"
                            style="margin-top: 50%"
                            ></i>
                        <span class="sr-only">Trước</span>
                    </a>
                    <a
                        class="right carousel-control"
                        href="#carousel-example-generic"
                        role="button"
                        data-slide="next"
                        style="top: 50%; transform: translateY(-50%)"
                        >
                        <i
                            class="fa fa-chevron-right"
                            aria-hidden="true"
                            style="margin-top: 50%"
                            ></i>
                        <span class="sr-only">Sau</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- /section -->

<div class="section">
    <div class="container">
        <div class="abc">
            <div class="red-bar">|</div>
            <div class="category-text"><Strong>Hôm nay</Strong></div>
        </div>
    </div>
</div>

<!-- SECTION -->
<div class="section">
    <!-- container -->
    <div class="container">
        <!-- row -->
        <div class="row">
            <!-- section title -->
            <div class="col-md-12">
                <div class="section-title">
                    <h2 class="title">Ưu đãi</h2>
                    <div class="section-nav">
                        <div id="slick-nav-9" class="products-slick-nav"></div>
                    </div>
                </div>
            </div>
            <!-- /section title -->

            <!-- Products tab & slick -->
            <div class="col-md-12">
                <div class="row">
                    <div class="products-tabs">
                        <!-- tab -->
                        <div id="tab2" class="tab-pane fade in active">
                            <div class="products-slick" data-nav="#slick-nav-9">
                                <!-- product -->
                                <c:forEach items="${productsDeal}" var="productDeal">
                                    <c:set var="cardProduct" value="${productDeal}" scope="request"/>
                                    <c:set var="cardPathUrl" value="${ctx}" scope="request"/>
                                    <jsp:include page="components/product-card.jsp"/>
                                </c:forEach>
                            </div>
                        </div>
                        <!-- /tab -->
                    </div>
                </div>
            </div>
            <!-- /Products tab & slick -->

            <!-- button -->
            <div class="col-md-12 text-center" style="margin-top: 55px">
                <a href="${ctx}/product">
                    <button
                        class="btn btn-default"
                        style="
                        padding: 10px;
                        color: #fff;
                        background-color: #db4444;
                        margin-bottom: 20px;
                        "
                        >
                        Xem tất cả sản phẩm
                    </button>
                </a>
            </div>
            <!-- /button -->
        </div>
        <!-- /row -->
    </div>
    <!-- /container -->
</div>
<!-- /SECTION -->

<div class="section">
    <div class="container">
        <div class="abc">
            <div class="red-bar">|</div>
            <div class="category-text"><Strong>Thương hiệu</Strong></div>
        </div>
    </div>
</div>

<!-- SECTION -->
<div class="section">
    <!-- container -->
    <div class="container">
        <!-- row -->
        <div class="row">
            <!-- section title -->
            <div class="col-md-12">
                <div class="section-title">
                    <h3 class="title">Thương hiệu</h3>
                    <div class="section-nav">
                        <div id="slick-nav-5" class="products-slick-nav"></div>
                    </div>
                </div>
            </div>
            <!-- /section title -->
            <!-- category -->
            <div class="col-md-12">
                <div class="row">
                    <c:forEach items="${brands}" var="br">
                        <div class="col-md-2">
                            <div
                                class="order-summary text-center"
                                style="border: 1px solid black; padding: 15px; margin: 20px"
                                >
                                <a href="${ctx}/product?type=brand&id=${br.ID}">
                                    <div class="product-btns" style="margin-bottom: 20px">
                                        <img class="mb-img" src="${imgUrl.resolve(br.img, ctx)}" alt="${br.name}" height="56" width="93" style="object-fit:contain" onerror="mbImgOnError(this)"/>
                                    </div>
                                    <p>${br.name}</p>
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <!-- /category -->
        </div>
        <!-- /row -->
    </div>
    <!-- /container -->
</div>
<!-- /SECTION -->

<div class="section">
    <div class="container">
        <div class="abc">
            <div class="red-bar">|</div>
            <div class="category-text"><Strong>Tháng này</Strong></div>
        </div>
    </div>
</div>

<!-- SECTION -->
<div class="section">
    <!-- container -->
    <div class="container">
        <!-- row -->
        <div class="row">
            <!-- section title -->
            <div class="col-md-12">
                <div class="section-title">
                    <h3 class="title">Sản phẩm bán chạy</h3>
                    <div class="section-nav">
                        <a href="${ctx}/product">
                            <button
                                class="btn btn-default"
                                style="
                                padding: 10px;
                                color: #fff;
                                background-color: #db4444;
                                margin-bottom: 20px;
                                "
                                >
                                Xem tất cả
                            </button>
                        </a>
                    </div>
                </div>
            </div>
            <!-- /section title -->

            <!-- Products tab & slick -->
            <div class="col-md-12">
                <div class="row">
                    <div class="products-tabs">
                        <!-- tab -->
                        <div id="tab1" class="tab-pane active">
                            <div class="products-slick" data-nav="#slick-nav-1">
                                <!-- product -->
                                <c:forEach items="${productsFeature}" var="productFeature">
                                    <c:set var="cardProduct" value="${productFeature}" scope="request"/>
                                    <c:set var="cardPathUrl" value="${ctx}" scope="request"/>
                                    <jsp:include page="components/product-card.jsp"/>
                                </c:forEach>
                            </div>
                            <div id="slick-nav-1" class="products-slick-nav"></div>
                        </div>
                        <!-- /tab -->
                    </div>
                </div>
            </div>
            <!-- Products tab & slick -->
        </div>
        <!-- /row -->
    </div>
    <!-- /container -->
</div>
<!-- /SECTION -->

<!-- HOT DEAL SECTION -->
<div id="hot-deal" class="section">
    <!-- container -->
    <div class="container">
        <!-- row -->
        <div class="row">
            <div class="col-md-12">
                <div class="hot-deal">
                    <h2 class="text-uppercase">Ưu đãi tuần này</h2>
                    <p>Bộ sưu tập mới — giảm đến 50%</p>
                    <a class="primary-btn cta-btn" href="${ctx}/product">Mua ngay</a>
                </div>
            </div>
        </div>
        <!-- /row -->
    </div>
    <!-- /container -->
</div>
<!-- /HOT DEAL SECTION -->

<div class="section">
    <div class="container">
        <div class="abc">
            <div class="red-bar">|</div>
            <div class="category-text"><Strong>Sản phẩm</Strong></div>
        </div>
    </div>
</div>

<!-- SECTION -->
<div class="section">
    <!-- container -->
    <div class="container">
        <!-- row -->
        <div class="row">
            <!-- section title -->
            <div class="col-md-12">
                <div class="section-title">
                    <h3 class="title">Khám phá sản phẩm</h3>
                    <div class="section-nav">
                        <div id="slick-nav-2" class="products-slick-nav"></div>
                    </div>
                </div>
            </div>
            <!-- /section title -->

            <!-- Products tab & slick -->
            <div class="col-md-12">
                <div class="row">
                    <div class="products-tabs">
                        <!-- tab -->
                        <div id="tab2" class="tab-pane fade in active">
                            <div class="products-slick" data-nav="#slick-nav-2">
                                <c:forEach items="${productsNormal}" var="productNormal">
                                    <c:set var="cardProduct" value="${productNormal}" scope="request"/>
                                    <c:set var="cardPathUrl" value="${ctx}" scope="request"/>
                                    <jsp:include page="components/product-card.jsp"/>
                                </c:forEach>
                            </div>
                        </div>
                        <!-- /tab -->
                    </div>
                </div>
            </div>
            <!-- /Products tab & slick -->

            <!-- button -->
            <div class="col-md-12 text-center" style="margin-top: 55px">
                <a href="${ctx}/product">
                    <button
                        class="btn btn-default"
                        style="
                        padding: 10px;
                        color: #fff;
                        background-color: #db4444;
                        margin-bottom: 20px;
                        "
                        >
                        Xem tất cả sản phẩm
                    </button>
                </a>
            </div>
            <!-- /button -->
        </div>
        <!-- /row -->
    </div>
    <!-- /container -->
</div>
<!-- /SECTION -->
<!-- /section -->

<!-- section -->
<div class="section" style="margin-bottom: 40px">
    <div class="container">
        <div class="row">
            <div class="col-md-4 text-center">
                <div class="product-btns" style="margin-bottom: 20px">
                    <button class="btn-fa">
                        <i class="fa fa-truck fa-2x"></i>
                    </button>
                </div>
                <h4>FREE AND FAST DELIVERY</h4>
                <p>Free delivery for all orders over $140</p>
            </div>
            <div class="col-md-4 text-center">
                <div class="product-btns" style="margin-bottom: 20px">
                    <button class="btn-fa">
                        <i class="fa fa-headphones fa-2x"></i>
                    </button>
                </div>
                <h4>24/7 CUSTOMER SERVICE</h4>
                <p>Friendly 24/7 customer support</p>
            </div>
            <div class="col-md-4 text-center">
                <div class="product-btns" style="margin-bottom: 20px">
                    <button class="btn-fa">
                        <i class="fa fa-shield fa-2x"></i>
                    </button>
                </div>
                <h4>MONEY BACK GUARANTEE</h4>
                <p>We reurn money within 30 days</p>
            </div>
        </div>
    </div>
</div>
<%@include file="./components/footer.jsp" %>
