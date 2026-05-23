/**
 * Overlay loading khi submit form (không disable nút submit — tránh mất requestReset/submitReset).
 */
(function (global) {
    'use strict';

    function attach(formId, btnId, loadingText) {
        var form = document.getElementById(formId);
        var btn = document.getElementById(btnId);
        if (!form || !btn) {
            return;
        }
        var text = loadingText || 'Đang xử lý...';
        var submitting = false;

        form.addEventListener('submit', function () {
            if (submitting) {
                return;
            }
            submitting = true;

            if (!btn.getAttribute('data-mb-orig-html')) {
                btn.setAttribute('data-mb-orig-html', btn.innerHTML);
            }
            btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> ' + text;
            btn.style.pointerEvents = 'none';
            btn.style.opacity = '0.85';

            var existing = document.getElementById('mbFormLoadingOverlay');
            if (!existing) {
                var overlay = document.createElement('div');
                overlay.className = 'mb-form-loading-overlay';
                overlay.setAttribute('id', 'mbFormLoadingOverlay');
                overlay.innerHTML = '<div class="mb-form-loading-box"><i class="fa fa-spinner fa-spin"></i><span>'
                    + text + '</span></div>';
                document.body.appendChild(overlay);
            }
        });
    }

    global.mbFormLoading = { attach: attach };
})(typeof window !== 'undefined' ? window : this);
