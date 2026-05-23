<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:if test="${empty ctx}"><c:set var="ctx" value="${pageContext.request.contextPath}"/></c:if>

<!-- FOOTER -->

<footer id="footer">

    <!-- top footer -->

    <div class="section">

        <!-- container -->

        <div class="container">

            <!-- row -->

            <div class="row">

                <div class="col-md-3 col-xs-6">

                    <div class="footer">

                        <h3 class="footer-title">Clothes shop</h3>

                        <h4 style="color: #fff">Đăng ký nhận tin</h4>

                        <p style="margin-top: 20px">Giảm 10% cho đơn đầu tiên của bạn</p>

                        <form style="margin-top: 20px">

                            <input

                                class="input"

                                type="email"

                                placeholder="Nhập email của bạn"

                                />

                            <i class="fa fa-send"></i>

                        </form>

                    </div>

                </div>



                <div class="col-md-2 col-xs-6">

                    <div class="footer">

                        <h3 class="footer-title">Hỗ trợ</h3>

                        <ul class="footer-links">

                            <li>

                                <a href="#"

                                   ><i class="fa fa-map-marker"></i> 123 Đường ABC, Q.1, TP.HCM</a

                                >

                            </li>

                            <li>

                                <a href="tel:19001234"><i class="fa fa-phone"></i> 1900 1234</a>

                            </li>

                            <li>

                                <a href="mailto:hotro@momandbaby.vn"

                                   ><i class="fa fa-envelope-o"></i> hotro@clothesshop.vn</a

                                >

                            </li>

                        </ul>

                    </div>

                </div>



                <div class="clearfix visible-xs"></div>



                <div class="col-md-2 col-xs-6">

                    <div class="footer">

                        <h3 class="footer-title">Tài khoản</h3>

                        <ul class="footer-links">

                            <li><a href="${ctx}/account">Tài khoản của tôi</a></li>

                            <li><a href="${ctx}/login">Đăng nhập / Đăng ký</a></li>

                            <li><a href="${ctx}/cart">Giỏ hàng</a></li>

                            <li><a href="${ctx}/wishlist">Yêu thích</a></li>

                            <li><a href="${ctx}/product">Cửa hàng</a></li>

                        </ul>

                    </div>

                </div>



                <div class="col-md-2 col-xs-6">

                    <div class="footer">

                        <h3 class="footer-title">Liên kết</h3>

                        <ul class="footer-links">

                            <li><a href="${ctx}/about">Giới thiệu</a></li>

                            <li><a href="${ctx}/blog">Blog</a></li>

                            <li><a href="${ctx}/contact">Liên hệ</a></li>

                            <li><a href="${ctx}/orders">Đơn hàng</a></li>

                        </ul>

                    </div>

                </div>

                <div class="col-md-3 col-xs-6">

                    <div class="footer">

                        <h3 class="footer-title">Kết nối</h3>

                        <p>Theo dõi Clothes shop; Baby trên mạng xã hội</p>

                        <ul class="footer-links" style="margin-top: 15px">

                            <li>

                                <a href="#"><i class="fa fa-facebook"></i></a>

                                <a href="#"><i class="fa fa-twitter"></i></a>

                                <a href="#"><i class="fa fa-instagram"></i></a>

                                <a href="#"><i class="fa fa-linkedin"></i></a>

                            </li>

                        </ul>

                    </div>

                </div>

            </div>

            <!-- /row -->

        </div>

        <!-- /container -->

    </div>

    <!-- /top footer -->



    <!-- bottom footer -->

    <div id="bottom-footer" class="section">

        <div class="container">

            <!-- row -->

            <div class="row">

                <div class="col-md-12 text-center">

                    <ul class="footer-payments">

                        <li>

                            <a href="#"><i class="fa fa-cc-visa"></i></a>

                        </li>

                        <li>

                            <a href="#"><i class="fa fa-credit-card"></i></a>

                        </li>

                        <li>

                            <a href="#"><i class="fa fa-cc-paypal"></i></a>

                        </li>

                        <li>

                            <a href="#"><i class="fa fa-cc-mastercard"></i></a>

                        </li>

                        <li>

                            <a href="#"><i class="fa fa-cc-discover"></i></a>

                        </li>

                        <li>

                            <a href="#"><i class="fa fa-cc-amex"></i></a>

                        </li>

                    </ul>

                    <span class="copyright">

                        &copy;

                        <script>

                            document.write(new Date().getFullYear());

                        </script>

                        Clothing shop. Bảo lưu mọi quyền.

                    </span>

                </div>

            </div>

            <!-- /row -->

        </div>

        <!-- /container -->

    </div>

    <!-- /bottom footer -->

</footer>

<!-- /FOOTER -->



<!-- jQuery Plugins -->

<script>

    var baseURL = window.location.origin + window.location.pathname;

    window.history.replaceState({}, document.title, baseURL);</script>

<script src="./user/js/jquery.min.js"></script>

<script src="./user/js/bootstrap.min.js"></script>

<script src="./user/js/slick.min.js"></script>

<script src="./user/js/nouislider.min.js"></script>

<script src="./user/js/jquery.zoom.min.js"></script>

<script src="./user/js/main.js"></script>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script src="${pageContext.request.contextPath}/user/js/mb-swal.js?v=3" charset="UTF-8"></script>

<%@include file="./flash-swal.jsp" %>

<jsp:useBean id="convertActionText" scope="page" class="Utils.ConvertActionText"></jsp:useBean>

<c:set var="type_message" value="${param.status}"/>

<c:set var="action" value="${param.act}"/>

<script>

    document.addEventListener('DOMContentLoaded', function () {

        <c:if test="${type_message != null && type_message == 1}">

        if (typeof MbSwal !== 'undefined') {

            MbSwal.success(null, '<c:out value="${convertActionText.convertActionText(action, type_message)}"/>');

        }

        </c:if>

        <c:if test="${type_message != null && (type_message == 0 || type_message == 2 || type_message == 3)}">

        if (typeof MbSwal !== 'undefined') {

            MbSwal.error(null, '<c:out value="${convertActionText.convertActionText(action, type_message)}"/>');

        }

        </c:if>

    });

</script>

            </body>

            </html>



