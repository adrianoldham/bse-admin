var FormMonitorElements;

var FormMonitor = Class.create({
    initialize: function(options) {
        this.invalid_count = 0;
        this.changes = 0;
        this._make_handlers();
        this.options = Object.extend(this.defaults(), options || {});
        this._form = $(this.options.form);
        this._elements = {};
        this._first = null;
        this._focus = null;
        this._form.select(this.options.inputs).map(function(element) {
            var handler = this.options.typemap[element.type] || this.options.typemap["default"];
            var data = {
                element: element,
                changed: false,
                handler: handler
            };
            handler.start(data, this);
            element.observe("focus", this.onfocus);
            element.observe("blur", this.onblur);
            element.observe("change", this.onchange);
            data.valid = handler.valid(data);
            if (!data.valid) {
                ++this.invalid_count;
            }
            if (data.changed) {
                ++this.changes;
            }
            if (!this._first) {
                this._first = element;
            }
            if (element.autofocus) {
                this._focus = element;
            }

            return data;
        }.bind(this)).each(function(data) {
            this._elements[data.element.identify()] = data;
        }.bind(this));

        this._submits = this._form.select(this.options.submits);
        if (this.options.onsubmit != null) {
            this._form.observe("submit", this.onsubmit);
        }
        if (!this._focus && this._first) {
            this._focus = this._first;
        }
        if (this._focus) {
            var ev = {
                target: this._focus
            }; // cheat
            this.onfocus(ev);
        }
        this.options.onformchange(this);
    },
    defaults: function() {
        return Object.extend({}, {
            inputs: "input:not([type=hidden]), select, textarea",
            submits: "input[type=submit]",
            typemap: FormMonitorElements,
            onchanged: null,
            onsubmit: null
        });
    },
    _make_handlers: function() {
        this.onfocus = function(ev) {
            this._focus = ev.target;
            var entry = this._elements[ev.target.identify()];
            entry.handler.onfocus(entry, this);
        }.bind(this);
        this.onblur = function(ev) {
            var entry = this._elements[ev.target.identify()];
            entry.handler.onfocus(entry, this);
        }.bind(this);
        this.onchange = function(ev) {
            // handles anything that might cause a change
            var entry = this._elements[ev.target.identify()];
            var new_changed = entry.handler.changed(entry);
            var old_changes = this.changes;
            if (new_changed && !entry.changed) {
                ++this.changes;
            } else if (!new_changed && entry.changed) {
                --this.changes;
            }
            entry.changed = new_changed;
            var new_valid = entry.handler.valid(entry);
            var old_invalid_count = this.invalid_count;
            if (new_valid && !entry.valid) {
                --this.invalid_count;
            } else if (!new_valid && entry.valid) {
                ++this.invalid_count;
            }
            entry.valid = new_valid;
            var changed = old_changes == 0 && this.changes != 0 || old_changes != 0 && this.changes == 0;
            var valid_change = old_invalid_count == 0 && this.invalid_count != 0 || old_invalid_count != 0 && this.invalid_count == 0;
            if (this.options.onformchange != null && (changed || valid_change)) {
                this.options.onformchange(this);
            }
        }.bind(this);
        this.onsubmit = function(ev) {
            this.options.onsubmit(ev, this);
        }.bind(this);
        this.onleave = function(ev) {
            this.options.onsubmit(ev, this);
        }.bind(this);
    },
    form: function() {
        return this._form;
    },
    submits: function() {
        return this._submits;
    },
    changed: function() {
        return this.changes != 0;
    },
    valid: function() {
        return this.invalid_count == 0;
    }
});

FormMonitor.Element = {};
FormMonitor.Element.Base = Class.create({
    valid: function(data) {
        return true;
    }
});

FormMonitor.Element.Value = Class.create(FormMonitor.Element.Base, {
    start: function(data, monitor) {
        data.value = data.element.defaultValue;
        data.changed = data.element.value != data.value;
    },
    changed: function(data) {
        return data.value != data.element.value;
    },
    valid: function(data) {
        return !data.element.required || data.element.value != "";
    },
    onfocus: function(data, monitor) {
        data.element.observe("keyup", monitor.onchange);
    },
    onblur: function(data, monitor) {
        data.element.stopObserving("keyup", monitor.onchange);
    },
});

FormMonitor.Element.Button = Class.create(FormMonitor.Element.Base, {
    start: function(data, monitor) {
        data.element.observe("click", monitor.onchange);
        data.checked = data.element.defaultChecked;
    },
    changed: function(data) {
        return data.checked != data.element.checked;
    },
    valid: function(data) {
        return !data.element.required || data.element.checked;
    },
    onfocus: function() {},
    onblur: function() {}
});

