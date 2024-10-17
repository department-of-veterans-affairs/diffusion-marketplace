document.addEventListener("turbolinks:load", () => {
  function observePartnerFieldArrival() {
    $(document).arrive('[id^="product_practice_partner_practices_attributes_"][id$="_practice_partner_id"]', function(newElem) {
        const $li = $(newElem).closest('li');
        const pppIndex = $(newElem).attr('id').match(/\d+/)[0]; // Extract the numeric index from the id
        styleOriginFacility($li, pppIndex, ".dm-practice-editor-practice-partner-li", ".dm-practice-editor-practice-partner-ul", "12");

        const destroyInput = $li.find('.trash-container input[name="product[_destroy]"]');

        destroyInput.attr("name", `product[practice_partner_practices_attributes][${pppIndex}][_destroy]`);
        destroyInput.attr("id", `product_practice_partner_practices_attributes_${pppIndex}__destroy`);

        $(document).unbindArrive(newElem);
    });
  }

  function setupBlueprintObserver() {
    $(document).arrive("#practice_partner_practices_fields_blueprint", function(blueprint) {

      let blueprintText = $(blueprint).data("blueprint");
      blueprintText = blueprintText.replace("product[_destroy]", "product[practice_partner_practices_attributes][new_practice_partner_practices][_destroy]");
      blueprintText = blueprintText.replace("product__destroy", "product_practice_partner_practices_attributes_new_practice_partner_practices__destroy");
      $(blueprint).data("blueprint", blueprintText);
      $(document).unbindArrive(blueprint);
    });
  }

  function attachListeners() {
    observePartnerFieldArrival();
    setupBlueprintObserver();

    if ($(".dm-practice-editor-practice-partner-li").length === 0) {
      $("#link_to_add_link_practice_partner_practices").click();
    }

    attachTrashListener(
      $(document),
      "#dm-practice-partner-container",
      ".dm-practice-editor-practice-partner-li"
    );
  }

  attachListeners();
});
