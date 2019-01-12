(($) => {
    const $document = $(document);

    function backgroundCircles() {
        const $section = $('.diffusion-background-circles');

        for (let i = 1; i < 22; i++) {
            const id = `background-circle-${i}`;
            $section.append(`<div class="${id}" id="${id}"></div>`);
        }
    }

    $document.on('turbolinks:load', backgroundCircles);
})(window.jQuery);