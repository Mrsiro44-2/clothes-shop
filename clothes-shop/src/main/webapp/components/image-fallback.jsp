<%-- Ảnh lỗi: ẩn, không thay bằng placeholder --%>
<script>
function mbImgOnError(img) {
    if (!img || img.dataset.mbErr === '1') return;
    img.dataset.mbErr = '1';
    img.style.display = 'none';
    img.removeAttribute('src');
}
document.addEventListener('error', function (e) {
    var t = e.target;
    if (t && t.tagName === 'IMG' && t.classList && t.classList.contains('mb-img')) {
        mbImgOnError(t);
    }
}, true);
</script>

