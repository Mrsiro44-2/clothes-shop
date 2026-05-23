package Controllers.User;

import DAO.BrandDAO;
import DAO.CategoryDAO;
import DAO.ProductDAO;
import Model.Brand;
import Model.Category;
import Model.Product;
import Utils.AppImages;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "HomeController", urlPatterns = {"/"})
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO productDao = new ProductDAO();
        CategoryDAO categoryDao = new CategoryDAO();
        BrandDAO brandDao = new BrandDAO();
        List<Product> productsDeal = productDao.getProductByPriority(2);
        List<Product> productsFeature = productDao.getProductByPriority(3);
        List<Product> productsNormal = productDao.getProductByPriority(1);
        List<Category> categories = categoryDao.getCategoryInHome();
        List<Brand> brands = brandDao.getTopBrand();
        request.setAttribute("brands", brands);
        request.setAttribute("categories", categories);
        request.setAttribute("productsDeal", productsDeal);
        request.setAttribute("productsFeature", productsFeature);
        request.setAttribute("productsNormal", productsNormal);
        request.setAttribute("homeBanners", AppImages.HOME_BANNER_URLS);
        request.getRequestDispatcher("./user/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
