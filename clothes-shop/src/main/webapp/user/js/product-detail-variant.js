/**
 * Product detail: chọn màu / size -> gán productVariantID, giá, tồn kho.
 */
(function () {
    var variants = window.MB_PRODUCT_VARIANTS || [];
    var ctx = window.MB_CTX || "";
    var defaultId = window.MB_DEFAULT_VARIANT_ID || 0;
    var mainImg = window.MB_MAIN_IMG || "";
    var L = window.MB_LABELS || {};
    var CUR = L.currency || "VN\u0111";

    var $colorWrap = document.getElementById("mb-color-options");
    var $sizeSelect = document.getElementById("mb-size-select");
    var $sizeOptions = document.getElementById("mb-size-options");
    var $colorName = document.getElementById("mb-color-name");
    var $sizeName = document.getElementById("mb-size-name");
    var $wishVariant = document.getElementById("mb-wish-variant-id");
    var $variantInput = document.getElementById("mb-variant-id");
    var $qty = document.getElementById("number");
    var $stock = document.getElementById("mb-stock-label");
    var $priceBox = document.getElementById("mb-detail-price");
    var $addBtn = document.getElementById("mb-add-cart-btn");
    var $noVariant = document.getElementById("mb-no-variant-msg");

    if (!variants.length) {
        if ($noVariant) {
            $noVariant.style.display = "block";
        }
        if ($addBtn) {
            $addBtn.disabled = true;
        }
        return;
    }

    var active = variants.filter(function (v) {
        return v.status === 1 || v.status === undefined;
    });
    if (!active.length) {
        active = variants;
    }

    var colors = [];
    var colorMap = {};
    active.forEach(function (v) {
        var cid = v.colorOptionID;
        if (!colorMap[cid]) {
            colorMap[cid] = {
                id: cid,
                name: v.colorName || "Màu",
                hex: v.colorHex || "#cccccc",
            };
            colors.push(colorMap[cid]);
        }
    });

    var selectedColorId = null;
    var selectedVariantId = null;

    function formatPrice(n) {
        n = parseFloat(n) || 0;
        return n.toLocaleString("vi-VN");
    }

    function findVariant(colorId, sizeId) {
        return active.find(function (v) {
            return v.colorOptionID === colorId && v.sizeOptionID === sizeId;
        });
    }

    function findFirstForColor(colorId) {
        return active.find(function (v) {
            return v.colorOptionID === colorId;
        });
    }

    function applyVariant(v) {
        if (!v) {
            return;
        }
        selectedVariantId = v.ID;
        if ($variantInput) {
            $variantInput.value = v.ID;
        }
        var qty = v.quantity || 0;
        if ($qty) {
            $qty.max = Math.max(qty, 1);
            if (parseInt($qty.value, 10) > qty) {
                $qty.value = qty > 0 ? qty : 1;
            }
            $qty.disabled = qty <= 0;
        }
        if ($stock) {
            if (qty > 0) {
                $stock.textContent = (L.inStock || "C\u00f2n h\u00e0ng") + " (" + qty + ")";
            } else {
                $stock.textContent = L.outStock || "H\u1ebft h\u00e0ng";
            }
        }
        if ($addBtn) {
            $addBtn.disabled = qty <= 0;
        }
        if ($wishVariant) {
            $wishVariant.value = v.ID;
        }
        if ($colorName && v.colorName) {
            $colorName.textContent = v.colorName;
        }
        if ($sizeName && v.sizeLabel) {
            $sizeName.textContent = v.sizeLabel;
        }
        if ($priceBox) {
            var newP = v.newPrice > 0 ? v.newPrice : v.oldPrice;
            var oldP = v.oldPrice;
            var html = "<span class=\"mb-pd-price-current\">" + formatPrice(newP) + " " + CUR + "</span>";
            if (v.newPrice > 0 && oldP > newP) {
                html += "<span class=\"mb-pd-price-old\">" + formatPrice(oldP) + " " + CUR + "</span>";
                var pct = Math.round((1 - newP / oldP) * 100);
                if (pct > 0) {
                    html += "<span class=\"mb-pd-badge-sale\">-" + pct + "%</span>";
                }
            }
            $priceBox.innerHTML = html;
        }
        var img = v.variantImg || mainImg;
        if (img) {
            var src = img;
            if (img.indexOf("http") !== 0) {
                if (img.indexOf("/") === 0) {
                    src = ctx + img;
                } else {
                    src = ctx + "/" + img.replace(/^\.\//, "");
                }
            }
            document.querySelectorAll("#product-main-img img, #product-imgs .product-preview img").forEach(function (el, idx) {
                if (idx === 0 || v.variantImg) {
                    el.src = src;
                }
            });
        }
    }

    function renderSizes(colorId) {
        if ($sizeSelect) {
            $sizeSelect.innerHTML = "";
        }
        if ($sizeOptions) {
            $sizeOptions.innerHTML = "";
        }
        var sizes = [];
        active.forEach(function (v) {
            if (v.colorOptionID === colorId) {
                var exists = sizes.some(function (s) {
                    return s.id === v.sizeOptionID;
                });
                if (!exists) {
                    sizes.push({
                        id: v.sizeOptionID,
                        label: v.sizeLabel || "Size",
                        qty: v.quantity || 0,
                    });
                }
            }
        });
        sizes.forEach(function (s, idx) {
            if ($sizeSelect) {
                var opt = document.createElement("option");
                opt.value = s.id;
                opt.textContent = s.label;
                $sizeSelect.appendChild(opt);
            }
            if ($sizeOptions) {
                var btn = document.createElement("button");
                btn.type = "button";
                btn.className = "mb-pd-size-btn" + (idx === 0 ? " active" : "");
                btn.textContent = s.label;
                btn.disabled = s.qty <= 0;
                btn.setAttribute("data-size-id", s.id);
                btn.addEventListener("click", function () {
                    if ($sizeSelect) {
                        $sizeSelect.value = s.id;
                    }
                    $sizeOptions.querySelectorAll(".mb-pd-size-btn").forEach(function (b) {
                        b.classList.toggle("active", b === btn);
                    });
                    applyVariant(findVariant(colorId, parseInt(s.id, 10)));
                });
                $sizeOptions.appendChild(btn);
            }
        });
        if (sizes.length) {
            if ($sizeSelect) {
                $sizeSelect.value = sizes[0].id;
            }
            applyVariant(findVariant(colorId, parseInt(sizes[0].id, 10)));
        }
    }

    function selectColor(colorId) {
        selectedColorId = colorId;
        var c = colorMap[colorId];
        if ($colorName && c) {
            $colorName.textContent = c.name;
        }
        if ($colorWrap) {
            $colorWrap.querySelectorAll(".mb-variant-swatch").forEach(function (btn) {
                btn.classList.toggle("active", parseInt(btn.getAttribute("data-color-id"), 10) === colorId);
            });
        }
        renderSizes(colorId);
    }

    if ($colorWrap) {
        colors.forEach(function (c, idx) {
            var btn = document.createElement("button");
            btn.type = "button";
            btn.className = "mb-variant-swatch mb-pd-swatch" + (idx === 0 ? " active" : "");
            btn.setAttribute("data-color-id", c.id);
            btn.title = c.name;
            var hex = c.hex;
            if (hex && hex.indexOf("#") !== 0) {
                hex = "#" + hex;
            }
            btn.style.backgroundColor = hex || "#ccc";
            btn.addEventListener("click", function () {
                selectColor(c.id);
            });
            $colorWrap.appendChild(btn);
        });
    }

    if ($sizeSelect) {
        $sizeSelect.addEventListener("change", function () {
            if (selectedColorId != null) {
                applyVariant(findVariant(selectedColorId, parseInt($sizeSelect.value, 10)));
            }
        });
    }

    var initial = active.find(function (v) {
        return v.ID === defaultId;
    }) || active[0];
    if (initial) {
        selectColor(initial.colorOptionID);
        if ($sizeSelect) {
            $sizeSelect.value = initial.sizeOptionID;
            applyVariant(initial);
        }
    } else if (colors.length) {
        selectColor(colors[0].id);
    }

    var form = document.querySelector("form[action*='cart/add']");
    if (form) {
        form.addEventListener("submit", function (e) {
            var vid = $variantInput ? $variantInput.value : "";
            if (!vid || parseInt(vid, 10) <= 0) {
                e.preventDefault();
                var msg = "Vui lòng chọn màu và size trước khi thêm vào giỏ.";
                if (typeof Swal !== "undefined") {
                    Swal.fire({
                        icon: "warning",
                        title: "Chọn biến thể",
                        text: msg,
                        confirmButtonColor: "#D10024",
                    });
                } else {
                    alert(msg);
                }
            }
        });
    }

    var params = new URLSearchParams(window.location.search);
    if (params.get("act") === "add-cart") {
        var st = params.get("status");
        var title = "Giỏ hàng";
        var text = "Không thể thêm vào giỏ.";
        var icon = "error";
        if (st === "1") {
            text = "Đã thêm vào giỏ hàng.";
            icon = "success";
        } else if (st === "2") {
            text = "Số lượng vượt tồn kho.";
            icon = "warning";
        }
        if (typeof Swal !== "undefined") {
            Swal.fire({ icon: icon, title: title, text: text, confirmButtonColor: "#D10024" });
        }
    }
})();
