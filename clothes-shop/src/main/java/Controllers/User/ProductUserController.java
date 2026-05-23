package Controllers.User;
import DAO.BrandDAO;
import DAO.CategoryDAO;
import DAO.FeedbackDAO;
import DAO.ImgDescriptionDAO;
import DAO.ProductDAO;
import DAO.ProductVariantDAO;
import Model.Brand;
import Model.Category;
import Model.Feedback;
import Model.ImgDescription;
import Model.Product;
import Model.ProductVariant;
import Utils.ServletPaths;
import Utils.Validation;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;



/**

 *

 * @author HP

 */

@WebServlet(name = "ProductUserController", urlPatterns = {"/product/*"})

public class ProductUserController extends HttpServlet {



    private static CategoryDAO categoryDao;

    private static BrandDAO brandDao;

    private static ProductDAO productDao;

    private static Validation validate;

    private static FeedbackDAO feedbackDao;

    private static final int numberProductInPage = 9;



    public ProductUserController() {
        this.categoryDao = new CategoryDAO();
        this.productDao = new ProductDAO();
        this.validate = new Validation();
        this.feedbackDao = new FeedbackDAO();
        this.brandDao = new BrandDAO();

    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)

            throws ServletException, IOException {
        if (ServletPaths.relativeEquals(request, "/product")
                || ServletPaths.relativeEquals(request, "/product/")) {
            this.productPage(request, response, 1, numberProductInPage);
        } else if (ServletPaths.relativeStartsWith(request, "/product/page-")) {
            int page = ServletPaths.parsePageSuffix(request, "page-");
            if (page <= 0) {
                ServletPaths.redirect404(request, response);
                return;
            }
            this.productPage(request, response, page, numberProductInPage);
        } else if (ServletPaths.relativeStartsWith(request, "/product/detail/")) {
            int id = validate.getInt(ServletPaths.lastSegment(request));
            Product p = productDao.statusIsActive(id);
            if (p == null) {
                ServletPaths.redirect404(request, response);
            } else {
                ImgDescriptionDAO imgDescDao = new ImgDescriptionDAO();
                ProductVariantDAO variantDao = new ProductVariantDAO();
                List<ImgDescription> imgDesc = imgDescDao.getAllImgDescriptionByProduct(id);
                List<Product> productsRelative = productDao.getAllProductActiveRelative(p);
                List<Feedback> feedbacks = feedbackDao.allFeedbackByProduct(id);
                List<ProductVariant> variants = variantDao.findByProductId(id);
                ProductVariant defaultVariant = variantDao.findDefaultOrFirst(id);
                request.setAttribute("feedbacks", feedbacks);
                request.setAttribute("product", p);
                request.setAttribute("imgDesc", imgDesc);
                request.setAttribute("productsRelative", productsRelative);
                request.setAttribute("variants", variants);
                request.setAttribute("defaultVariant", defaultVariant);
                request.setAttribute("variantsJson", new Gson().toJson(variants));
                if (variants.isEmpty()) {
                    request.setAttribute("variantStockNote", "Sản phẩm chưa có biến thể khả dụng.");
                }
                request.getRequestDispatcher("/user/detailProduct.jsp").forward(request, response);
            }
        }
    }



    private void productPage(HttpServletRequest request, HttpServletResponse response, int page, int pageSize)

            throws IOException, ServletException {
        try {
            String type = request.getParameter("type");
            int id = validate.getInt(request.getParameter("id"));
            List<Category> categories = categoryDao.getCategoryActive();
            List<Brand> brands = brandDao.getBrandActive();
            List<Product> products = new ArrayList<Product>();
            int allProduct = 0;
            String urlPage = "product";
            String key = "";
            if (type != null && type.equals("category")) {
                products = productDao.getProductsByPage(page, pageSize, "category", id);
                allProduct = productDao.getAllProductActive("category", id).size();
                key = "?type=category&id=" + id;
                request.setAttribute("idCategory", id);
            } else if (type != null && type.equals("brand")) {
                products = productDao.getProductsByPage(page, pageSize, "brand", id);
                allProduct = productDao.getAllProductActive("brand", id).size();
                request.setAttribute("idBrand", id);
                key = "?type=brand&id=" + id;
            } else {
                products = productDao.getProductsByPage(page, pageSize, "");
                allProduct = productDao.getAllProductActive("").size();
                type = "Shop";
            }
            if (products.size() == 0 && page != 1) {
                ServletPaths.redirect404(request, response);
            } else {
                request.setAttribute("categories", categories);
                request.setAttribute("brands", brands);
                request.setAttribute("products", products);
                request.setAttribute("page", page);
                request.setAttribute("pageSize", pageSize);
                request.setAttribute("sizeProduct", allProduct);
                request.setAttribute("type", type);
                request.setAttribute("urlPage", urlPage);
                request.setAttribute("key", key);
                request.getRequestDispatcher("/user/product.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.out.println("Product page: " + e);
        }
    }
}


