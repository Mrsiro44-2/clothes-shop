package Model;

public class BillDetail {

    private int ID;
    private int billID;
    private Integer productVariantID;
    private int productID;
    private String skuSnapshot;
    private String nameProduct;
    private String modelProduct;
    private String imgProduct;
    private String sizeLabelSnapshot;
    private String colorLabelSnapshot;
    private float priceProduct;
    private int numberOfProduct;

    public BillDetail() {
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public int getBillID() {
        return billID;
    }

    public void setBillID(int billID) {
        this.billID = billID;
    }

    public Integer getProductVariantID() {
        return productVariantID;
    }

    public void setProductVariantID(Integer productVariantID) {
        this.productVariantID = productVariantID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getSkuSnapshot() {
        return skuSnapshot;
    }

    public void setSkuSnapshot(String skuSnapshot) {
        this.skuSnapshot = skuSnapshot;
    }

    public String getNameProduct() {
        return nameProduct;
    }

    public void setNameProduct(String nameProduct) {
        this.nameProduct = nameProduct;
    }

    public String getModelProduct() {
        return modelProduct;
    }

    public void setModelProduct(String modelProduct) {
        this.modelProduct = modelProduct;
    }

    public String getImgProduct() {
        return imgProduct;
    }

    public void setImgProduct(String imgProduct) {
        this.imgProduct = imgProduct;
    }

    public String getSizeLabelSnapshot() {
        return sizeLabelSnapshot;
    }

    public void setSizeLabelSnapshot(String sizeLabelSnapshot) {
        this.sizeLabelSnapshot = sizeLabelSnapshot;
    }

    public String getColorLabelSnapshot() {
        return colorLabelSnapshot;
    }

    public void setColorLabelSnapshot(String colorLabelSnapshot) {
        this.colorLabelSnapshot = colorLabelSnapshot;
    }

    public float getPriceProduct() {
        return priceProduct;
    }

    public void setPriceProduct(float priceProduct) {
        this.priceProduct = priceProduct;
    }

    public int getNumberOfProduct() {
        return numberOfProduct;
    }

    public void setNumberOfProduct(int numberOfProduct) {
        this.numberOfProduct = numberOfProduct;
    }

    /** Alias cho JSP cũ (billDetails.jsp dùng `${billDetail.color}`). */
    public String getColor() {
        return colorLabelSnapshot;
    }

    public String getSize() {
        return sizeLabelSnapshot;
    }
}
