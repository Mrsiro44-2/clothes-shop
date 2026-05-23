<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="./components/header.jsp" %>
<div class="section">
    <div class="container">
        <div class="row" style="margin-bottom: 80px; margin-top: 30px">
            <div class="col-md-6">
                <img src="./user/img/signUp.png" alt="Đăng ký Mom &amp; Baby" style="width: 100%" />
            </div>
            <form action="${ctx}/register" method="post">
                <div class="col-md-6" style="padding: 100px">
                    <h2>Tạo tài khoản</h2>
                    <p>Điền thông tin bên dưới để đăng ký</p>
                    <div style="width: 400px; margin-bottom: 20px; margin-top: 20px">
                        <input class="input" type="text" name="fullname" placeholder="Họ và tên" />
                    </div>
                    <div style="width: 400px; margin-bottom: 20px">
                        <input class="input" type="text" name="username" placeholder="Tên đăng nhập" />
                    </div>
                    <div style="width: 400px; margin-bottom: 20px">
                        <input class="input" type="text" name="email" placeholder="Email" />
                    </div>
                    <div style="width: 400px; margin-bottom: 20px">
                        <input class="input" type="text" name="phone" placeholder="Số điện thoại" />
                    </div>
                    <div style="width: 400px; margin-bottom: 20px">
                        <input class="input" type="password" name="password" placeholder="Mật khẩu" />
                    </div>
                       <div style="width: 400px">
                        <input class="input form-control" type="password" id="confirmPassword" name="confirmPassword"
                               placeholder="Nhập lại mật khẩu" minlength="6" required autocomplete="new-password" style="width:100%"/>
                    </div>
                    <div style="margin-top: 40px">
                        <button
                            class="btn btn-default"
                            name="register"
                            style="
                            width: 400px;
                            padding: 10px;
                            color: #fff;
                            background-color: #db4444;
                            margin-bottom: 20px;
                            "
                            >
                            Đăng ký
                        </button>
                    </div>
                    <div>
                        <span style="display: block;color: red; text-align: center">
                            ${messageFailRegister}
                        </span>
                    </div>
                    <div class="text-center">
                        <p>Đã có tài khoản? <a href="${ctx}/login">Đăng nhập</a></p>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<%@include file="./components/footer.jsp" %>
