/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBConnection.DBConnection;
import Model.Producer;
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
public class ProducerDAO {

    private Connection conn;

    public ProducerDAO() {
        try {
            conn = DBConnection.connect();
        } catch (Exception e) {
            conn = null;
        }
    }

    public List<Producer> allProducer() {
        String sql = "select * from Producer order by id desc";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet result = st.executeQuery();
            List<Producer> producers = new ArrayList<>();
            while (result.next()) {
                producers.add(this.getProducer(result));
            }
            return producers;
        } catch (SQLException er) {

        }
        return null;
    }

    public List<Producer> getProducerByStatus(int status) {
        String sql = "select * from Producer where status=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, status);
            ResultSet result = st.executeQuery();
            List<Producer> producers = new ArrayList<>();
            while (result.next()) {
                producers.add(this.getProducer(result));
            }
            return producers;
        } catch (SQLException er) {
            System.out.println("Get producer by status: " + er);
        }
        return null;
    }

    public int getNumberProductByProducer(int id) {
        String sql = "select count(id) as numberProduct from Product where producerID =?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet result = st.executeQuery();
            if (result.next()) {
                return result.getInt("numberProduct");
            }
            return 0;
        } catch (SQLException e) {
            System.out.println("Get number product by producer: " + e);
        }
        return 0;
    }

    public Producer getProducerByID(int id) {
        String sql = "select * from Producer where id = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet result = st.executeQuery();
            if (result.next()) {
                return this.getProducer(result);
            }
        } catch (SQLException e) {
            System.out.println("Get producer by id: " + e);
        }
        return null;
    }

    private Producer getProducer(ResultSet result) {
        try {
            int ID = result.getInt("ID");
            String name = result.getString("name");
            Timestamp datePost = result.getTimestamp("datePost");
            Timestamp dateUpdate = result.getTimestamp("dateUpdate");
            int status = result.getInt("status");
            Producer c = new Producer(ID, name, datePost, dateUpdate, status);
            return c;
        } catch (SQLException e) {
            System.out.println("Get producer: " + e);
        }
        return null;
    }

    public int insert(Producer c) {

        int result = 0;
        String sql = "INSERT INTO Producer (name, datePost, status) VALUES(?, ?, ?)";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, c.getName());
            st.setTimestamp(2, c.getDatePost());
            st.setInt(3, c.getStatus());
            result = st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Add  new producer: " + e);
        }
        return result;
    }

    public int update(Producer c) {
        int result = 0;
        String sql = "update Producer set name=?, dateUpdate=?, status=? where ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, c.getName());
            st.setTimestamp(2, c.getDateUpdate());
            st.setInt(3, c.getStatus());
            st.setInt(4, c.getID());
            result = st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Update producer: " + e);
        }
        return result;
    }

    public int delete(int id) {
        int result = 0;
        String sql = "delete from Producer where id=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            result = st.executeUpdate();
        } catch (SQLException er) {

        }
        return result;
    }
}
