package Utils;

import Authentication.AuthUser;
import DAO.AccountDAO;
import DAO.WishlistDAO;
import Model.Account;
import Model.WishlistItem;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public class WishlistLib {

    /** Request attribute: Map productId -> int[]{wishlistId, variantId}. */
    public static final String REQ_WISHLIST_BY_PRODUCT = "wishlistByProductId";

    public int count(int accountId) {
        if (accountId <= 0) {
            return 0;
        }
        return new WishlistDAO().countByAccount(accountId);
    }

    public List<WishlistItem> list(int accountId) {
        if (accountId <= 0) {
            return Collections.emptyList();
        }
        return new WishlistDAO().findByAccount(accountId);
    }

    /**
     * Tải map yêu thích một lần mỗi request (dùng cho product card trên shop/home).
     */
    @SuppressWarnings("unchecked")
    public static Map<Integer, int[]> wishlistMapForRequest(HttpServletRequest request) {
        if (request == null) {
            return Collections.<Integer, int[]>emptyMap();
        }
        Object cached = request.getAttribute(REQ_WISHLIST_BY_PRODUCT);
        if (cached instanceof Map) {
            Map<Integer, int[]> hit = (Map<Integer, int[]>) cached;
            return hit != null ? hit : Collections.<Integer, int[]>emptyMap();
        }
        Map<Integer, int[]> map = loadWishlistMap(request);
        if (map == null) {
            map = Collections.<Integer, int[]>emptyMap();
        }
        request.setAttribute(REQ_WISHLIST_BY_PRODUCT, map);
        return map;
    }

    public static void clearRequestCache(HttpServletRequest request) {
        if (request != null) {
            request.removeAttribute(REQ_WISHLIST_BY_PRODUCT);
        }
    }

    private static Map<Integer, int[]> loadWishlistMap(HttpServletRequest request) {
        String username = new AuthUser().isLoginUser(request, null);
        if (username == null || username.isEmpty()) {
            return Collections.<Integer, int[]>emptyMap();
        }
        Account account = new AccountDAO().getAccountByUsername(username);
        if (account == null || account.getID() <= 0) {
            return Collections.<Integer, int[]>emptyMap();
        }
        Map<Integer, int[]> map = new WishlistDAO().findProductMapByAccount(account.getID());
        return map != null ? map : Collections.<Integer, int[]>emptyMap();
    }
}
