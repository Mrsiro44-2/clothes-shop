package Utils;

import Model.Product;
import Model.ProductVariant;
import java.util.List;

/**
 * Giá hiển thị trên product card (khoảng min–max theo biến thể).
 */
public class ProductCardPricing {

    public static ProductPriceRange compute(Product product, List<ProductVariant> variants) {
        ProductPriceRange r = new ProductPriceRange();
        float minE = -1;
        float maxE = -1;
        float minO = -1;
        float maxO = -1;

        if (variants != null) {
            for (ProductVariant v : variants) {
                if (v.getStatus() != 1) {
                    continue;
                }
                float eff = effective(v.getNewPrice(), v.getOldPrice());
                float old = v.getOldPrice();
                if (eff <= 0) {
                    continue;
                }
                minE = minE < 0 ? eff : Math.min(minE, eff);
                maxE = maxE < 0 ? eff : Math.max(maxE, eff);
                if (old > 0) {
                    minO = minO < 0 ? old : Math.min(minO, old);
                    maxO = maxO < 0 ? old : Math.max(maxO, old);
                }
                if (v.getNewPrice() > 0 && old > v.getNewPrice()) {
                    r.setHasSale(true);
                }
            }
        }

        if (minE < 0 && product != null) {
            float n = product.getNewPrice();
            float o = product.getOldPrice();
            float eff = effective(n, o);
            if (eff > 0) {
                minE = maxE = eff;
                if (o > 0) {
                    minO = maxO = o;
                }
                if (n > 0 && o > n) {
                    r.setHasSale(true);
                }
            }
        }

        r.setMinEffective(minE < 0 ? 0 : minE);
        r.setMaxEffective(maxE < 0 ? r.getMinEffective() : maxE);
        r.setMinOld(minO < 0 ? 0 : minO);
        r.setMaxOld(maxO < 0 ? r.getMinOld() : maxO);
        r.setHasRange(r.getMinEffective() > 0 && r.getMaxEffective() > 0
                && Math.abs(r.getMaxEffective() - r.getMinEffective()) > 0.5f);
        return r;
    }

    /**
     * HTML giá card — format trong Java (tránh lỗi EL với bean lồng).
     */
    public static String formatDisplayHtml(CurrencyConverter cur, ProductPriceRange r,
            float fallbackNew, float fallbackOld) {
        if (cur == null) {
            cur = new CurrencyConverter();
        }
        float min = r.getMinEffective();
        float max = r.getMaxEffective();
        if (min <= 0) {
            float eff = effective(fallbackNew, fallbackOld);
            if (eff <= 0 && fallbackOld > 0) {
                eff = fallbackOld;
            }
            min = max = eff;
        }

        boolean showRange = min > 0 && max > 0 && Math.abs(max - min) > 0.5f;
        StringBuilder sb = new StringBuilder();

        if (showRange) {
            sb.append("<span class=\"mb-product-card__price-range\">")
                    .append(esc(cur.currencyFormat(min)))
                    .append("<span class=\"mb-product-card__price-sep\"> - </span>")
                    .append(esc(cur.currencyFormat(max)))
                    .append("</span>");
        } else if (min > 0) {
            sb.append("<span class=\"mb-product-card__price-single\">")
                    .append(esc(cur.currencyFormat(min)))
                    .append("</span>");
        } else if (effective(fallbackNew, fallbackOld) > 0) {
            sb.append("<span class=\"mb-product-card__price-single\">")
                    .append(esc(cur.currencyFormat(effective(fallbackNew, fallbackOld))))
                    .append("</span>");
        } else {
            sb.append("<span class=\"mb-product-card__price-single text-muted\">Li\u00ean h\u1ec7</span>");
        }
        return sb.toString();
    }

    private static float effective(float newPrice, float oldPrice) {
        return newPrice > 0 ? newPrice : oldPrice;
    }

    private static String esc(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}
