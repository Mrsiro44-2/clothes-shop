package Model;

import java.sql.Timestamp;

public class Cart {

    private int ID;
    private int accountID;
    private int quantity;
    private int productVariantID;
    private Timestamp dateAdded;

    private int productID;
    private String productName;
    private String mainImg;
    private float unitNewPrice;
    private float unitOldPrice;
    private int stockQty;
    private String sizeLabel;
    private String colorName;

    public Cart() {
    }

    public Cart(int ID, int accountID, int quantity, int productVariantID) {
        this.ID = ID;
        this.accountID = accountID;
        this.quantity = quantity;
        this.productVariantID = productVariantID;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getProductVariantID() {
        return productVariantID;
    }

    public void setProductVariantID(int productVariantID) {
        this.productVariantID = productVariantID;
    }

    public Timestamp getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(Timestamp dateAdded) {
        this.dateAdded = dateAdded;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getMainImg() {
        return mainImg;
    }

    public void setMainImg(String mainImg) {
        this.mainImg = mainImg;
    }

    public float getUnitNewPrice() {
        return unitNewPrice;
    }

    public void setUnitNewPrice(float unitNewPrice) {
        this.unitNewPrice = unitNewPrice;
    }

    public float getUnitOldPrice() {
        return unitOldPrice;
    }

    public void setUnitOldPrice(float unitOldPrice) {
        this.unitOldPrice = unitOldPrice;
    }

    public int getStockQty() {
        return stockQty;
    }

    public void setStockQty(int stockQty) {
        this.stockQty = stockQty;
    }

    public String getSizeLabel() {
        return sizeLabel;
    }

    public void setSizeLabel(String sizeLabel) {
        this.sizeLabel = sizeLabel;
    }

    public String getColorName() {
        return colorName;
    }

    public void setColorName(String colorName) {
        this.colorName = colorName;
    }

    /** Hiển thị đơn giá (ưu tiên giá sale > 0). */
    public float getDisplayUnitPrice() {
        return unitNewPrice > 0 ? unitNewPrice : unitOldPrice;
    }
}
