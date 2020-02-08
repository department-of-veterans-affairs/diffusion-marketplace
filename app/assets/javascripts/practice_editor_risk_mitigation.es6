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
            $document.arrive('.fields', (newElement) => {
                $(newElement).appendTo('#sortable_risk_mitigations');
                initSortable('#sortable_risk_mitigations');
                const riskUuid = createUniqueRiskMitiId();
                const mitiUuid = createUniqueRiskMitiId();
                const riskMitiId = newElement.firstElementChild.name.split('[')[2].replace(']', '');
                $(newElement).find('div.padding-205.border.border-width-1px.border-base-lighter.radius-sm.margin-top-3').prepend(`
                        <div class="position-relative">
                            <div class="fas fa-arrows-alt font-sans-lg position-arrows risk-miti-arrows text-base arrows-tooltip">
                                <span class="usa-tag tooltip-text">Drag and drop to change order</span>
                            </div>
                        </div>
                        <div class="grid-row width-full">
                            <div class="grid-col-11">
                                <input type="hidden" name="practice[risk_mitigations_attributes][${riskMitiId}][risks_attributes][0][id]" id="practice_risk_mitigations_attributes_${riskMitiId}_risks_attributes_0_id">
                                <div class="risk_container">
                                    <label class="usa-label text-bold display-inline-block risk-description" for="practice_risk_mitigations_attributes_${riskMitiId}_description">Risk:</label>&nbsp;<span>Type the name or description of the risk.</span>&nbsp;<span class="text-base-light risk-character-count risk_0_character_count" id="risk_${riskMitiId}_character_count">(0/150 characters)</span>
                                    <textarea class="usa-input practice-input risk-description-textarea height-15 risk_0_description_textarea" id="practice_risk_mitigations_attributes_${riskMitiId}_description" name="practice[risk_mitigations_attributes][${riskMitiId}][risks_attributes][0][description]"></textarea>
                                </div>
                            </div>
                        </div>
                    `);

                    let mitigationContainer = `
                        <div class="grid-col-11">
                            <input type="hidden" name="practice[risk_mitigations_attributes][${riskMitiId}][mitigations_attributes][0][id]" id="practice_risk_mitigations_attributes_${riskMitiId}_mitigations_attributes_0_id">
                            <div class="mitigation_container">
                                <label class="usa-label text-bold display-inline-block" for="practice_risk_mitigations_attributes_${riskMitiId}_mitigations_attributes_0_description">Mitigation:</label>&nbsp;<span>Type the corresponding mitigation to the risk.</span>&nbsp;<span class="text-base-light mitigation-character-count" id="mitigation_${riskMitiId}_character_count">(0/150 characters)</span>
                                <textarea class="usa-input practice-input mitigation-description-textarea height-15" id="practice_risk_mitigations_attributes_${riskMitiId}_mitigations_attributes_0_description" name="practice[risk_mitigations_attributes][${riskMitiId}][mitigations_attributes][0][description]"></textarea>
                            </div>
                        </div>
                    `;

                    $(newElement).find('.risk-miti-trash-container').before(mitigationContainer);

                $document.unbindArrive('.fields');
            })
        });
    }

    function removeBulletPointFromNewLi() {
        $document.arrive('.practice-editor-risk-mitigation-li', (newElem) => {
            $(newElem).css('list-style', 'none');
            $(newElem).appendTo('#sortable_risk_mitigations');
            initSortable('#sortable_risk_mitigations');
            $document.unbindArrive('.practice-editor-risk-mitigation-li', newElem);
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

    function loadPracticeEditorRiskMitiFunctions() {
        hideAddLinksAndShowRiskMitiFields();
        createUniqueRiskMitiId();
        removeBulletPointFromNewLi();
        dragAndDropRiskMitigationListItems();
    }

    $document.on('turbolinks:load', loadPracticeEditorRiskMitiFunctions);
})(window.jQuery);