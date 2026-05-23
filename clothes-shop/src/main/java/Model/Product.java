/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.sql.Timestamp;

/**
 *
 * @author HP
 */
public class Product {

    private int ID;

    private String name;

    private String slug;

    private float oldPrice;
    
    private float newPrice;

    private String description;

    private Timestamp datePost;

    private Timestamp dateUpdate;

    private String mainImg;

    private int status;

    private int quantity;

    private Integer sold;

    private String model;

    private int priority;

    private int categoryID;

    private int producerID;

    private int brandID;

    public Product() {
    }

    public Product(int ID, String name, String slug, float oldPrice, float newPrice, String description, Timestamp datePost, Timestamp dateUpdate, String mainImg, int status, int quantity, Integer sold, String model, int priority, int categoryID, int producerID, int brandID) {
        this.ID = ID;
        this.name = name;
        this.slug = slug;
        this.oldPrice = oldPrice;
        this.newPrice = newPrice;
        this.description = description;
        this.datePost = datePost;
        this.dateUpdate = dateUpdate;
        this.mainImg = mainImg;
        this.status = status;
        this.quantity = quantity;
        this.sold = sold;
        this.model = model;
        this.priority = priority;
        this.categoryID = categoryID;
        this.producerID = producerID;
        this.brandID = brandID;
    }

    /** @deprecated dùng constructor có slug */
    public Product(int ID, String name, float oldPrice, float newPrice, String description, Timestamp datePost, Timestamp dateUpdate, String mainImg, int status, int quantity, Integer sold, String model, int priority, int categoryID, int producerID, int brandID) {
        this(ID, name, null, oldPrice, newPrice, description, datePost, dateUpdate, mainImg, status, quantity, sold, model, priority, categoryID, producerID, brandID);
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getDatePost() {
        return datePost;
    }

    public void setDatePost(Timestamp datePost) {
        this.datePost = datePost;
    }

    public Timestamp getDateUpdate() {
        return dateUpdate;
    }

    public void setDateUpdate(Timestamp dateUpdate) {
        this.dateUpdate = dateUpdate;
    }

    public String getMainImg() {
        return mainImg;
    }

    public void setMainImg(String mainImg) {
        this.mainImg = mainImg;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Integer getSold() {
        return sold;
    }

    public void setSold(Integer sold) {
        this.sold = sold;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public int getProducerID() {
        return producerID;
    }

    public void setProducerID(int producerID) {
        this.producerID = producerID;
    }

    public int getBrandID() {
        return brandID;
    }

    public void setBrandID(int brandID) {
        this.brandID = brandID;
    }

}
