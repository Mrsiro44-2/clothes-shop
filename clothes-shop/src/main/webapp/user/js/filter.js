const filterProduct = (page) => {
    const idCategories = document.querySelectorAll(".category-filter");
    const idBrand = document.querySelectorAll(".brand-filter");
    const from = document.querySelector(".input-from-price").value;
    const to = document.querySelector(".input-to-price").value;
    const filterTime = document.querySelector('.sort-filter').value;
    let idCates = [];
    let idBrands = []
    for (let i = 0; i < idCategories.length; i++) {
        if (idCategories[i].checked) {
            idCates.push(idCategories[i].value);
        }
    }
    for (let i = 0; i < idBrand.length; i++) {
        if (idBrand[i].checked) {
            idBrands.push(idBrand[i].value);
        }
    }
    const data = {
        idCategory: idCates,
        idBrands: idBrands,
        from: from,
        to: to,
        time: filterTime
    };
    $.ajax({
        type: 'POST',
        url: '/MomAndBaby/filter',
        data: JSON.stringify(data),
        contentType: 'application/json',
        success: function (response) {
            $(page).html(response);
            let numberOfCart = document.querySelectorAll(".cart-filter");
            let spanShow =`<span>Showing ${numberOfCart.length} relults</span>`;
            $(".store-qty").html(spanShow);
        },
        error: function (xhr, status, error) {
            console.log('Lỗi: ' + error);
        }
    });
    document.querySelector(".store-pagination").style.display = "none";
};
