package DAO;

import Model.ColorOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ColorOptionDAO {

    private final Connection conn;

    public ColorOptionDAO() {
        conn = DBConnection.DBConnection.connect();
    }

    public List<ColorOption> listActive() {
        List<ColorOption> list = new ArrayList<>();
        String sql = "SELECT ID, name, hexCode, sortOrder, status FROM ColorOption WHERE status = 1 ORDER BY sortOrder, ID";
        try ( PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            System.out.println("ColorOptionDAO.listActive: " + e);
        }
        return list;
    }

    public ColorOption findById(int id) {
        String sql = "SELECT ID, name, hexCode, sortOrder, status FROM ColorOption WHERE ID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            try ( ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("ColorOptionDAO.findById: " + e);
        }
        return null;
    }

    private ColorOption map(ResultSet rs) throws SQLException {
        return new ColorOption(
                rs.getInt("ID"),
                rs.getString("name"),
                rs.getString("hexCode"),
                rs.getInt("sortOrder"),
                rs.getInt("status")
        );
    }
}
