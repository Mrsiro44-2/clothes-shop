package DAO;

import Model.WishlistItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class WishlistDAO {

    private final Connection conn;

    public WishlistDAO() {
        conn = DBConnection.DBConnection.connect();
    }

    public List<WishlistItem> findByAccount(int accountId) {
        String sql = "SELECT w.ID, w.accountID, w.productVariantID, w.dateAdded, "
                + "p.ID AS pid, p.name AS pname, p.mainImg, "
                + "CAST(ISNULL(v.newPrice, 0) AS FLOAT) AS unitNew, CAST(ISNULL(v.oldPrice, 0) AS FLOAT) AS unitOld, "
                + "v.quantity AS stockQty, s.label AS sizeLabel, col.name AS colorName "
                + "FROM Wishlist w "
                + "JOIN ProductVariant v ON v.ID = w.productVariantID "
                + "JOIN Product p ON p.ID = v.productID "
                + "JOIN SizeOption s ON s.ID = v.sizeOptionID "
                + "JOIN ColorOption col ON col.ID = v.colorOptionID "
                + "WHERE w.accountID = ? ORDER BY w.dateAdded DESC";
        List<WishlistItem> list = new ArrayList<>();
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, accountId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("WishlistDAO.findByAccount: " + e);
        }
        return list;
    }

    public int countByAccount(int accountId) {
        String sql = "SELECT COUNT(*) FROM Wishlist WHERE accountID = ?";
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, accountId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("WishlistDAO.countByAccount: " + e);
        }
        return 0;
    }

    public boolean exists(int accountId, int variantId) {
        String sql = "SELECT 1 FROM Wishlist WHERE accountID = ? AND productVariantID = ?";
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, accountId);
            st.setInt(2, variantId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.out.println("WishlistDAO.exists: " + e);
        }
        return false;
    }

    public int add(int accountId, int variantId) {
        if (exists(accountId, variantId)) {
            return 1;
        }
        String sql = "INSERT INTO Wishlist (accountID, productVariantID) VALUES (?, ?)";
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, accountId);
            st.setInt(2, variantId);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("WishlistDAO.add: " + e);
        }
        return 0;
    }

    public int remove(int accountId, int wishlistId) {
        String sql = "DELETE FROM Wishlist WHERE ID = ? AND accountID = ?";
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, wishlistId);
            st.setInt(2, accountId);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("WishlistDAO.remove: " + e);
        }
        return 0;
    }

    /**
     * productID -> [wishlistRowId, productVariantID] (mỗi sản phẩm một dòng yêu thích).
     */
    public Map<Integer, int[]> findProductMapByAccount(int accountId) {
        Map<Integer, int[]> map = new HashMap<>();
        if (accountId <= 0 || conn == null) {
            return map;
        }
        String sql = "SELECT w.ID, w.productVariantID, v.productID "
                + "FROM Wishlist w "
                + "JOIN ProductVariant v ON v.ID = w.productVariantID "
                + "WHERE w.accountID = ? ORDER BY w.dateAdded DESC";
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, accountId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    int pid = rs.getInt("productID");
                    if (!map.containsKey(pid)) {
                        map.put(pid, new int[]{rs.getInt("ID"), rs.getInt("productVariantID")});
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("WishlistDAO.findProductMapByAccount: " + e);
        }
        return map;
    }

    public int removeByVariant(int accountId, int variantId) {
        String sql = "DELETE FROM Wishlist WHERE accountID = ? AND productVariantID = ?";
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, accountId);
            st.setInt(2, variantId);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("WishlistDAO.removeByVariant: " + e);
        }
        return 0;
    }

    private WishlistItem map(ResultSet rs) throws SQLException {
        WishlistItem w = new WishlistItem();
        w.setId(rs.getInt("ID"));
        w.setAccountID(rs.getInt("accountID"));
        w.setProductVariantID(rs.getInt("productVariantID"));
        w.setProductID(rs.getInt("pid"));
        w.setProductName(rs.getString("pname"));
        w.setMainImg(rs.getString("mainImg"));
        w.setSizeLabel(rs.getString("sizeLabel"));
        w.setColorName(rs.getString("colorName"));
        float newP = rs.getFloat("unitNew");
        float oldP = rs.getFloat("unitOld");
        w.setDisplayPrice(newP > 0 ? newP : oldP);
        w.setStockQty(rs.getInt("stockQty"));
        w.setDateAdded(rs.getTimestamp("dateAdded"));
        return w;
    }
}
