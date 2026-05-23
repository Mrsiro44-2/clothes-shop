package DAO;

import Model.BlogPost;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class BlogPostDAO {

    private final Connection conn;

    public BlogPostDAO() {
        conn = DBConnection.DBConnection.connect();
    }

    private static final String PUBLISHED_SELECT = "SELECT p.*, c.name AS categoryName, a.fullname AS authorName "
            + "FROM BlogPost p "
            + "LEFT JOIN BlogCategory c ON c.ID = p.blogCategoryID AND c.status = 1 "
            + "JOIN [Account] a ON a.ID = p.authorAccountID AND a.status = 1 ";

    private static final String PUBLISHED_WHERE = "WHERE p.status = 1 AND p.publishedAt IS NOT NULL "
            + "AND p.publishedAt <= SYSUTCDATETIME() ";

    public List<BlogPost> listPublished(int offset, int limit) {
        return searchPublished(null, null, offset, limit);
    }

    public List<BlogPost> searchPublished(String keyword, Integer categoryId, int offset, int limit) {
        List<BlogPost> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(PUBLISHED_SELECT);
        sql.append(PUBLISHED_WHERE);
        List<Object> params = new ArrayList<>();
        appendFilters(sql, params, keyword, categoryId);
        sql.append("ORDER BY p.isFeatured DESC, p.publishedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        try ( PreparedStatement st = conn.prepareStatement(sql.toString())) {
            int idx = bindFilters(st, params);
            st.setInt(idx++, Math.max(0, offset));
            st.setInt(idx, Math.max(1, limit));
            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.searchPublished: " + e);
        }
        return list;
    }

    public int countPublished(String keyword, Integer categoryId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM BlogPost p "
                + "LEFT JOIN BlogCategory c ON c.ID = p.blogCategoryID AND c.status = 1 ");
        sql.append(PUBLISHED_WHERE);
        List<Object> params = new ArrayList<>();
        appendFilters(sql, params, keyword, categoryId);
        try ( PreparedStatement st = conn.prepareStatement(sql.toString())) {
            bindFilters(st, params);
            try ( ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.countPublished: " + e);
        }
        return 0;
    }

    private void appendFilters(StringBuilder sql, List<Object> params, String keyword, Integer categoryId) {
        if (categoryId != null && categoryId > 0) {
            sql.append("AND p.blogCategoryID = ? ");
            params.add(categoryId);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (p.title LIKE ? OR p.excerpt LIKE ? OR ISNULL(c.name,'') LIKE ?) ");
            String q = "%" + keyword.trim() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
        }
    }

    private int bindFilters(PreparedStatement st, List<Object> params) throws SQLException {
        int idx = 1;
        for (Object p : params) {
            st.setObject(idx++, p);
        }
        return idx;
    }

    public BlogPost findPublishedBySlug(String slug) {
        String sql = "SELECT p.*, c.name AS categoryName, a.fullname AS authorName "
                + "FROM BlogPost p "
                + "LEFT JOIN BlogCategory c ON c.ID = p.blogCategoryID AND c.status = 1 "
                + "JOIN [Account] a ON a.ID = p.authorAccountID AND a.status = 1 "
                + "WHERE p.slug = ? AND p.status = 1 AND p.publishedAt IS NOT NULL AND p.publishedAt <= SYSUTCDATETIME()";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, slug);
            try ( ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.findPublishedBySlug: " + e);
        }
        return null;
    }

    public void incrementView(int postId) {
        String sql = "UPDATE BlogPost SET viewCount = viewCount + 1 WHERE ID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, postId);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.incrementView: " + e);
        }
    }

    /** Admin: toàn bộ bài (nháp + đã đăng). */
    public List<BlogPost> listAllForAdmin() {
        List<BlogPost> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS categoryName, a.fullname AS authorName "
                + "FROM BlogPost p "
                + "LEFT JOIN BlogCategory c ON c.ID = p.blogCategoryID "
                + "JOIN [Account] a ON a.ID = p.authorAccountID "
                + "ORDER BY p.ID DESC";
        try ( PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.listAllForAdmin: " + e);
        }
        return list;
    }

    public int insert(BlogPost p) {
        String sql = "INSERT INTO BlogPost (blogCategoryID, authorAccountID, title, slug, excerpt, contentHtml, coverImg, status, isFeatured, publishedAt, "
                + "seoTitle, seoDescription, readingMinutes) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try ( PreparedStatement st = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            int i = 1;
            if (p.getBlogCategoryID() != null) {
                st.setInt(i++, p.getBlogCategoryID());
            } else {
                st.setNull(i++, java.sql.Types.INTEGER);
            }
            st.setInt(i++, p.getAuthorAccountID());
            st.setString(i++, p.getTitle());
            st.setString(i++, p.getSlug());
            st.setString(i++, p.getExcerpt());
            st.setString(i++, p.getContentHtml());
            st.setString(i++, p.getCoverImg());
            st.setInt(i++, p.getStatus());
            st.setBoolean(i++, p.isFeatured());
            st.setTimestamp(i++, p.getPublishedAt());
            st.setString(i++, p.getSeoTitle());
            st.setString(i++, p.getSeoDescription());
            if (p.getReadingMinutes() != null) {
                st.setInt(i++, p.getReadingMinutes());
            } else {
                st.setNull(i++, java.sql.Types.SMALLINT);
            }
            if (st.executeUpdate() > 0) {
                try ( ResultSet keys = st.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.insert: " + e);
        }
        return 0;
    }

    private BlogPost map(ResultSet rs) throws SQLException {
        BlogPost p = new BlogPost();
        p.setID(rs.getInt("ID"));
        int cid = rs.getInt("blogCategoryID");
        if (rs.wasNull()) {
            p.setBlogCategoryID(null);
        } else {
            p.setBlogCategoryID(cid);
        }
        p.setAuthorAccountID(rs.getInt("authorAccountID"));
        p.setTitle(rs.getString("title"));
        p.setSlug(rs.getString("slug"));
        p.setExcerpt(rs.getString("excerpt"));
        p.setContentHtml(rs.getString("contentHtml"));
        p.setCoverImg(rs.getString("coverImg"));
        p.setStatus(rs.getInt("status"));
        p.setFeatured(rs.getBoolean("isFeatured"));
        p.setPublishedAt(rs.getTimestamp("publishedAt"));
        p.setDateCreated(rs.getTimestamp("dateCreated"));
        p.setDateUpdated(rs.getTimestamp("dateUpdated"));
        p.setViewCount(rs.getInt("viewCount"));
        p.setSeoTitle(rs.getString("seoTitle"));
        p.setSeoDescription(rs.getString("seoDescription"));
        int rm = rs.getInt("readingMinutes");
        if (rs.wasNull()) {
            p.setReadingMinutes(null);
        } else {
            p.setReadingMinutes(rm);
        }
        p.setCategoryName(rs.getString("categoryName"));
        p.setAuthorName(rs.getString("authorName"));
        return p;
    }
}
