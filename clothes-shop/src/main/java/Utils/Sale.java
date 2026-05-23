package Utils;


public class Sale {

    public String calculateSale(double newPrice, double oldPrice) {
        int pct = salePercent(newPrice, oldPrice);
        return pct > 0 ? pct + " %" : "0 %";
    }

    public int salePercent(double newPrice, double oldPrice) {
        if (oldPrice <= 0 || newPrice <= 0 || newPrice >= oldPrice) {
            return 0;
        }
        return (int) Math.round(((oldPrice - newPrice) / oldPrice) * 100.0);
    }

    public String saleBadge(double newPrice, double oldPrice) {
        int pct = salePercent(newPrice, oldPrice);
        return pct > 0 ? "-" + pct + "%" : "";
    }
}
