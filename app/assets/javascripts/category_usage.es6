function updateSelectedCategoriesUsage({sQuery=null, chosenCategories=null, category_id=null}){
    Rails.ajax({
        type: 'patch',
        url: "/update_category_usage",
        data: jQuery.param({query: sQuery, chosenCategories: chosenCategories, catId: category_id })
    });
}