FormMonitor.Element.SelectOne = Class.create(FormMonitor.Element.Base, {
    start: function(data, monitor) {
        data.element.observe("click", monitor.onchange);
        data.selection = data.element.selectedIndex;
    },
    changed: function(data) {
        return data.selection != data.element.selectedIndex;
    },
    valid: function(data) {
        return !data.element.required || data.element.value != "";
    },
    onfocus: function(data, monitor) {
        data.element.observe("keyup", monitor.onchange);
    },
    onblur: function(data, monitor) {
        data.element.stopObserving("keyup", monitor.onchange);
    }
});

FormMonitor.Element.SelectMultiple = Class.create(FormMonitor.Element.Base, {
    start: function(data, monitor) {
        data.element.observe("click", monitor.onchange);
        data.selection = data.element.getValue();
    },
    changed: function(data) {
        var new_value = data.element.getValue();
        if (data.selection.length != new_value.length) {
            return true;
        }

        for (var i = 0; i < new_value.length; ++i) {
            if (new_value[i] != data.selection[i]) {
                return true;
            }
        }
        return false;
    },
    onfocus: function(data, monitor) {},
    onblur: function(data, monitor) {}
});

FormMonitorElements = (function() {
    var button = new FormMonitor.Element.Button();
    return {
        "default": new FormMonitor.Element.Value(),
        checkbox: button,
        radio: button,
        "select-one": new FormMonitor.Element.SelectOne(),
        "select-multiple": new FormMonitor.Element.SelectMultiple()
    };
})();

var FormsMonitor = Class.create({
    initialize: function(options) {
        this.options = Object.extend(this.defaults(), options || {});
        this._forms = $$(this.options.forms).map(function(form) {
            return new this.options.formClass(Object.extend({
                form: form
            }, this.options));
        }.bind(this));
    },
    forms: function() {
        return this._forms;
    },
    defaults: function() {
        return Object.extend({}, {
            forms: "form",
            formClass: FormMonitor
        });
    }
});

var FormChangeMonitor = Class.create(FormMonitor, {
    initialize: function($super, options) {
        options = Object.extend(this.defaults(), options || {});
        $super(options);
    },
    defaults: function($super) {
        return Object.extend($super(), {
            onformchange: function(monitor) {
                if (monitor.changed() && monitor.valid()) {
                    monitor.submits().each(function(submit) {
                        submit.enable();
                    });
                } else {
                    monitor.submits().each(function(submit) {
                        submit.disable();
                    });
                }
            }
        });
    }
});

var ChangesMonitor = Class.create({
    initialize: function(options) {
        this.options = Object.extend(this.defaults(), options);
        this.monitor = new FormsMonitor(this.options);
        if (this.options.links) {
            var handler = this._onleave.bind(this);
            var links = $$(this.options.links);
            links.invoke('observe', 'click', handler);
        }
    },
    _onleave: function(ev) {
        // find the first form with unsaved changes
        var found;
        var forms = this.monitor.forms();
        for (var i = 0; i < forms.length && found == null; ++i) {
            if (forms[i].changed()) {
                found = forms[i];
            }
        }
        var confirm = found.form().getAttribute("data-confirm") != "false";
        if (found && confirm) {
            ev.stop();
            this.prompt(found, ev.element());
        }
    },
    prompt: function(form, link) {
        var ele = $(this.options.prompt);
        this.options.replace.each(function(name) {
            var attr = "data-" + name;
            var val = form.form().getAttribute(attr);
            if (val) {
                ele.select("[" + attr + "]").invoke('update', val);
            }
        });
        var save = $(this.options.saveButton);
        var cancel = $(this.options.cancelButton);
        var dontsave = $(this.options.dontSaveButton);
        var page = $$(this.options.pageElement)[0];

        // avoid recursing in
        save.stopObserving('click');
        cancel.stopObserving('click');
        dontsave.stopObserving('click');

        if (form.valid()) {
            save.removeClassName("disabled");
            save.observe('click', function() {
                var submits = form.submits();
                if (submits.length == 1) {
                    submits[0].click();
                } else {
                    form.form().submit();
                }
            }.bind(this));
        } else {
            save.addClassName("disabled");
        }

        cancel.observe('click', function(ev) {
            ev.stop();
            ele.hide();
            save.stopObserving('click');
            cancel.stopObserving('click');
        }.bind(this));

        dontsave.href = link.href;
        ele.setStyle({
            display: "block"
        });

        this.options.onPrompt();
        page.scrollTo();
    },
    defaults: function() {
        return {
            formClass: FormChangeMonitor,
            links: 'a[href]:not([data-action]):not([href="#"])',
            prompt: 'sheet',
            replace: ["object", "confirm", "info"],
            dontSaveButton: 'unsavedDont',
            cancelButton: 'unsavedCancel',
            saveButton: 'unsavedSave',
            pageElement: 'body',
            onPrompt: function() {}
        };
    }
});