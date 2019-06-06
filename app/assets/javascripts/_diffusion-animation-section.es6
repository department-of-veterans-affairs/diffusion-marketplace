(($) => {
    const $document = $(document);

    function homePageDiffusionAnimation() {
        const $section = $('#diffusion-animation-section');

        for (let i = 1; i < 22; i++) {
            const id = `pulsating-circle-${i}`;
            $section.append(`<div class="pulsating-circle ${id}" id="${id}"></div>`);
        }
    }

    $document.on('turbolinks:load', homePageDiffusionAnimation);
})(window.jQuery);