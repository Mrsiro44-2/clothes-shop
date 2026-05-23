/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DBConnection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author HP
 */
public class DBConnection {
    /* Đổi databasename cho khớp SQL Server của bạn (ví dụ: ClothesShop theo script v2). */
    private static final String urlConnect = "jdbc:sqlserver://localhost:1433;databaseName=ClothesShop;user=sa;password=sa;encrypt=true;trustServerCertificate=true;sendStringParametersAsUnicode=true;";

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException ex) {
            System.out.println("SQLServerDriver: " + ex);
        }
    }

    public static Connection connect() {
        try {
            return DriverManager.getConnection(urlConnect);
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return null;
    }
    
//    public static void main(String args[]) {
//        System.out.println(connect());
//    }
}
