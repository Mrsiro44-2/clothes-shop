/**
 * SweetAlert2 — MomAndBaby (ASCII + \u, khong phu thuoc encoding file/HTML).
 */
(function (global) {
    'use strict';

    var BTN_COLOR = '#D10024';
    var CANCEL_COLOR = '#6c757d';
    var VER = '3';

    var L = {
        success: 'Th\u00e0nh c\u00f4ng',
        error: 'L\u1ed7i',
        warning: 'Ch\u00fa \u00fd',
        confirm: 'X\u00e1c nh\u1eadn',
        confirmDefault: 'B\u1ea1n c\u00f3 ch\u1eafc ch\u1eafc?',
        agree: '\u0110\u1ed3ng \u00fd',
        cancel: 'H\u1ee7y',
        account: 'T\u00e0i kho\u1ea3n',
        errNameEmpty: 'H\u1ecd t\u00ean kh\u00f4ng \u0111\u01b0\u1ee3c \u0111\u1ec3 tr\u1ed1ng.',
        errNameLen: 'H\u1ecd t\u00ean t\u1ed1i \u0111a 200 k\u00fd t\u1ef1.',
        errEmailEmpty: 'Email kh\u00f4ng \u0111\u01b0\u1ee3c \u0111\u1ec3 tr\u1ed1ng.',
        errEmailFmt: 'Email kh\u00f4ng \u0111\u00fang \u0111\u1ecbnh d\u1ea1ng.',
        errPhoneEmpty: 'S\u1ed1 \u0111i\u1ec7n tho\u1ea1i kh\u00f4ng \u0111\u01b0\u1ee3c \u0111\u1ec3 tr\u1ed1ng.',
        errPhoneFmt: 'S\u1ed1 \u0111i\u1ec7n tho\u1ea1i kh\u00f4ng h\u1ee3p l\u1ec7 (VD: 0912345678).',
        errPwdMin: 'M\u1eadt kh\u1ea9u m\u1edbi t\u1ed1i thi\u1ec3u 6 k\u00fd t\u1ef1.',
        errPwdMatch: 'M\u1eadt kh\u1ea9u x\u00e1c nh\u1eadn kh\u00f4ng kh\u1edbp.',
        errPwdConfirm: 'Vui l\u00f2ng nh\u1eadp m\u1eadt kh\u1ea9u m\u1edbi khi \u0111\u00e3 nh\u1eadp x\u00e1c nh\u1eadn.'
    };

    /** N\u1ed9i dung confirm theo key \u2014 kh\u00f4ng \u0111\u1ecdc ti\u1ebfng Vi\u1ec7t t\u1eeb HTML attribute. */
    var CONFIRM = {
        'wishlist-remove': 'B\u1ea1n c\u00f3 ch\u1eafc mu\u1ed1n x\u00f3a kh\u1ecfi danh s\u00e1ch y\u00ean th\u00edch?',
        'order-cancel': 'B\u1ea1n c\u00f3 ch\u1eafc mu\u1ed1n h\u1ee7y \u0111\u01a1n h\u00e0ng?',
        'delete': 'B\u1ea1n c\u00f3 ch\u1eafc mu\u1ed1n x\u00f3a?',
        'logout': 'B\u1ea1n c\u00f3 ch\u1eafc mu\u1ed1n \u0111\u0103ng xu\u1ea5t?'
    };

    function swalReady() {
        return typeof global.Swal !== 'undefined';
    }

    function baseOpts() {
        return {
            confirmButtonColor: BTN_COLOR,
            cancelButtonColor: CANCEL_COLOR
        };
    }

    function resolveConfirmMessage(el) {
        if (!el) {
            return L.confirmDefault;
        }
        var key = el.getAttribute('data-confirm-key');
        if (key && CONFIRM[key]) {
            return CONFIRM[key];
        }
        if (el.classList && el.classList.contains('mb-confirm')) {
            return CONFIRM.delete;
        }
        return L.confirmDefault;
    }

    function findConfirmTrigger(target) {
        if (!target || !target.closest) {
            return null;
        }
        return target.closest('[data-confirm-key], .mb-confirm');
    }

    var MbSwal = {
        version: VER,

        resolveConfirmMessage: resolveConfirmMessage,

        fire: function (opts) {
            if (!swalReady()) {
                if (opts && opts.text) {
                    global.alert(opts.text);
                }
                return Promise.resolve({ isConfirmed: true });
            }
            var o = Object.assign({}, baseOpts(), opts || {});
            return global.Swal.fire(o);
        },

        success: function (title, text) {
            return MbSwal.fire({
                icon: 'success',
                title: title || L.success,
                text: text || ''
            });
        },

        error: function (title, text) {
            return MbSwal.fire({
                icon: 'error',
                title: title || L.error,
                text: text || ''
            });
        },

        warning: function (title, text) {
            return MbSwal.fire({
                icon: 'warning',
                title: title || L.warning,
                text: text || ''
            });
        },

        confirm: function (text, title) {
            return MbSwal.fire({
                icon: 'question',
                title: title || L.confirm,
                text: text || L.confirmDefault,
                showCancelButton: true,
                confirmButtonText: L.agree,
                cancelButtonText: L.cancel
            });
        },

        validateAccountProfile: function (fullname, email, phone, password, confirmPassword) {
            var regexEmail = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            var regexPhone = /^(?:\+?84|0)(3|5|7|8|9)[0-9]{8}$/;
            if (!fullname || !fullname.trim()) {
                return L.errNameEmpty;
            }
            if (fullname.trim().length > 200) {
                return L.errNameLen;
            }
            if (!email || !email.trim()) {
                return L.errEmailEmpty;
            }
            if (!regexEmail.test(email.trim())) {
                return L.errEmailFmt;
            }
            var phoneNorm = (phone || '').trim().replace(/[\s.-]/g, '');
            if (!phoneNorm) {
                return L.errPhoneEmpty;
            }
            if (!regexPhone.test(phoneNorm)) {
                return L.errPhoneFmt;
            }
            var pwd = password || '';
            var confirmPwd = confirmPassword || '';
            if (pwd.length > 0) {
                if (pwd.length < 6) {
                    return L.errPwdMin;
                }
                if (pwd !== confirmPwd) {
                    return L.errPwdMatch;
                }
            } else if (confirmPwd.length > 0) {
                return L.errPwdConfirm;
            }
            return null;
        },

        submitFormWithButton: function (form, btn) {
            if (!form) {
                return;
            }
            if (btn && btn.name) {
                var existing = form.querySelector('input[type="hidden"][name="' + btn.name + '"]');
                if (!existing) {
                    var h = document.createElement('input');
                    h.type = 'hidden';
                    h.name = btn.name;
                    h.value = btn.value || 'on';
                    form.appendChild(h);
                }
            }
            form.submit();
        },

        initConfirmHandlers: function () {
            document.addEventListener('click', function (e) {
                var el = findConfirmTrigger(e.target);
                if (!el) {
                    return;
                }
                e.preventDefault();
                e.stopPropagation();
                MbSwal.confirm(resolveConfirmMessage(el)).then(function (result) {
                    if (!result.isConfirmed) {
                        return;
                    }
                    if (el.tagName === 'A' && el.href) {
                        global.location.href = el.href;
                        return;
                    }
                    var form = el.closest('form');
                    if (form) {
                        MbSwal.submitFormWithButton(form, el);
                    }
                });
            }, true);
        },

        initAccountProfileForm: function (formId, title) {
            var form = document.getElementById(formId);
            if (!form) {
                return;
            }
            form.addEventListener('submit', function (e) {
                e.preventDefault();
                var fullname = (form.querySelector('[name="fullname"]') || {}).value || '';
                var email = (form.querySelector('[name="email"]') || {}).value || '';
                var phone = (form.querySelector('[name="phone"]') || {}).value || '';
                var pwd = (form.querySelector('[name="password"]') || {}).value || '';
                var confirmPwd = (form.querySelector('[name="confirmPassword"]') || {}).value || '';
                var err = MbSwal.validateAccountProfile(fullname, email, phone, pwd, confirmPwd);
                if (err) {
                    MbSwal.error(title || L.account, err);
                    return;
                }
                form.submit();
            });
        }
    };

    global.MbSwal = MbSwal;

    document.addEventListener('DOMContentLoaded', function () {
        MbSwal.initConfirmHandlers();
    });
})(typeof window !== 'undefined' ? window : this);
