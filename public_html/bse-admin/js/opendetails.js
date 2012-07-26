var OpenDetails = Class.create({
    defaults: {
        selector: "summary",
        openClass: "open",
        disclosureWidgetClass: "disclosure-widget",
        disclosureEvent: "click"
    },

    initialize: function(selector, options) {
        var isSupported = 'open' in document.createElement('details');
        if (isSupported) return;

        this.options = Object.extend(Object.extend({}, this.defaults), options || {});
        this.selector = $$(selector ? selector : this.options.selector);
        this.selector.each(function(element) {
            this.setup(element);
        }.bind(this));
    },

    setup: function(element) {
        // Create a new container
        var container = new Element("div").hide();

        // Add siblings to the container
        var siblings = element.siblings();
        siblings.each(function(sibling) {
            container.insert({ bottom: sibling });
        });
        element.insert({ after: container });
        this.apply(element, container);
    },

    apply: function(element, container) {
        element.observe(this.options.disclosureEvent,
            this.toggle.bindAsEventListener(this, element, container)
        ).addClassName(this.options.disclosureWidgetClass);
    },

    toggle: function(event, element, container) {
        var parent = element.parentNode;
        var isOpen = parent.hasAttribute("open");
        if (isOpen) {
            parent.removeClassName(this.options.openClass).removeAttribute("open");
            container.hide();
        } else {
            parent.addClassName(this.options.openClass).writeAttribute("open", "true");
            container.show();
        }
    }
});