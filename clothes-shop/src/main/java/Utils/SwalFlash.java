package Utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Gắn thông báo SweetAlert2 qua request (forward) hoặc session (redirect).
 */
public final class SwalFlash {

    public static final String ATTR_ICON = "swalIcon";
    public static final String ATTR_TITLE = "swalTitle";
    public static final String ATTR_MESSAGE = "swalMessage";

    private SwalFlash() {
    }

    public static void error(HttpServletRequest request, String title, String message) {
        put(request, "error", title, message);
    }

    public static void success(HttpServletRequest request, String title, String message) {
        put(request, "success", title, message);
    }

    public static void warning(HttpServletRequest request, String title, String message) {
        put(request, "warning", title, message);
    }

    public static void errorSession(HttpSession session, String title, String message) {
        putSession(session, "error", title, message);
    }

    public static void successSession(HttpSession session, String title, String message) {
        putSession(session, "success", title, message);
    }

    public static void warningSession(HttpSession session, String title, String message) {
        putSession(session, "warning", title, message);
    }

    public static void put(HttpServletRequest request, String icon, String title, String message) {
        if (request == null) {
            return;
        }
        request.setAttribute(ATTR_ICON, icon);
        request.setAttribute(ATTR_TITLE, title != null ? title : "");
        request.setAttribute(ATTR_MESSAGE, message != null ? message : "");
    }

    public static void putSession(HttpSession session, String icon, String title, String message) {
        if (session == null) {
            return;
        }
        session.setAttribute(ATTR_ICON, icon);
        session.setAttribute(ATTR_TITLE, title != null ? title : "");
        session.setAttribute(ATTR_MESSAGE, message != null ? message : "");
    }

    public static void clearSession(HttpSession session) {
        if (session == null) {
            return;
        }
        session.removeAttribute(ATTR_ICON);
        session.removeAttribute(ATTR_TITLE);
        session.removeAttribute(ATTR_MESSAGE);
    }
}
