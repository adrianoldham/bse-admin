var LinkConfirmer = Class.create({
    initialize: function(options) {
        this.options = Object.extend(this.defaults(), options || {});
        var handler = this.prompt.bind(this);
        var links = $$(this.options.links);
        links.invoke('observe', 'click', handler);
    },
    prompt: function(ev) {
        var link = ev.findElement();
        var ele = $(this.options.prompt);
        this.options.replace.each(function(name) {
            var attr = "data-" + name;
            var val = link.getAttribute(attr);
            if (val) {
                ele.select("[" + attr + "]").invoke('update', val);
            }
        });
        var confirm = $(this.options.confirmButton);
        confirm.href = link.href;
        confirm.target = link.target;
        confirm.stopObserving('click');
        var cancel = $(this.options.cancelButton)
        cancel.stopObserving('click');
        cancel.observe('click', function(event) {
            event.stop();
            ele.hide();
            event.element().stopObserving('click');
        });
        ev.stop();
        ele.setStyle({
            display: "block"
        });
        this.options.onPrompt();
    },
    defaults: function() {
        return {
            links: 'a[href][data-object][data-action]:not([href="#"])',
            prompt: 'modal',
            replace: ["object", "confirm", "info", "action"],
            confirmButton: 'confirmDelete',
            cancelButton: 'confirmCancel',
            onPrompt: function() {}
        };
    }
});