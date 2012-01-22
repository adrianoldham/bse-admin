//  We really need a proper loading script like scriptaculous

//document.write('<script type="text/javascript" src="/js/combo.packed.js"></script>');

// wait for DOM to load before initialising

document.observe("dom:loaded", dom_init);
//Event.observe(window, "load", window_init);

function dom_init() {

    if ($('message')) {
        new Effect.Pulsate($('message'), {
            delay: 2
        });
    }

};

function window_init() {
};