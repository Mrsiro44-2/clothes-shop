<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@include file="./components/header.jsp" %>
<link type="text/css" rel="stylesheet" href="./user/css/blog-v2.css" />

<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${ctx}/home">Trang chủ</a></li>
            <li class="active">Blog</li>
        </ul>
    </div>
</div>

<div class="section mb-blog-page">
    <div class="container">
        <div class="mb-blog-hero">
            <h1>Blog Mom & Baby</h1>
            <p>Kiến thức, mẹo hay và tin tức dành cho mẹ và bé</p>
        </div>

        <form class="mb-blog-toolbar" method="get" action="${ctx}/blog">
            <div class="mb-blog-search">
                <input type="text" name="q" value="${keyword}" placeholder="Tìm bài viết theo tiêu đề, mô tả..."/>
                <button type="submit"><i class="fa fa-search"></i> Tìm kiếm</button>
            </div>
            <div class="mb-blog-filters">
                <label>Danh mục:</label>
                <c:url var="allBlogUrl" value="/blog">
                    <c:if test="${not empty keyword}">
                        <c:param name="q" value="${keyword}"/>
                    </c:if>
                </c:url>
                <a href="${allBlogUrl}" class="mb-blog-chip ${categoryId == 0 ? 'active' : ''}">Tất cả</a>
                <c:forEach items="${categories}" var="cat">
                    <c:url var="catUrl" value="/blog">
                        <c:param name="category" value="${cat.ID}"/>
                        <c:if test="${not empty keyword}">
                            <c:param name="q" value="${keyword}"/>
                        </c:if>
                    </c:url>
                    <a href="${catUrl}" class="mb-blog-chip ${categoryId == cat.ID ? 'active' : ''}">${cat.name}</a>
                </c:forEach>
            </div>
        </form>

        <c:if test="${not empty keyword or categoryId > 0}">
            <p style="margin:-12px 0 20px;color:#6b7280;font-size:14px">
                Tìm thấy <strong>${totalPosts}</strong> bài viết
                <c:if test="${not empty keyword}"> cho "<em>${keyword}</em>"</c:if>
            </p>
        </c:if>

        <div class="mb-blog-grid">
            <c:forEach items="${posts}" var="p">
                <article class="mb-blog-card">
                    <c:choose>
                        <c:when test="${not empty p.coverImg}">
                            <c:set var="coverSrc" value="${imgUrl.resolve(p.coverImg, ctx)}"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="coverSrc" value="${blogDefaultCover}"/>
                        </c:otherwise>
                    </c:choose>
                    <a href="${ctx}/blog/detail/${p.slug}" class="mb-blog-card__img-wrap">
                        <img src="${coverSrc}" alt="${p.title}"
                             data-fallback="${blogDefaultCover}"
                             class="mb-blog-img"
                             onerror="mbBlogImgOnError(this)"/>
                    </a>
                    <div class="mb-blog-card__body">
                        <h3 class="mb-blog-card__title">
                            <a href="${ctx}/blog/detail/${p.slug}">${p.title}</a>
                        </h3>
                        <div class="mb-blog-card__meta">
                            <c:if test="${not empty p.publishedAt}">
                                <fmt:formatDate value="${p.publishedAt}" pattern="dd MMM, yyyy" />
                            </c:if>
                            <span>by <span class="mb-blog-card__author">${not empty p.authorName ? p.authorName : 'Admin'}</span></span>
                            <span class="mb-blog-card__read-time">
                                <c:choose>
                                    <c:when test="${not empty p.readingMinutes and p.readingMinutes > 0}">
                                        ${p.readingMinutes} phút đọc
                                    </c:when>
                                    <c:otherwise>5 phút đọc</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="mb-blog-card__stats">
                            <i class="fa fa-eye"></i> ${p.viewCount} lượt xem
                            <c:if test="${not empty p.categoryName}"> · ${p.categoryName}</c:if>
                        </div>
                        <p class="mb-blog-card__excerpt">
                            <c:choose>
                                <c:when test="${not empty p.excerpt}">${p.excerpt}</c:when>
                                <c:otherwise>${fn:substring(p.title, 0, 120)}...</c:otherwise>
                            </c:choose>
                        </p>
                        <a href="${ctx}/blog/detail/${p.slug}" class="mb-blog-card__more">Đọc thêm →</a>
                    </div>
                </article>
            </c:forEach>
            <c:if test="${empty posts}">
                <div class="mb-blog-empty">
                    <p>Chưa có bài viết phù hợp.</p>
                    <a href="${ctx}/blog" class="mb-blog-card__more">Xem tất cả bài viết</a>
                </div>
            </c:if>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="mb-blog-pagination">
                <c:if test="${page > 1}">
                    <c:url var="prevUrl" value="/blog">
                        <c:param name="page" value="${page - 1}"/>
                        <c:if test="${not empty keyword}"><c:param name="q" value="${keyword}"/></c:if>
                        <c:if test="${categoryId > 0}"><c:param name="category" value="${categoryId}"/></c:if>
                    </c:url>
                    <a href="${prevUrl}">&laquo;</a>
                </c:if>
                <c:forEach begin="1" end="${totalPages}" var="pg">
                    <c:url var="pageUrl" value="/blog">
                        <c:param name="page" value="${pg}"/>
                        <c:if test="${not empty keyword}"><c:param name="q" value="${keyword}"/></c:if>
                        <c:if test="${categoryId > 0}"><c:param name="category" value="${categoryId}"/></c:if>
                    </c:url>
                    <c:choose>
                        <c:when test="${pg == page}"><span class="active">${pg}</span></c:when>
                        <c:otherwise><a href="${pageUrl}">${pg}</a></c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:if test="${page < totalPages}">
                    <c:url var="nextUrl" value="/blog">
                        <c:param name="page" value="${page + 1}"/>
                        <c:if test="${not empty keyword}"><c:param name="q" value="${keyword}"/></c:if>
                        <c:if test="${categoryId > 0}"><c:param name="category" value="${categoryId}"/></c:if>
                    </c:url>
                    <a href="${nextUrl}">&raquo;</a>
                </c:if>
            </div>
        </c:if>
    </div>
</div>

<script>
function mbBlogImgOnError(img) {
    if (!img || img.dataset.mbFb === '1') return;
    var fb = img.getAttribute('data-fallback');
    if (fb && img.src !== fb) {
        img.dataset.mbFb = '1';
        img.src = fb;
        return;
    }
    img.style.display = 'none';
}
</script>
<%@include file="./components/footer.jsp" %>
