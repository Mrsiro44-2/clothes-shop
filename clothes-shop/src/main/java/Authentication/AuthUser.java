/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package Authentication;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author HP
 */
public class AuthUser {
    public String isLoginUser(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        String username = (String)session.getAttribute("usernameUser");
        String role = (String)session.getAttribute("usernameRole");
        if (username != null && !username.equals("") && role != null && role.equals("user")) {
            return username;
        }
        return null;
    }
}
