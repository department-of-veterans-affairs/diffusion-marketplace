(($) => {
    const $document = $(document);

    function homePageDiffusionAnimation() {
        console.log('hello');
        const $section = $('#diffusion-animation-section');
        // create 21 circles within .diffusion-animation-section
        // random size
        // random opacity
        // random placement within the section

        for (let i = 1; i < 22; i++) {
            // const randomLeft = Math.floor(Math.random() * 100);
            // const randomTop = Math.floor(Math.random() * 100);
            // const randomSize = Math.floor(Math.random() * 80 + 5);
            // const randomOpacity = Math.floor(Math.random());
            // const randomDelay = Math.floor(Math.random() * 4);

            const id = `pulsating-circle-${i}`;
            $section.append(`<div class="pulsating-circle ${id}" id="${id}"></div>`);
            // $(`#${id}`).css({
            //     width: `${randomSize}px`,
            //     height: `${randomSize}px`,
            //     top: `${randomTop}%`,
            //     left: `${randomLeft}%`
            // });
            //
            // $(`#${id}:before`).addRule(
            //     `background-color: rgba(0, 150, 246, ${randomOpacity})`
            // );

        }
    }

    $document.on('turbolinks:load', homePageDiffusionAnimation);
})(window.jQuery);