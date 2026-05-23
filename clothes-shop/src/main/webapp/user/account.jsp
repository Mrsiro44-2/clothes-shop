<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="./components/header.jsp" %>
<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
            <li class="active">Tài khoản</li>
        </ul>
    </div>
</div>
<div class="section">
    <div class="container">
        <h2 class="title">Tài khoản của tôi</h2>
        <div class="row" style="margin-top:24px">
            <div class="col-md-4">
                <ul class="list-group">
                    <li class="list-group-item active">Thông tin cá nhân</li>
                    <li class="list-group-item"><a href="${pageContext.request.contextPath}/orders">Đơn hàng</a></li>
                    <li class="list-group-item"><a href="${pageContext.request.contextPath}/wishlist">Yêu thích</a></li>
                </ul>
            </div>
            <div class="col-md-8">
                <form id="accountProfileForm" action="${pageContext.request.contextPath}/account" method="post" novalidate>
                    <div class="form-group">
                        <label>Họ tên</label>
                        <input id="accFullname" class="form-control input" name="fullname" required value="${account.fullname}"/>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input id="accEmail" class="form-control input" name="email" type="email" required value="${account.email}"/>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input id="accPhone" class="form-control input" name="phone" required
                               value="${account.phone != null ? account.phone : ''}"
                               placeholder="VD: 0912345678"/>
                    </div>
                    <div class="form-group">
                        <label>Mật khẩu mới (để trống nếu không đổi)</label>
                        <input id="accPassword" class="form-control input" name="password" type="password" minlength="6" autocomplete="new-password"/>
                    </div>
                    <div class="form-group">
                        <label>Xác nhận mật khẩu mới</label>
                        <input id="accConfirmPassword" class="form-control input" name="confirmPassword" type="password" minlength="6" autocomplete="new-password"/>
                    </div>
                    <button type="submit" class="primary-btn" style="padding:10px 20px;border:none">Lưu thay đổi</button>
                </form>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        if (typeof MbSwal !== 'undefined') {
                            MbSwal.initAccountProfileForm('accountProfileForm', 'Tài khoản');
                        }
                    });
                </script>
            </div>
        </div>
    </div>
</div>
<%@include file="./components/footer.jsp" %>

