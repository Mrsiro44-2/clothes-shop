package Controllers.User;

import Authentication.AuthUser;
import DAO.AccountDAO;
import Model.Account;
import Utils.AccountProfileValidator;
import Utils.ServletPaths;
import Utils.SwalFlash;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet(name = "AccountUserController", urlPatterns = {"/account", "/logout"})
public class AccountUserController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getRequestURI();
        if (path.contains("/logout")) {
            request.getSession().invalidate();
            ServletPaths.redirect(request, response, "/home");
            return;
        }
        AuthUser auth = new AuthUser();
        String username = auth.isLoginUser(request, response);
        if (username == null) {
            ServletPaths.redirect(request, response, "/login");
            return;
        }
        AccountDAO accountDao = new AccountDAO();
        Account account = accountDao.getAccountByUsername(username);
      
        request.setAttribute("account", account);
        request.getRequestDispatcher("/user/account.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getRequestURI();
        AuthUser auth = new AuthUser();
        String username = auth.isLoginUser(request, response);
        if (username == null) {
            ServletPaths.redirect(request, response, "/login");
            return;
        }
        AccountDAO accountDao = new AccountDAO();
        Account account = accountDao.getAccountByUsername(username);

        if (path.contains("/account")) {
            updateProfile(request, response, account, accountDao);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response,
            Account account, AccountDAO accountDao) throws IOException, ServletException {
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        String err = AccountProfileValidator.validate(fullname, email, phone, newPassword, confirmPassword);
        if (err != null) {
            SwalFlash.error(request, "Tài khoản", err);
            request.setAttribute("account", account);
            request.getRequestDispatcher("/user/account.jsp").forward(request, response);
            return;
        }

        String emailNorm = AccountProfileValidator.normalizeEmail(email);
        if (accountDao.isEmailTakenByOther(account.getID(), emailNorm)) {
            SwalFlash.error(request, "Tài khoản", "Email đã được sử dụng bởi tài khoản khác.");
            request.setAttribute("account", account);
            request.getRequestDispatcher("/user/account.jsp").forward(request, response);
            return;
        }

        account.setFullname(fullname.trim());
        account.setPhone(AccountProfileValidator.normalizePhone(phone));
        account.setEmail(emailNorm);

        int r = accountDao.updatePersonalUser(account);
        if (r > 0 && newPassword != null && !newPassword.trim().isEmpty()) {
            accountDao.updatePassword(newPassword.trim(), account.getID());
        }
        if (r > 0) {
            SwalFlash.successSession(request.getSession(), "Tài khoản", "Cập nhật thông tin thành công.");
        } else {
            SwalFlash.errorSession(request.getSession(), "Tài khoản", "Cập nhật thất bại.");
        }
        ServletPaths.redirect(request, response, "/account");
    }
}
