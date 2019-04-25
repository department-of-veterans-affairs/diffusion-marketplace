(($) => {
    const $document = $(document);

    function loadCircleBackgrounds() {
        backgroundCircles();
        backgroundTranslucentCircles();
        backgroundPromoTranslucentCircles();
        backgroundTranslucentBlueCircles();
    }

    function backgroundCircles() {
        const $section = $('.diffusion-background-circles');
        if ($section.children().length === 0) {
            for (let i = 1; i < 22; i++) {
                const id = `background-circle-${i}`;
                $section.append(`<div class="${id}" id="${id}"></div>`);
            }
        }
    }

    function backgroundTranslucentCircles() {
        const $section = $('.diffusion-background-circles-offset-translucent');
        if ($section.children().length === 0) {
            for (let i = 1; i < 13; i++) {
                const id = `background-circle-offset-translucent-${i}`;
                $section.append(`<div class="${id}" id="${id}"></div>`);
            }
        }
    }

    function backgroundPromoTranslucentCircles() {
        const $section = $('.diffusion-background-circles-promo-translucent');
        if ($section.children().length === 0) {
            for (let i = 1; i < 13; i++) {
                const id = `background-circle-promo-translucent-${i}`;
                $section.append(`<div class="${id}" id="${id}"></div>`);
            }
        }
    }

    function backgroundTranslucentBlueCircles() {
        const $section = $('.diffusion-background-circles-translucent-blue');

        if ($section.children().length === 0) {
            for (let i = 1; i < 13; i++) {
                const id = `background-circle-translucent-blue-${i}`;
                $section.append(`<div class="${id}" id="${id}"></div>`);
            }
        }
    }

    $document.on('turbolinks:load', loadCircleBackgrounds);
})(window.jQuery);