<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="swalIconVal" value="${swalIcon}" />
<c:set var="swalTitleVal" value="${swalTitle}" />
<c:set var="swalMessageVal" value="${swalMessage}" />
<c:if test="${empty swalMessageVal}">
    <c:set var="swalIconVal" value="${sessionScope.swalIcon}" />
    <c:set var="swalTitleVal" value="${sessionScope.swalTitle}" />
    <c:set var="swalMessageVal" value="${sessionScope.swalMessage}" />
</c:if>
<c:if test="${not empty swalMessageVal}">
<div id="mb-swal-flash" style="display:none"
     data-icon="<c:out value='${swalIconVal}' default='info'/>"
     data-title="<c:out value='${swalTitleVal}'/>"
     data-message="<c:out value='${swalMessageVal}'/>"></div>
<script>
document.addEventListener('DOMContentLoaded', function () {
    var el = document.getElementById('mb-swal-flash');
    if (!el) return;
    var icon = el.getAttribute('data-icon') || 'info';
    var title = el.getAttribute('data-title') || '';
    var text = el.getAttribute('data-message') || '';
    if (typeof MbSwal !== 'undefined') {
        MbSwal.fire({ icon: icon, title: title, text: text });
    } else if (typeof Swal !== 'undefined') {
        Swal.fire({ icon: icon, title: title, text: text, confirmButtonColor: '#D10024' });
    }
    el.parentNode.removeChild(el);
});
</script>
<c:remove var="swalIcon" scope="session"/>
<c:remove var="swalTitle" scope="session"/>
<c:remove var="swalMessage" scope="session"/>
</c:if>

