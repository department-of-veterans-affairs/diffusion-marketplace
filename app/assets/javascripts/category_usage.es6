function updateSelectedCategoriesUsage(sQuery, chosenCategories, category_id){
    Rails.ajax({
        type: 'patch',
        url: "/update_category_usage",
        data: jQuery.param({query: sQuery, chosenCategories: chosenCategories, catId: category_id })
    });
}