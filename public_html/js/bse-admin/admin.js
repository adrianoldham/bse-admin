//  We really need a proper loading script like scriptaculous

//document.write('<script type="text/javascript" src="/js/combo.packed.js"></script>');
document.write('<script type="text/javascript" src="/js/bse-admin/dropmenu.js"></script>');
document.write('<script type="text/javascript" src="/js/bse-admin/opendetails.js"></script>');

// wait for DOM to load before initialising

document.observe("dom:loaded", dom_init);
//Event.observe(window, "load", window_init);

function dom_init() {

    var message = $('message');
    
    if (message != undefined) {
        new Effect.Pulsate(message, {
            delay: 2
        });
    
        message.observe('click', function() {
            new Effect.SlideUp(this);
       });
    };

    var menu = new DropMenu('#nav li', {
        showLeft: null,
        effects: {
            show: [ Effect.Appear ],
            hide: [ Effect.Fade ],
            showDuration: 0.1,
            hideDuration: 0.5,
            transition: Effect.Transitions.linear
        },
        showDelay: 0.2,
        hideDelay: 0.5,
        osMode: true,
        rootItems: '#nav > li'
    });

    var openDetails = OpenDetails();
};

function window_init() {
};