package Model;

import java.sql.Timestamp;

public class WishlistItem {
    private int id;
    private int accountID;
    private int productVariantID;
    private int productID;
    private String productName;
    private String mainImg;
    private String sizeLabel;
    private String colorName;
    private float displayPrice;
    private int stockQty;
    private Timestamp dateAdded;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getAccountID() { return accountID; }
    public void setAccountID(int accountID) { this.accountID = accountID; }
    public int getProductVariantID() { return productVariantID; }
    public void setProductVariantID(int productVariantID) { this.productVariantID = productVariantID; }
    public int getProductID() { return productID; }
    public void setProductID(int productID) { this.productID = productID; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getMainImg() { return mainImg; }
    public void setMainImg(String mainImg) { this.mainImg = mainImg; }
    public String getSizeLabel() { return sizeLabel; }
    public void setSizeLabel(String sizeLabel) { this.sizeLabel = sizeLabel; }
    public String getColorName() { return colorName; }
    public void setColorName(String colorName) { this.colorName = colorName; }
    public float getDisplayPrice() { return displayPrice; }
    public void setDisplayPrice(float displayPrice) { this.displayPrice = displayPrice; }
    public int getStockQty() { return stockQty; }
    public void setStockQty(int stockQty) { this.stockQty = stockQty; }
    public Timestamp getDateAdded() { return dateAdded; }
    public void setDateAdded(Timestamp dateAdded) { this.dateAdded = dateAdded; }
}
