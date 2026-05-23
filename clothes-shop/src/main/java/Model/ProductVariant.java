package Model;

import java.sql.Timestamp;

public class ProductVariant {

    private int ID;
    private int productID;
    private int sizeOptionID;
    private int colorOptionID;
    private String sku;
    private String barcode;
    private float oldPrice;
    private float newPrice;
    private int quantity;
    private String variantImg;
    private Integer weightGrams;
    private boolean isDefault;
    private int status;
    private Timestamp dateCreated;
    private Timestamp dateUpdated;

    private String sizeLabel;
    private String colorName;
    private String colorHex;

    public ProductVariant() {
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public int getSizeOptionID() {
        return sizeOptionID;
    }

    public void setSizeOptionID(int sizeOptionID) {
        this.sizeOptionID = sizeOptionID;
    }

    public int getColorOptionID() {
        return colorOptionID;
    }

    public void setColorOptionID(int colorOptionID) {
        this.colorOptionID = colorOptionID;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }

    public float getOldPrice() {
        return oldPrice;
    }

    public void setOldPrice(float oldPrice) {
        this.oldPrice = oldPrice;
    }

    public float getNewPrice() {
        return newPrice;
    }

    public void setNewPrice(float newPrice) {
        this.newPrice = newPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getVariantImg() {
        return variantImg;
    }

    public void setVariantImg(String variantImg) {
        this.variantImg = variantImg;
    }

    public Integer getWeightGrams() {
        return weightGrams;
    }

    public void setWeightGrams(Integer weightGrams) {
        this.weightGrams = weightGrams;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean aDefault) {
        isDefault = aDefault;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Timestamp getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Timestamp dateCreated) {
        this.dateCreated = dateCreated;
    }

    public Timestamp getDateUpdated() {
        return dateUpdated;
    }

    public void setDateUpdated(Timestamp dateUpdated) {
        this.dateUpdated = dateUpdated;
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

    public String getColorHex() {
        return colorHex;
    }

    public void setColorHex(String colorHex) {
        this.colorHex = colorHex;
    }
}
