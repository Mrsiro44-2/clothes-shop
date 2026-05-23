package Utils;

import DAO.ColorOptionDAO;
import DAO.ProductVariantDAO;
import Model.ColorOption;
import Model.Product;
import Model.ProductVariant;
import jakarta.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public final class ProductCardJsp {

    private ProductCardJsp() {
    }

    public static boolean prepare(HttpServletRequest request) {
        if (request == null) {
            return false;
        }

        Product p = attrProduct(request);
        if (p == null) {
            return false;
        }

        String pathUrl = attrString(request, "cardPathUrl");
        if (pathUrl == null || pathUrl.isEmpty()) {
            pathUrl = request.getContextPath() + "/product";
        }
        String ctx = request.getContextPath();

        ProductVariantDAO vdao = new ProductVariantDAO();
        ProductVariant cardVariant = vdao.findDefaultOrFirst(p.getID());

        Integer pickVid = attrInt(request, "cardVariantId");
        if (pickVid != null && pickVid > 0) {
            ProductVariant picked = vdao.findById(pickVid);
            if (picked != null && picked.getProductID() == p.getID()) {
                cardVariant = picked;
            }
        }

        Integer cardWishlistId = attrInt(request, "cardWishlistId");
        if (cardWishlistId == null || cardWishlistId <= 0) {
            Map<Integer, int[]> wishByProduct = WishlistLib.wishlistMapForRequest(request);
            if (wishByProduct == null) {
                wishByProduct = Collections.emptyMap();
            }
            int[] wl = wishByProduct.get(p.getID());
            if (wl != null && wl.length >= 2 && wl[0] > 0) {
                cardWishlistId = wl[0];
                if (wl[1] > 0) {
                    ProductVariant wlVariant = vdao.findById(wl[1]);
                    if (wlVariant != null && wlVariant.getProductID() == p.getID()) {
                        cardVariant = wlVariant;
                    }
                }
            }
        }

        List<ProductVariant> allVariants = vdao.findByProductId(p.getID());
        List<ColorOption> cardColors = distinctColors(allVariants, 5);

        float dispNew = p.getNewPrice();
        float dispOld = p.getOldPrice();
        if (cardVariant != null) {
            dispNew = cardVariant.getNewPrice();
            dispOld = cardVariant.getOldPrice();
        }

        ProductPriceRange priceRange = ProductCardPricing.compute(p, allVariants);
        CurrencyConverter cardCurrency = new CurrencyConverter();
        String cardPriceHtml = ProductCardPricing.formatDisplayHtml(cardCurrency, priceRange, dispNew, dispOld);

        int badgePct = badgePercent(priceRange, dispNew, dispOld);

        request.setAttribute("cardProduct", p);
        request.setAttribute("cardVariant", cardVariant);
        request.setAttribute("cardColors", cardColors);
        request.setAttribute("cardPathUrl", pathUrl);
        request.setAttribute("cardCtx", ctx);
        request.setAttribute("cardDispNew", dispNew);
        request.setAttribute("cardDispOld", dispOld);
        request.setAttribute("cardWishlistId", cardWishlistId);
        request.setAttribute("cardPriceHtml", cardPriceHtml);
        request.setAttribute("cardPriceMin",
                priceRange.getMinEffective() > 0 ? priceRange.getMinEffective() : (dispNew > 0 ? dispNew : dispOld));
        request.setAttribute("cardBadgePct", Integer.valueOf(badgePct));
        return true;
    }

    private static Product attrProduct(HttpServletRequest request) {
        Object o = request.getAttribute("cardProduct");
        return o instanceof Product ? (Product) o : null;
    }

    private static String attrString(HttpServletRequest request, String name) {
        Object o = request.getAttribute(name);
        return o != null ? String.valueOf(o) : null;
    }

    private static Integer attrInt(HttpServletRequest request, String name) {
        Object o = request.getAttribute(name);
        if (o == null) {
            return null;
        }
        if (o instanceof Number) {
            return Integer.valueOf(((Number) o).intValue());
        }
        try {
            return Integer.valueOf(Integer.parseInt(String.valueOf(o)));
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private static List<ColorOption> distinctColors(List<ProductVariant> allVariants, int max) {
        Set<Integer> seenColors = new LinkedHashSet<Integer>();
        List<ColorOption> cardColors = new ArrayList<ColorOption>();
        ColorOptionDAO cdao = new ColorOptionDAO();
        if (allVariants == null) {
            return cardColors;
        }
        for (ProductVariant v : allVariants) {
            int cid = v.getColorOptionID();
            if (cid > 0 && seenColors.add(Integer.valueOf(cid))) {
                ColorOption co = cdao.findById(cid);
                if (co != null) {
                    cardColors.add(co);
                }
                if (cardColors.size() >= max) {
                    break;
                }
            }
        }
        return cardColors;
    }

    private static int badgePercent(ProductPriceRange priceRange, float dispNew, float dispOld) {
        if (priceRange.isHasSale() && priceRange.getMinOld() > 0 && priceRange.getMaxEffective() > 0) {
            float denom = priceRange.getMaxOld() > 0 ? priceRange.getMaxOld() : priceRange.getMinOld();
            return (int) Math.round((denom - priceRange.getMaxEffective()) / denom * 100.0);
        }
        return new Sale().salePercent(dispNew, dispOld);
    }
}
