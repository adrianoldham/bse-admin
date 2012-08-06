//  We really need a proper loading script like scriptaculous

document.write('<script type="text/javascript" src="/bse-admin/js/dropmenu.js"></script>');
document.write('<script type="text/javascript" src="/bse-admin/js/opendetails.js"></script>');
document.write('<script type="text/javascript" src="/bse-admin/js/formmonitor.js"></script>');
document.write('<script type="text/javascript" src="/bse-admin/js/linkconfirmer.js"></script>');

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

    var menu = new DropMenu('.menu li', {
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
        rootItems: '.menu > li',
        onShow: toggle_menu,
        onHide: toggle_menu
    });

    var openDetails = new OpenDetails();

    var sheetHtml = '\
    <div id="sheet">\
      <div class="window dialog modal sheet">\
        <h2 data-confirm>Would you like to save the changes to this <span data-object>Object</span>?</h2>\
        <p data-info>If you don‘t save, your changes will be lost.</p>\
        <p class="buttons">\
          <a href="#" class="button white left" id="unsavedDont">Don’t <span data-action>Save</span></a>\
          <a href="#" class="button white" id="unsavedCancel">Cancel</a>\
          <a href="#" class="button green" id="unsavedSave"><span data-action>Save</span> <span data-object>Object</span></a>\
        </p>\
      </div>\
    </div>';

    var confirmHtml = '\
    <div id="modal" class="lightbox">\
      <div class="window dialog modal">\
        <header>\
          <h1>Alert!</h1>\
        </header>\
        <h2 data-confirm>Are you sure you want to delete this <span data-object>Object</span>?</h2>\
        <p data-info>Continuing with this action will permanently remove this <span data-object>Object</span> from your site. This action cannot be undone.</p>\
        <p class="buttons">\
          <a href="#" id="confirmCancel" class="button white">Cancel</a>\
          <a href="#" id="confirmDelete" class="button red"><span data-action>Delete</span> <span data-object>Object</span></a>\
        </p>\
      </div>\
    </div>';

    $$("header").invoke('insert', { after: sheetHtml });
    $$("body").invoke('insert', { bottom: confirmHtml });

    var changesMonitor = new ChangesMonitor({ forms: 'form:[data-object]', onPrompt: hide_menu });
    var linkConfirmer = new LinkConfirmer({ onPrompt: hide_menu });
    
    if (/subs\.pl/.test(window.location.href)) {
        $$("a:not([target])").invoke('setAttribute', 'target', '_top');
    }

    if (has_svg_support()) {
        $$("html").invoke('addClassName', 'svg');
        $$("label > img[src$='png']").each(function(img) {
            var src = img.getAttribute('src').replace("png","svg");
            img.setAttribute('src', src).addClassName("error");
        });
    }

    setup_fullscreen_widgets();
    
};

function window_init() {
};

var fullscreenToggle, windowToggle;

function setup_fullscreen_widgets() {
    fullscreenToggle = new Element('div', {
        'data-widget': 'fullscreen'
    }).observe('click', toggle_fullscreen);

    $$("header > nav").invoke('insert', { top: fullscreenToggle });

    windowToggle = new Element('div', {
        'data-widget': 'window'
    }).observe('click', toggle_fullscreen).hide();

    $$("body > nav").invoke('insert', { top: windowToggle });
};

function toggle_fullscreen(event) {
    $$("[data-role=page], .window:not('.dialog')").invoke('toggleClassName', 'fullscreen');
    fullscreenToggle.toggle();
    windowToggle.toggle();
    
    hide_menu();
    event.stop();
};

function toggle_menu() {
    $$("[data-role=navbar]").invoke('toggleClassName', 'visible');
    hide_menu();
};

function hide_menu() {
    $$(".menu ul").invoke('hide');
    $$(".menu li.active").invoke('removeClassName','active');
};

function has_svg_support() {
    return document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1");
};