package Utils;

import java.text.DecimalFormat;

/**
 * Định dạng tiền — hậu tố VNđ dùng Unicode escape (tránh lỗi font trên Windows).
 */
public class CurrencyConverter {

    /** VN + đ (U+0111) */
    public static final String CURRENCY_SUFFIX = "VN\u0111";

    public String getCurrencySuffix() {
        return CURRENCY_SUFFIX;
    }

    public String currencyFormat(double number) {
        return currencyFormat(number, CURRENCY_SUFFIX);
    }

    public String currencyFormat(double number, String suffix) {
        String sfx = (suffix == null || suffix.isEmpty()) ? CURRENCY_SUFFIX : suffix;
        if (number != 0) {
            DecimalFormat decimalFormat = new DecimalFormat("###,###.##");
            return decimalFormat.format(number) + " " + sfx;
        }
        return "0 " + sfx;
    }

    public String currencyFormatInput(double number) {
        if (number != 0) {
            DecimalFormat decimalFormat = new DecimalFormat("###.###");
            return decimalFormat.format(number);
        }
        return "0";
    }
}
