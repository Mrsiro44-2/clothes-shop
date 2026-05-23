/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package DAO;

import DBConnection.DBConnection;
import Model.ImgDescription;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author HP
 */
public class ImgDescriptionDAO {

    private Connection conn;

    public ImgDescriptionDAO() {
        try {
            conn = DBConnection.connect();
        } catch (Exception e) {
            conn = null;
        }
    }

    public List<ImgDescription> getAllImgDescriptionByProduct(int productID) {
        List<ImgDescription> imgDescriptions = new ArrayList<>();
        String sql = "select * from imgDescription where productID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, productID);
            ResultSet result = st.executeQuery();
            while (result.next()) {
                int Id = result.getInt("ID");
                String imgUrl = result.getString("imgUrl");
                ImgDescription d = new ImgDescription(Id, imgUrl, productID);
                imgDescriptions.add(d);
            }
        } catch (SQLException e) {

        }
        return imgDescriptions;
    }

    public int insert(ImgDescription i) {
        int result = 0;
        String sql = "insert into imgDescription (imgUrl, ProductID) values (?, ?)";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, i.getImgUrl());
            st.setInt(2, i.getProductID());
            result = st.executeUpdate();
        } catch (SQLException e) {

        }
        return result;
    }

    public int delete(int idProduct) {
        int result = 0;
        String sql = "delete from imgDescription where productID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, idProduct);
            result = st.executeUpdate();
        } catch (SQLException e) {

        }
        return result;
    }
}

