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
public class Category {

    private int ID;

    private String name;

    private Timestamp datePost;

    private Timestamp dateUpdate;

    private int status;

    private int sizeGroupID;

    // Constructors
    public Category() {
    }

    public Category(int ID, String name, Timestamp datePost, Timestamp dateUpdate, int status) {
        this(ID, name, datePost, dateUpdate, status, 0);
    }

    public Category(int ID, String name, Timestamp datePost, Timestamp dateUpdate, int status, int sizeGroupID) {
        this.ID = ID;
        this.name = name;
        this.datePost = datePost;
        this.dateUpdate = dateUpdate;
        this.status = status;
        this.sizeGroupID = sizeGroupID;
    }

    // Getters and Setters
    public int getID() {
        return ID;
    }

    public void setID(int id) {
        this.ID = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getSizeGroupID() {
        return sizeGroupID;
    }

    public void setSizeGroupID(int sizeGroupID) {
        this.sizeGroupID = sizeGroupID;
    }
}
