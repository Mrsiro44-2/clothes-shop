<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="./components/header.jsp" %>
<!-- SECTION -->
<div class="section">
    <div class="container">
        <div class="row" style="margin-bottom: 80px; margin-top: 30px">
            <div class="col-md-6">
                <img src="./user/img/signUp.png" alt="Đăng nhập Mom &amp; Baby" style="width: 100%" />
            </div>
            <div class="col-md-6" style="padding: 100px; margin-top: 70px">
                <h2>Đăng nhập</h2>
                <p>Nhập thông tin tài khoản của bạn</p>
                <form action="${ctx}/login" method="post">
                    <div style="width: 400px; margin-bottom: 20px; margin-top: 20px">
                        <input
                            class="input"
                            type="text"
                            name="username"
                            placeholder="Tên đăng nhập"
                            />
                    </div>
                    <div style="width: 400px">
                        <input
                            class="input"
                            type="password"
                            name="password"
                            placeholder="Mật khẩu"
                            />
                    </div>
                    <div>
                        <div
                            style="
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-top: 40px;
                            "
                            >
                            <button
                                class="btn btn-default"
                                name="submitLogin"
                                style="
                                padding: 10px;
                                color: #fff;
                                background-color: #db4444;
                                margin-bottom: 20px;
                                "
                                >
                                Đăng nhập
                            </button>
                            <a href="${ctx}/forgot-password">Quên mật khẩu?</a>
                        </div>
                        <span style="display: block;color: red">${messageUserAuth}</span>
                        <div class="text-center">
                            <p>Chưa có tài khoản? <a href="${ctx}/register">Đăng ký ngay</a></p>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<%@include file="./components/footer.jsp" %>
