/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Role;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author HP
 */
public class RoleDAO {
    private Connection conn;

    public RoleDAO() {
        try {
            conn = DBConnection.DBConnection.connect();
        }catch(Exception e) {
            System.out.println("Connection fail: " + e);
        }
    }
    
    public List<Role> getRole() {
        String sql = "select * from [Role] where status=1";
        List<Role> roles = new ArrayList<>();
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while(rs.next()) {
                int id = rs.getInt("ID");
                String name = rs.getString("name");
                int type = rs.getInt("type");
                int status = rs.getInt("status");
                Role r = new Role(id, name, type, status);
                roles.add(r);
            }
        }catch(Exception e) {
            System.out.println("Get role: " + e);
        }
        return roles;
    }
    
    public int getRoleIdByName(String name) {
        String sql = "SELECT ID FROM [Role] WHERE status = 1 AND name = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, name);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("ID");
            }
        } catch (Exception e) {
            System.out.println("Get role id by name: " + e);
        }
        return -1;
    }

    public Role getRoleById(int id) {
        String sql = "select * from [Role] where status=1 and ID=?";
        List<Role> roles = new ArrayList<>();
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if(rs.next()) {
                String name = rs.getString("name");
                int type = rs.getInt("type");
                int status = rs.getInt("status");
                Role r = new Role(id, name, type, status);
                return r;
            }
        }catch(Exception e) {
            System.out.println("Get role: " + e);
        }
        return null;
    }
    
    public int update(Role r) {
        String sql = "update [Role] set status=? where ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, r.getStatus());
            st.setInt(2, r.getID());
            return st.executeUpdate();
        }catch(Exception e) {
            System.out.println("Update status role: " + e);
        }
        return 0;
    }
}
