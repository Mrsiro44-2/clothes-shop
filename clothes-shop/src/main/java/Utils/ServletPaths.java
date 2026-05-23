package Utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public final class ServletPaths {

    private ServletPaths() {
    }

    public static String ctx(HttpServletRequest request) {
        if (request == null) {
            return "";
        }
        String cp = request.getContextPath();
        return cp == null ? "" : cp;
    }

    public static String relative(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String cp = ctx(request);
        if (cp.length() > 0 && uri.startsWith(cp)) {
            String rel = uri.substring(cp.length());
            return rel.isEmpty() ? "/" : rel;
        }
        return uri;
    }

    public static String url(HttpServletRequest request, String path) {
        if (path == null || path.isEmpty()) {
            return ctx(request);
        }
        if (!path.startsWith("/")) {
            path = "/" + path;
        }
        return ctx(request) + path;
    }

    public static void redirect(HttpServletRequest request, HttpServletResponse response, String path)
            throws IOException {
        response.sendRedirect(url(request, path));
    }

    public static void redirect404(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        redirect(request, response, "/404");
    }

    public static void redirectHome(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        redirect(request, response, "/");
    }

    public static boolean relativeEquals(HttpServletRequest request, String path) {
        String rel = relative(request);
        if (path == null) {
            return false;
        }
        if (!path.startsWith("/")) {
            path = "/" + path;
        }
        return rel.equals(path) || rel.equals(path + "/");
    }

    public static boolean relativeStartsWith(HttpServletRequest request, String prefix) {
        String rel = relative(request);
        if (prefix == null || !prefix.startsWith("/")) {
            prefix = "/" + (prefix == null ? "" : prefix);
        }
        return rel.startsWith(prefix);
    }

    public static boolean relativeEndsWith(HttpServletRequest request, String suffix) {
        String rel = relative(request);
        if (suffix == null) {
            return false;
        }
        if (!suffix.startsWith("/")) {
            suffix = "/" + suffix;
        }
        return rel.equals(suffix) || rel.equals(suffix + "/") || rel.endsWith(suffix);
    }

    public static String lastSegment(HttpServletRequest request) {
        String rel = relative(request);
        if (rel.endsWith("/")) {
            rel = rel.substring(0, rel.length() - 1);
        }
        int i = rel.lastIndexOf('/');
        return i >= 0 ? rel.substring(i + 1) : rel;
    }

    public static int parsePageSuffix(HttpServletRequest request, String pagePrefix) {
        String seg = lastSegment(request);
        if (seg == null || !seg.startsWith(pagePrefix)) {
            return -1;
        }
        return new Validation().getInt(seg.substring(pagePrefix.length()));
    }

    public static String publicBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String host = request.getServerName();
        int port = request.getServerPort();
        StringBuilder b = new StringBuilder();
        b.append(scheme).append("://").append(host);
        boolean def = ("http".equalsIgnoreCase(scheme) && port == 80)
                || ("https".equalsIgnoreCase(scheme) && port == 443);
        if (!def) {
            b.append(":").append(port);
        }
        b.append(ctx(request));
        return b.toString();
    }
}
