package DAO;

import Model.BlogCategory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BlogCategoryDAO {

    private final Connection conn;

    public BlogCategoryDAO() {
        conn = DBConnection.DBConnection.connect();
    }

    public List<BlogCategory> listActive() {
        List<BlogCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM BlogCategory WHERE status = 1 ORDER BY sortOrder, ID";
        try ( PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                BlogCategory c = new BlogCategory();
                c.setID(rs.getInt("ID"));
                c.setName(rs.getString("name"));
                c.setSlug(rs.getString("slug"));
                c.setDescription(rs.getString("description"));
                c.setCoverImg(rs.getString("coverImg"));
                c.setSortOrder(rs.getInt("sortOrder"));
                c.setStatus(rs.getInt("status"));
                c.setDatePost(rs.getTimestamp("datePost"));
                c.setDateUpdate(rs.getTimestamp("dateUpdate"));
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("BlogCategoryDAO.listActive: " + e);
        }
        return list;
    }
}
