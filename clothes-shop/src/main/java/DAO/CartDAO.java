package DAO;

import Model.Cart;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    private Connection conn;

    public CartDAO() {
        try {
            this.conn = DBConnection.DBConnection.connect();
        } catch (Exception e) {
            System.err.println("Connection fail: " + e);
            this.conn = null;
        }
    }

    public List<Cart> getAllCart(int userId) {
        String sql = "SELECT c.ID, c.accountID, c.quantity, c.productVariantID, c.dateAdded, "
                + "p.ID AS pid, p.name AS pname, "
                + "COALESCE(NULLIF(LTRIM(RTRIM(v.variantImg)), ''), p.mainImg) AS mainImg, "
                + "CAST(ISNULL(v.newPrice, 0) AS FLOAT) AS unitNew, CAST(ISNULL(v.oldPrice, 0) AS FLOAT) AS unitOld, "
                + "v.quantity AS stockQty, s.label AS sizeLabel, col.name AS colorName "
                + "FROM Cart c "
                + "JOIN ProductVariant v ON v.ID = c.productVariantID "
                + "JOIN Product p ON p.ID = v.productID "
                + "JOIN SizeOption s ON s.ID = v.sizeOptionID "
                + "JOIN ColorOption col ON col.ID = v.colorOptionID "
                + "WHERE c.accountID = ?";
        List<Cart> carts = new ArrayList<>();
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, userId);
            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    carts.add(mapEnriched(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("Get all cart: " + e);
        }
        return carts;
    }

    public Cart getByAccountAndVariant(int accountId, int variantId) {
        String sql = "SELECT c.ID, c.accountID, c.quantity, c.productVariantID, c.dateAdded, "
                + "p.ID AS pid, p.name AS pname, "
                + "COALESCE(NULLIF(LTRIM(RTRIM(v.variantImg)), ''), p.mainImg) AS mainImg, "
                + "CAST(ISNULL(v.newPrice, 0) AS FLOAT) AS unitNew, CAST(ISNULL(v.oldPrice, 0) AS FLOAT) AS unitOld, "
                + "v.quantity AS stockQty, s.label AS sizeLabel, col.name AS colorName "
                + "FROM Cart c "
                + "JOIN ProductVariant v ON v.ID = c.productVariantID "
                + "JOIN Product p ON p.ID = v.productID "
                + "JOIN SizeOption s ON s.ID = v.sizeOptionID "
                + "JOIN ColorOption col ON col.ID = v.colorOptionID "
                + "WHERE c.accountID = ? AND c.productVariantID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, accountId);
            st.setInt(2, variantId);
            try ( ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapEnriched(rs);
                }
            }
        } catch (Exception e) {
            System.out.println("getByAccountAndVariant: " + e);
        }
        return null;
    }

    public int addToCart(Cart c) {
        String sql = "INSERT INTO Cart (accountID, productVariantID, quantity) VALUES (?, ?, ?)";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, c.getAccountID());
            st.setInt(2, c.getProductVariantID());
            st.setInt(3, c.getQuantity());
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("Add to cart: " + e);
        }
        return 0;
    }

    public int updateToCart(Cart c) {
        String sql = "UPDATE Cart SET quantity = ? WHERE accountID = ? AND productVariantID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, c.getQuantity());
            st.setInt(2, c.getAccountID());
            st.setInt(3, c.getProductVariantID());
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("Update to cart: " + e);
        }
        return 0;
    }

    public int deleteCartItem(int id) {
        String sql = "DELETE FROM Cart WHERE ID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("Delete cart error: " + e);
        }
        return 0;
    }

    public int deleteCartItemByUser(int user) {
        String sql = "DELETE FROM Cart WHERE accountID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, user);
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("Delete cart error by user: " + e);
        }
        return 0;
    }

    private Cart mapEnriched(ResultSet rs) throws SQLException {
        Cart c = new Cart();
        c.setID(rs.getInt("ID"));
        c.setAccountID(rs.getInt("accountID"));
        c.setQuantity(rs.getInt("quantity"));
        c.setProductVariantID(rs.getInt("productVariantID"));
        c.setDateAdded(rs.getTimestamp("dateAdded"));
        c.setProductID(rs.getInt("pid"));
        c.setProductName(rs.getString("pname"));
        c.setMainImg(rs.getString("mainImg"));
        c.setUnitNewPrice(rs.getFloat("unitNew"));
        c.setUnitOldPrice(rs.getFloat("unitOld"));
        c.setStockQty(rs.getInt("stockQty"));
        c.setSizeLabel(rs.getString("sizeLabel"));
        c.setColorName(rs.getString("colorName"));
        return c;
    }
}
