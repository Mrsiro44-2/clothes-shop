package DAO;

import Model.ProductVariant;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ProductVariantDAO {

    private final Connection conn;

    public ProductVariantDAO() {
        conn = DBConnection.DBConnection.connect();
    }

    public List<ProductVariant> findByProductId(int productId) {
        List<ProductVariant> list = new ArrayList<>();
        String sql = "SELECT v.*, s.label AS sizeLabel, c.name AS colorName, c.hexCode AS colorHex "
                + "FROM ProductVariant v "
                + "JOIN SizeOption s ON s.ID = v.sizeOptionID "
                + "JOIN ColorOption c ON c.ID = v.colorOptionID "
                + "WHERE v.productID = ? AND v.status = 1 ORDER BY v.isDefault DESC, v.ID";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, productId);
            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapJoin(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("ProductVariantDAO.findByProductId: " + e);
        }
        return list;
    }

    public ProductVariant findById(int id) {
        String sql = "SELECT v.*, s.label AS sizeLabel, c.name AS colorName, c.hexCode AS colorHex "
                + "FROM ProductVariant v "
                + "JOIN SizeOption s ON s.ID = v.sizeOptionID "
                + "JOIN ColorOption c ON c.ID = v.colorOptionID "
                + "WHERE v.ID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            try ( ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapJoin(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("ProductVariantDAO.findById: " + e);
        }
        return null;
    }

    public ProductVariant findDefaultOrFirst(int productId) {
        ProductVariant def = findDefault(productId);
        if (def != null) {
            return def;
        }
        List<ProductVariant> all = findByProductId(productId);
        return all.isEmpty() ? null : all.get(0);
    }

    private ProductVariant findDefault(int productId) {
        String sql = "SELECT TOP 1 v.*, s.label AS sizeLabel, c.name AS colorName, c.hexCode AS colorHex "
                + "FROM ProductVariant v "
                + "JOIN SizeOption s ON s.ID = v.sizeOptionID "
                + "JOIN ColorOption c ON c.ID = v.colorOptionID "
                + "WHERE v.productID = ? AND v.isDefault = 1 AND v.status = 1 ORDER BY v.ID";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, productId);
            try ( ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapJoin(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("ProductVariantDAO.findDefault: " + e);
        }
        return null;
    }

    public boolean skuExists(String sku, Integer excludeId) {
        String sql = "SELECT COUNT(*) FROM ProductVariant WHERE sku = ?"
                + (excludeId != null ? " AND ID <> ?" : "");
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, sku);
            if (excludeId != null) {
                st.setInt(2, excludeId);
            }
            try ( ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("ProductVariantDAO.skuExists: " + e);
        }
        return false;
    }

    public int insert(ProductVariant v) {
        String sql = "INSERT INTO ProductVariant (productID, sizeOptionID, colorOptionID, sku, barcode, oldPrice, newPrice, quantity, variantImg, weightGrams, isDefault, status, dateCreated) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?, SYSUTCDATETIME())";
        try ( PreparedStatement st = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            int i = 1;
            st.setInt(i++, v.getProductID());
            st.setInt(i++, v.getSizeOptionID());
            st.setInt(i++, v.getColorOptionID());
            st.setString(i++, v.getSku());
            st.setString(i++, v.getBarcode());
            st.setBigDecimal(i++, java.math.BigDecimal.valueOf(v.getOldPrice()));
            st.setBigDecimal(i++, java.math.BigDecimal.valueOf(v.getNewPrice()));
            st.setInt(i++, v.getQuantity());
            st.setString(i++, v.getVariantImg());
            if (v.getWeightGrams() != null) {
                st.setInt(i++, v.getWeightGrams());
            } else {
                st.setNull(i++, java.sql.Types.INTEGER);
            }
            st.setBoolean(i++, v.isDefault());
            st.setInt(i++, v.getStatus());
            int rows = st.executeUpdate();
            if (rows > 0) {
                try ( ResultSet keys = st.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("ProductVariantDAO.insert: " + e);
        }
        return 0;
    }

    public int update(ProductVariant v) {
        String sql = "UPDATE ProductVariant SET sizeOptionID=?, colorOptionID=?, sku=?, barcode=?, oldPrice=?, newPrice=?, quantity=?, variantImg=?, weightGrams=?, isDefault=?, status=?, dateUpdated=SYSUTCDATETIME() WHERE ID=?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            int i = 1;
            st.setInt(i++, v.getSizeOptionID());
            st.setInt(i++, v.getColorOptionID());
            st.setString(i++, v.getSku());
            st.setString(i++, v.getBarcode());
            st.setBigDecimal(i++, java.math.BigDecimal.valueOf(v.getOldPrice()));
            st.setBigDecimal(i++, java.math.BigDecimal.valueOf(v.getNewPrice()));
            st.setInt(i++, v.getQuantity());
            st.setString(i++, v.getVariantImg());
            if (v.getWeightGrams() != null) {
                st.setInt(i++, v.getWeightGrams());
            } else {
                st.setNull(i++, java.sql.Types.INTEGER);
            }
            st.setBoolean(i++, v.isDefault());
            st.setInt(i++, v.getStatus());
            st.setInt(i++, v.getID());
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("ProductVariantDAO.update: " + e);
        }
        return 0;
    }

    public void clearDefaultFlagExcept(int productId, int keepVariantId) {
        String sql = "UPDATE ProductVariant SET isDefault = 0 WHERE productID = ? AND ID <> ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, productId);
            st.setInt(2, keepVariantId);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("ProductVariantDAO.clearDefaultFlagExcept: " + e);
        }
    }

    public int decrementStock(int variantId, int qty) {
        String sql = "UPDATE ProductVariant SET quantity = quantity - ? WHERE ID = ? AND quantity >= ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, qty);
            st.setInt(2, variantId);
            st.setInt(3, qty);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("ProductVariantDAO.decrementStock: " + e);
        }
        return 0;
    }

    public int incrementStock(int variantId, int qty) {
        if (variantId <= 0 || qty <= 0) {
            return 0;
        }
        String sql = "UPDATE ProductVariant SET quantity = quantity + ? WHERE ID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, qty);
            st.setInt(2, variantId);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("ProductVariantDAO.incrementStock: " + e);
        }
        return 0;
    }

    private ProductVariant mapJoin(ResultSet rs) throws SQLException {
        ProductVariant v = new ProductVariant();
        v.setID(rs.getInt("ID"));
        v.setProductID(rs.getInt("productID"));
        v.setSizeOptionID(rs.getInt("sizeOptionID"));
        v.setColorOptionID(rs.getInt("colorOptionID"));
        v.setSku(rs.getString("sku"));
        v.setBarcode(rs.getString("barcode"));
        v.setOldPrice(rs.getBigDecimal("oldPrice").floatValue());
        v.setNewPrice(rs.getBigDecimal("newPrice").floatValue());
        v.setQuantity(rs.getInt("quantity"));
        v.setVariantImg(rs.getString("variantImg"));
        int w = rs.getInt("weightGrams");
        if (rs.wasNull()) {
            v.setWeightGrams(null);
        } else {
            v.setWeightGrams(w);
        }
        v.setDefault(rs.getBoolean("isDefault"));
        v.setStatus(rs.getInt("status"));
        Timestamp dc = rs.getTimestamp("dateCreated");
        v.setDateCreated(dc);
        Timestamp du = rs.getTimestamp("dateUpdated");
        v.setDateUpdated(du);
        v.setSizeLabel(rs.getString("sizeLabel"));
        v.setColorName(rs.getString("colorName"));
        v.setColorHex(rs.getString("colorHex"));
        return v;
    }
}
