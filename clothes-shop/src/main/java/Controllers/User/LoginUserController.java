/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.User;

import Authentication.AuthUser;
import DAO.AccountDAO;
import Model.Account;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Utils.MD5Hashing;
import Utils.ServletPaths;
import Utils.SwalFlash;

/**
 *
 * @author HP
 */
@WebServlet(name = "LoginUserController", urlPatterns = {"/login"})
public class LoginUserController extends HttpServlet {
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthUser auth = new AuthUser();
        if (auth.isLoginUser(request, response) != null) {
            ServletPaths.redirectHome(request, response);
        } else {
            HttpSession session = request.getSession(false);
            if (session != null) {
                String success = (String) session.getAttribute("messageSuccessRegister");
                if (success != null) {
                    SwalFlash.success(request, "Đăng ký thành công", success);
                    session.removeAttribute("messageSuccessRegister");
                }
            }
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AccountDAO adao = new AccountDAO();
        HttpSession session = request.getSession();
        if (request.getParameter("submitLogin") != null) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            Account a = adao.login(username);
            boolean isError = false;
            String title = "Đăng nhập thất bại";
            if (a == null && !isError) {
                SwalFlash.error(request, title, "Tài khoản không tồn tại.");
                isError = true;
            }
            if (!isError && !a.getRoleName().equals("user")) {
                SwalFlash.error(request, title, "Tài khoản không được phép đăng nhập tại đây.");
                isError = true;
            }
            if (!isError && a.getStatus() == 0) {
                SwalFlash.error(request, title, "Tài khoản đã bị khóa.");
                isError = true;
            }
            if (!isError && !MD5Hashing.matches(password, a.getPassword())) {
                SwalFlash.error(request, title, "Mật khẩu không đúng.");
                isError = true;
            }
            if (isError) {
                request.getRequestDispatcher("/user/login.jsp").forward(request, response);
                return;
            }
            String isRemember = request.getParameter("remember");
            session.setAttribute("usernameUser", a.getUsername());
            session.setAttribute("usernameRole", a.getRoleName());
            ServletPaths.redirectHome(request, response);
        }
    }
}
