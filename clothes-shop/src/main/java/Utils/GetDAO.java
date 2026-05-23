/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utils;

import DAO.AccountDAO;
import DAO.BrandDAO;
import DAO.CategoryDAO;
import DAO.ProducerDAO;
import DAO.ProductDAO;
import DAO.RoleDAO;
import Model.Account;
import Model.Brand;
import Model.Category;
import Model.Producer;
import Model.Product;
import Model.Role;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author HP
 */
public class GetDAO {

    public Role getRole(int id) {
        RoleDAO roleDao = new RoleDAO();
        return roleDao.getRoleById(id);
    }

    public Account getAccount(String username) {
        AccountDAO accountDao = new AccountDAO();
        return accountDao.isExistAccount(username, "");
    }
    
    public Account getUser(int id) {
        AccountDAO accountDao = new AccountDAO();
        return accountDao.getAccountById(id);
    }

    public String getNavigation(String key) {
        return getNavigation(key, "");
    }

    public String getNavigation(String key, String contextPath) {
        if (contextPath == null) {
            contextPath = "";
        }
        Validation validate = new Validation();
        CategoryDAO categoryDao = new CategoryDAO();
        BrandDAO brandDao = new BrandDAO();
        Map<String, String> queryParams = new HashMap<>();
        if (!key.equals("")) {
            String[] pairs = key.split("&");
            for (String pair : pairs) {
                String[] keyValue = pair.split("=");
                if (keyValue.length > 1) {
                    queryParams.put(keyValue[0], keyValue[1]);
                } else {
                    queryParams.put(keyValue[0], "");
                }
            }
        }
        if (queryParams.get("?type") != null && queryParams.get("?type").equals("category")) {
            int id = validate.getInt(queryParams.get("id"));
            String keyType = "?type=category&id=" + id;
            Category cate = categoryDao.getCategoryActiveByID(id);
            return "<li><a href=\"" + contextPath + "/product" + keyType + "\">" + cate.getName() + "</a></li>";
        } else if (queryParams.get("?type") != null && queryParams.get("?type").equals("brand")) {
            int id = validate.getInt(queryParams.get("id"));
            String keyType = "?type=brand&id=" + id;
            Brand brand = brandDao.getBrandActiveByID(id);
            return "<li><a href=\"" + contextPath + "/product" + keyType + "\">" + brand.getName() + "</a></li>";
        }
        return "";
    }

    public int getNumberOfProductByCategory(int id) {
        CategoryDAO categoryDao = new CategoryDAO();
        return (categoryDao.getNumberProductByCategory(id));
    }

    public int getNumberProductByProducer(int id) {
        ProducerDAO producerDao = new ProducerDAO();
        return (producerDao.getNumberProductByProducer(id));
    }

    public int getNumberProductByBrand(int id) {
        BrandDAO brandDao = new BrandDAO();
        return (brandDao.getNumberProductByBrand(id));
    }

    public Brand getBrandById(int id) {
        BrandDAO brandDao = new BrandDAO();
        return brandDao.getBrandByID(id);
    }

    public Category getCategoryById(int id) {
        CategoryDAO categoryDAO = new CategoryDAO();
        return categoryDAO.getCategoryByID(id);
    }
    
    public Producer getProducerByID(int id) {
        ProducerDAO producerDao = new ProducerDAO();
        return producerDao.getProducerByID(id);
    }
    
    public Product getProduct(int id) {
        ProductDAO productDao = new ProductDAO();
        return productDao.statusIsActive(id);
    }
}
