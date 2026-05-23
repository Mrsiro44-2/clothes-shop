/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBConnection.DBConnection;
import Model.Brand;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author HP
 */
public class BrandDAO {

    private Connection conn;

    public BrandDAO() {
        try {
            conn = DBConnection.connect();
        } catch (Exception e) {
            conn = null;
        }
    }

//  user
    public List<Brand> getTopBrand() {
        String sql = "SELECT TOP 7 b.*, ISNULL(SUM(bd.numberOfProduct), 0) AS total_sold "
                + "FROM Brand b "
                + "INNER JOIN Product p ON p.brandID = b.ID AND p.status = 1 "
                + "LEFT JOIN ProductVariant v ON v.productID = p.ID "
                + "LEFT JOIN BillDetail bd ON bd.productVariantID = v.ID "
                + "LEFT JOIN Bill bl ON bl.id = bd.billID AND bl.status <> 0 "
                + "WHERE b.status = 1 "
                + "GROUP BY b.ID, b.name, b.img, b.status, b.datePost, b.dateUpdate "
                + "ORDER BY total_sold DESC";
        List<Brand> brands = new ArrayList<>();
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet result = st.executeQuery();
            while (result.next()) {
                brands.add(this.getBrand(result));
            }
            return brands;
        } catch (SQLException er) {
            System.out.println("Get top brand: " + er);
        }
        return brands;
    }
    
    public List<Brand> getBrandActive() {
        String sql = "SELECT b.*, ISNULL(SUM(bd.numberOfProduct), 0) AS total_sold "
                + "FROM Brand b "
                + "INNER JOIN Product p ON p.brandID = b.ID AND p.status = 1 "
                + "LEFT JOIN ProductVariant v ON v.productID = p.ID "
                + "LEFT JOIN BillDetail bd ON bd.productVariantID = v.ID "
                + "LEFT JOIN Bill bl ON bl.id = bd.billID AND bl.status <> 0 "
                + "WHERE b.status = 1 "
                + "GROUP BY b.ID, b.name, b.img, b.status, b.datePost, b.dateUpdate "
                + "ORDER BY total_sold DESC";
        List<Brand> brands = new ArrayList<>();
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet result = st.executeQuery();
            while (result.next()) {
                brands.add(this.getBrand(result));
            }
            return brands;
        } catch (SQLException er) {
            System.out.println("Get top brand: " + er);
        }
        return brands;
    }
    
    public Brand getBrandActiveByID(int id) {
        String sql = "select c.* from Brand as c where c.status = 1 and id=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet result = st.executeQuery();
            if (result.next()) {
                return this.getBrand(result);
            }
        } catch (SQLException er) {
            System.out.println("Get brand active by id: " + er);
        }
        return null;
    }
        
// end user

    public List<Brand> allBrand() {
        String sql = "select * from Brand order by id desc";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet result = st.executeQuery();
            List<Brand> brands = new ArrayList<>();
            while (result.next()) {
                brands.add(this.getBrand(result));
            }
            return brands;
        } catch (SQLException er) {

        }
        return null;
    }

    public List<Brand> getBrandByStatus(int status) {
        String sql = "select * from Brand where status=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, status);
            ResultSet result = st.executeQuery();
            List<Brand> producers = new ArrayList<>();
            while (result.next()) {
                producers.add(this.getBrand(result));
            }
            return producers;
        } catch (SQLException er) {
            System.out.println("Get producer by status: " + er);
        }
        return null;
    }

    public int getNumberProductByBrand(int id) {
        String sql = "select count(id) as numberProduct from Product where brandID =?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet result = st.executeQuery();
            if (result.next()) {
                return result.getInt("numberProduct");
            }
            return 0;
        } catch (SQLException e) {
            System.out.println("Get number product by brand: " + e);
        }
        return 0;
    }

    public Brand getBrandByID(int id) {
        String sql = "select * from Brand where id = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet result = st.executeQuery();
            if (result.next()) {
                return this.getBrand(result);
            }
        } catch (SQLException e) {
            System.out.println("Get producer by id: " + e);
        }
        return null;
    }

    private Brand getBrand(ResultSet result) {
        try {
            int ID = result.getInt("ID");
            String name = result.getString("name");
            String img = result.getString("img");
            Timestamp datePost = result.getTimestamp("datePost");
            Timestamp dateUpdate = result.getTimestamp("dateUpdate");
            int status = result.getInt("status");
            Brand c = new Brand(ID, name, img, datePost, dateUpdate, status);
            return c;
        } catch (SQLException e) {
            System.out.println("Get producer: " + e);
        }
        return null;
    }

    public int insert(Brand c) {

        int result = 0;
        String sql = "INSERT INTO Brand (name, img, datePost, status) VALUES(?, ?, ?, ?)";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, c.getName());
            st.setString(2, c.getImg());
            st.setTimestamp(3, c.getDatePost());
            st.setInt(4, c.getStatus());
            result = st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Add  new producer: " + e);
        }
        return result;
    }

    public int update(Brand c) {
        int result = 0;
        String sql = "update Brand set name=?, img=?, dateUpdate=?, status=? where ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, c.getName());
            st.setString(2, c.getImg());
            st.setTimestamp(3, c.getDateUpdate());
            st.setInt(4, c.getStatus());
            st.setInt(5, c.getID());
            result = st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Update producer: " + e);
        }
        return result;
    }

    public int delete(int id) {
        int result = 0;
        String sql = "delete from Brand where id=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            result = st.executeUpdate();
        } catch (SQLException er) {

        }
        return result;
    }
}
