/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Account;
import Utils.MD5Hashing;
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
public class AccountDAO {

    private Connection conn;

    public AccountDAO() {
        try {
            conn = DBConnection.DBConnection.connect();
        } catch (Exception e) {
            System.out.println("Connection fail: " + e);
        }
    }
    
    public Account getActiveUserByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }
        String sql = "SELECT A.*, R.name AS roleName FROM [Account] AS A "
                + "JOIN [Role] AS R ON A.role = R.ID "
                + "WHERE LOWER(A.email) = LOWER(?) AND A.status = 1 AND R.name = 'user'";
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, email.trim());
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return getAccount(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("getActiveUserByEmail: " + e);
        }
        return null;
    }

    public Account getAccountByUsername(String username) {
        String sql = "select A.*, R.name as roleName from [Account] as A join [Role] as R on A.role = R.Id "
                + "where username=? and A.status = 1 and R.status=1";
        try {
            PreparedStatement st = conn.prepareCall(sql);
            st.setString(1, username);
            ResultSet rs = st.executeQuery();
            if(rs.next()) {
                return this.getAccount(rs);
            }
        } catch (Exception e) {
            System.out.println("getAccountByUsername: " + e);
        }
        return null;
    }

    public Account login(String username) {
        String sql = "select A.*, R.name as roleName from [Account] as A join [Role] as R on A.role = R.Id "
                + "where username=? and A.status = 1 and R.status=1";
        try {
            PreparedStatement st = conn.prepareCall(sql);
            st.setString(1, username);
            ResultSet rs = st.executeQuery();
            if(rs.next()) {
                return this.getAccount(rs);
            }
        } catch (Exception e) {
            System.out.println("Login: " + e);
        }
        return null;
    }

    public Account isExistAccount(String username, String email) {
        String sql = "select A.*, R.name as roleName from [Account] as A join [Role] as R on A.role = R.ID where (username=? or email=?)";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, username);
            st.setString(2, email);
            ResultSet rs = st.executeQuery();
            if(rs.next()) {
                return this.getAccount(rs);
            }
        } catch (SQLException e) {
            System.out.println("Is exist admin by username, email: " + e);
        }
        return null;
    }
    
    public Account getAccountById(int id) {
        String sql = "select A.*, R.name as roleName from [Account] as A join [Role] as R on A.role = R.ID where A.ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if(rs.next()) {
                return this.getAccount(rs);
            }
        } catch (SQLException e) {
            System.out.println("Get account by id: " + e);
        }
        return null;
    }

    public List<Account> allAccount(String username) {
        String sql = "select A.*, R.name as roleName from [Account] as A join [Role] as R on R.id = A.role order by A.role desc, A.id desc";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            List<Account> accounts = new ArrayList<>();
            while (rs.next()) {
                accounts.add(this.getAccount(rs));
            }
            return accounts;
        } catch (SQLException er) {
            System.out.println("Get all account: " + er);
        }
        return null;
    }
    
    public List<Account> allAccountByStaff() {
        String sql = "select A.*, R.name as roleName from [Account] as A join [Role] as R on R.id = A.role"
                + " where R.name = 'user' order by A.role desc, A.id desc";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            List<Account> accounts = new ArrayList<>();
            while (rs.next()) {
                accounts.add(this.getAccount(rs));
            }
            return accounts;
        } catch (SQLException er) {
            System.out.println("Get all account: " + er);
        }
        return null;
    }

    public int insert(Account a) {
        int result = 0;
        String sql = "INSERT INTO Account (fullname, email, phone, username, password, role, date, status, avatar) "
                + "VALUES(?, ?, ?, ?, ?, ?, ? ,?, ?)";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, a.getFullname());
            st.setString(2, a.getEmail());
            st.setString(3, a.getPhone());
            st.setString(4, a.getUsername());
            st.setString(5, MD5Hashing.encodeForStorage(a.getPassword()));
            st.setInt(6, a.getRole());
            st.setTimestamp(7, a.getDate());
            st.setInt(8, a.getStatus());
            String avatar = a.getAvatar() != null ? a.getAvatar() : "./static-admin/assets/images/default_avatar.jpg";
            st.setString(9, avatar);
            result = st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Insert account: " + e);
        }
        return result;
    }

    public int updatePassword(String password, int id) {
        int result = 0;
        String sql = "update Account set password=? where ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, MD5Hashing.encodeForStorage(password));
            st.setInt(2, id);
            result = st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Update password account: " + e);
        }
        return result;
    }

    public int updatePersonalUser(Account a) {
        int result = 0;
        String sql = "UPDATE Account SET fullname=?, email=?, phone=?, avatar=? WHERE ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, a.getFullname());
            st.setString(2, a.getEmail());
            st.setString(3, a.getPhone());
            st.setString(4, a.getAvatar());
            st.setInt(5, a.getID());
            result = st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Update personal account: " + e);
        }
        return result;
    }

    /** Email đã dùng bởi tài khoản khác (không tính excludeId). */
    public boolean isEmailTakenByOther(int excludeId, String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM Account WHERE LOWER(email) = LOWER(?) AND ID <> ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, email.trim());
            st.setInt(2, excludeId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("isEmailTakenByOther: " + e);
        }
        return false;
    }

    public int updatePersonal(Account a) {
        int result = 0;
        String sql = "update Account set fullname=?, email=?, phone=?, username=?,"
                + "password=?, status=?, avatar=? where ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            int i = 1;
            st.setString(i++, a.getFullname());
            st.setString(i++, a.getEmail());
            st.setString(i++, a.getPhone());
            st.setString(i++, a.getUsername());
            st.setString(i++, MD5Hashing.encodeForStorage(a.getPassword()));
            st.setInt(i++, a.getStatus());
            st.setString(i++, a.getAvatar());
            st.setInt(i++, a.getID());
            result = st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Update account personal: " + e);
        }
        return result;
    }
    
    public int update(Account a) {
        int result = 0;
        String sql = "update Account set fullname=?, email=?, phone=?, username=?,"
                + "password=?, role=?, status=? where ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, a.getFullname());
            st.setString(2, a.getEmail());
            st.setString(3, a.getPhone());
            st.setString(4, a.getUsername());
            st.setString(5, MD5Hashing.encodeForStorage(a.getPassword()));
            st.setInt(6, a.getRole());
            st.setInt(7, a.getStatus());
            st.setInt(8, a.getID());
            result = st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Update account: " + e);
        }
        return result;
    }

    public int delete(int id) {
        int result = 0;
        String sql = "delete from Account where id=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            result = st.executeUpdate();
        } catch (SQLException er) {
            System.out.println("Delete account: " + er);
        }
        return result;
    }

    private Account getAccount(ResultSet rs) {
        try {
            int id = rs.getInt("ID");
            String username = rs.getString("username");
            String password = rs.getString("password");
            String email = rs.getString("email");
            String phone = rs.getString("phone");
            String fullname = rs.getString("fullname");
            Timestamp datePost = rs.getTimestamp("date");
            int status = rs.getInt("status");
            String avatar = rs.getString("avatar");
            int role = rs.getInt("role");
            String roleName = rs.getString("roleName");
            Account a = new Account(id, username, password, email, phone, status, fullname, datePost, role, avatar);
            a.setRoleName(roleName);
            return a;
        } catch (Exception e) {
            System.out.println("Get account: " + e);
        }
        return null;
    }

}
