(($) => {
    const $document = $(document);

    function loadCircleBackgrounds() {
        backgroundCircles();
        backgroundTranslucentCircles();
    }

    function backgroundCircles() {
        const $section = $('.diffusion-background-circles');

        for (let i = 1; i < 22; i++) {
            const id = `background-circle-${i}`;
            $section.append(`<div class="${id}" id="${id}"></div>`);
        }
    }

    function backgroundTranslucentCircles() {
        const $section = $('.diffusion-background-circles-offset-translucent');

        for (let i = 1; i < 22; i++) {
            const id = `background-circle-offset-translucent-${i}`;
            $section.append(`<div class="${id}" id="${id}"></div>`);
        }
    }

    $document.on('turbolinks:load', loadCircleBackgrounds);
})(window.jQuery);