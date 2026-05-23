package Utils;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;


public class Utf8EncodingFilter implements Filter {

    private static final String UTF8 = "UTF-8";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (request instanceof HttpServletRequest) {
            HttpServletRequest req = (HttpServletRequest) request;
            if (req.getCharacterEncoding() == null) {
                req.setCharacterEncoding(UTF8);
            }
        }
        if (response instanceof HttpServletResponse) {
            HttpServletResponse resp = (HttpServletResponse) response;
            resp.setCharacterEncoding(UTF8);
            if (request instanceof HttpServletRequest) {
                String uri = ((HttpServletRequest) request).getRequestURI();
                if (uri != null && uri.endsWith(".js")) {
                    resp.setContentType("application/javascript;charset=UTF-8");
                }
            }
            String ct = resp.getContentType();
            if (ct != null && ct.toLowerCase().startsWith("text/")
                    && ct.toLowerCase().indexOf("charset") < 0) {
                resp.setContentType(ct + ";charset=UTF-8");
            }
        }
        chain.doFilter(request, response);
    }
}
