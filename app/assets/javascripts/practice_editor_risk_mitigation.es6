(($) => {
    const $document = $(document);

    function createUniqueRiskMitiId() {
        var d = new Date().getTime();//Timestamp
        var d2 = (performance && performance.now && (performance.now() * 1000)) || 0;//Time in microseconds since page-load or 0 if unsupported
        return 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
            var r = Math.random() * 16;//random number between 0 and 16
            if (d > 0) {//Use timestamp until depleted
                r = (d + r) % 16 | 0;
                d = Math.floor(d / 16);
            } else {//Use microseconds since page-load if supported
                r = (d2 + r) % 16 | 0;
                d2 = Math.floor(d2 / 16);
            }
            return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
        });
    }

    function hideAddLinksAndShowRiskMitiFields() {
        $('.add-risk-mitigation-link').on('click', () => {
            let addBtnExists = $('#dm-add-button-risk-mitigation').length > 0;

            // change add button display
            if (addBtnExists) {
                $('#dm-add-button-risk-mitigation').addClass('display-none');
                $('#dm-add-link-risk-mitigation').removeClass('display-none');
            }

            $document.arrive('.fields', (newElement) => {
                // add separator to previous element if another risk mitigation exists
                $(newElement).appendTo('#sortable_risk_mitigations');
                initSortable('#sortable_risk_mitigations');
                let multipleRiskMitigationExists = $('.practice-editor-risk-mitigation-li').length >= 1
                if (multipleRiskMitigationExists) {
                    let separator = '<div class="grid-col-11 border-y-1px border-gray-5 add-another-separator margin-y-2"></div>'
                    $(newElement).prev().append(separator)
                }

                // add delete entry event handler
                let $deleteEntry = $(newElement).find('.risk-mitigation-trash')
                attachDeleteEntryHandler($deleteEntry)

                const riskUuid = createUniqueRiskMitiId();
                const mitiUuid = createUniqueRiskMitiId();
                const riskMitiId = newElement.firstElementChild.name.split('[')[2].replace(']', '');
                $(newElement).find('div.risk-container').prepend(`
                                <input type="hidden" name="practice[risk_mitigations_attributes][${riskMitiId}][risks_attributes][0][id]" id="practice_risk_mitigations_attributes_${riskMitiId}_risks_attributes_0_id">
                                <div class="risk_container grid-col-11">
                                    <label class="usa-label display-inline-block risk-description" for="practice_risk_mitigations_attributes_${riskMitiId}_description"> Description of the risk</label>
                                    <input class="usa-input practice-input risk-description-textarea risk_0_description_textarea" type="text" id="practice_risk_mitigations_attributes_${riskMitiId}_description" name="practice[risk_mitigations_attributes][${riskMitiId}][risks_attributes][0][description]">
                                </div>
                    `);

                    let mitigationContainer = `
                            <input type="hidden" name="practice[risk_mitigations_attributes][${riskMitiId}][mitigations_attributes][0][id]" id="practice_risk_mitigations_attributes_${riskMitiId}_mitigations_attributes_0_id">
                            <div class="mitigation_container">
                                <label class="usa-label grid-col-11 font-sans-sm margin-top-2" for="practice_risk_mitigations_attributes_${riskMitiId}_mitigations_attributes_0_description">Corresponding mitigation</label>
                                <textarea class="usa-input practice-input mitigation-description-textarea height-15" id="practice_risk_mitigations_attributes_${riskMitiId}_mitigations_attributes_0_description" name="practice[risk_mitigations_attributes][${riskMitiId}][mitigations_attributes][0][description]"></textarea>
                            </div>
                    `;
                    $(newElement).find('.mitigation-container').append(mitigationContainer)

                $document.unbindArrive('.fields');
            })
        });
    }

    function dragAndDropRiskMitigationListItems() {
        initSortable('#sortable_risk_mitigations');

        if (typeof sortable('#sortable_risk_mitigations')[0] != 'undefined') {
            sortable('#sortable_risk_mitigations')[0].addEventListener('sortstart', function (e) {
                console.log('starting sort', e)
            });

            sortable('#sortable_risk_mitigations')[0].addEventListener('sortupdate', function (e) {
                $(this).children('li').map(function (index) {
                    $(this).find('.risk-mitigation-position').val(index + 1)
                    return "risk_mitigations[]=" + $(this).data("id");
                }).get().join("&");
                // Rails.ajax({
                //     url: $(this).data("url"),
                //     type: "PATCH",
                //     data: dataIDList,
                // });
            });
        }
    }

    function attachDeleteEntryHandler(elem) {
        $(elem).on('click', (e) => {
            let $previousLi = $(e.target).closest('.practice-editor-risk-mitigation-li').filter(":visible").prev('.practice-editor-risk-mitigation-li').filter(":visible");

            let $afterLi = $(e.target).closest('.practice-editor-risk-mitigation-li').filter(":visible").next('.practice-editor-risk-mitigation-li').filter(":visible");

            let $allLi = $('.practice-editor-risk-mitigation-li').filter(":visible")

            // remove previous element separator if there is no element after the one being deleted
            if ($previousLi.length > 0 && $afterLi.length === 0) {
                $previousLi.find('.add-another-separator').filter(":visible").remove();
            }

            // if there are no more <li> elements display the add button
            if ($allLi.length <= 1) {
                $('#dm-add-button-risk-mitigation').removeClass('display-none');
                $('#dm-add-link-risk-mitigation').addClass('display-none');
            }
        })
    }

    function loadPracticeEditorRiskMitiFunctions() {
        hideAddLinksAndShowRiskMitiFields();
        createUniqueRiskMitiId();
        attachDeleteEntryHandler('.risk-mitigation-trash');
        // dragAndDropRiskMitigationListItems();
    }

    $document.on('turbolinks:load', loadPracticeEditorRiskMitiFunctions);
})(window.jQuery);
