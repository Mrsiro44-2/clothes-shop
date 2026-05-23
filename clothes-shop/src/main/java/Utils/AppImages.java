package Utils;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;


public class AppImages {

  public static final String BLOG_DEFAULT_COVER =
    "https://images.unsplash.com/photo-1515488042361-ee00e945a1be?w=800&q=80";

  public static final String[] HOME_BANNER_URLS = {
    "https://upcontent.vn/wp-content/uploads/2024/06/banner-shop-thoi-trang-1.jpg",
    "https://upcontent.vn/wp-content/uploads/2024/06/banner-shop-thoi-trang-2.jpg",
    "https://upcontent.vn/wp-content/uploads/2024/06/banner-thoi-trang-nu-3.jpg",
    "https://upcontent.vn/wp-content/uploads/2024/06/banner-shop-thoi-trang-5.jpg",
    "https://upcontent.vn/wp-content/uploads/2024/06/banner-shop-thoi-trang-4.jpg"
  };

  public AppImages() {
  }

  public List<String> getHomeBannerList() {
    return Collections.unmodifiableList(Arrays.asList(HOME_BANNER_URLS));
  }
}
