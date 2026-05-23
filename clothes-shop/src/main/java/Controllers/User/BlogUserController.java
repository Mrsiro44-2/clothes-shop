package Controllers.User;

import DAO.BlogCategoryDAO;
import DAO.BlogPostDAO;
import Model.BlogCategory;
import Model.BlogPost;
import Utils.AppImages;
import Utils.ServletPaths;
import Utils.Validation;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "BlogUserController", urlPatterns = {"/blog", "/blog/*"})
public class BlogUserController extends HttpServlet {

    private static final int PAGE_SIZE = 9;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BlogPostDAO dao = new BlogPostDAO();
        Validation v = new Validation();
        if (ServletPaths.relativeStartsWith(request, "/blog/detail/")) {
            String slug = ServletPaths.segmentAfter(request, "/blog/detail/");
            BlogPost post = dao.findPublishedBySlug(slug);
            if (post == null) {
                ServletPaths.redirect(request, response, "/404");
                return;
            }
            dao.incrementView(post.getID());
            request.setAttribute("post", post);
            request.setAttribute("blogDefaultCover", AppImages.BLOG_DEFAULT_COVER);
            request.getRequestDispatcher("/user/blog-detail.jsp").forward(request, response);
            return;
        }

        int page = v.getInt(request.getParameter("page"));
        if (page <= 0) {
            page = 1;
        }
        String keyword = request.getParameter("q");
        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }
        Integer categoryId = null;
        int catParam = v.getInt(request.getParameter("category"));
        if (catParam > 0) {
            categoryId = catParam;
        }

        int total = dao.countPublished(keyword, categoryId);
        int totalPages = (int) Math.ceil(Math.max(total, 1) / (double) PAGE_SIZE);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }
        int offset = (page - 1) * PAGE_SIZE;
        List<BlogPost> posts = dao.searchPublished(keyword, categoryId, offset, PAGE_SIZE);
        List<BlogCategory> categories = new BlogCategoryDAO().listActive();

        request.setAttribute("posts", posts);
        request.setAttribute("categories", categories);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalPosts", total);
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("categoryId", categoryId != null ? categoryId : 0);
        request.setAttribute("blogDefaultCover", AppImages.BLOG_DEFAULT_COVER);
        request.getRequestDispatcher("/user/blog.jsp").forward(request, response);
    }
}
