var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

Jetdeck.Views.Specs = {};

Jetdeck.Views.Specs.Send = (function(_super) {

  __extends(Send, _super);

  function Send() {
    this.send = __bind(this.send, this);
    this.render = __bind(this.render, this);
    this.initialize = __bind(this.initialize, this);
    this.setupEmailFields = __bind(this.setupEmailFields, this);
    this.clearEmailFields = __bind(this.clearEmailFields, this);
    this.validateForm = __bind(this.validateForm, this);
    this.showPhotosLink = __bind(this.showPhotosLink, this);
    this.specSelected = __bind(this.specSelected, this);
    this.clearSpecSelected = __bind(this.clearSpecSelected, this);
    this.setupSpecField = __bind(this.setupSpecField, this);
    this.airframeSelected = __bind(this.airframeSelected, this);
    this.reset = __bind(this.reset, this);
    this.setupAircraftField = __bind(this.setupAircraftField, this);
    this.setupToField = __bind(this.setupToField, this);
    Send.__super__.constructor.apply(this, arguments);
  }

  Send.prototype.template = JST["templates/specs/send"];

  Send.prototype.setupToField = function() {
    var _this = this;
    return this.$('#email').autocomplete({
      minLength: 2,
      autofocus: true,
      focus: function(event, ui) {
        if (ui.item.value) $("#email").val(ui.item.value);
        return event.preventDefault();
      },
      select: function(event, ui) {
        if (ui.item.value) $("#email").val(ui.item.value);
        if (ui.item.label !== ui.item.value) _this.recipient = ui.item.label;
        return _this.setupEmailFields();
      },
      source: "/contacts/search"
    }).data("uiAutocomplete")._renderItem = function(ul, item) {
      ul.addClass("dropdown-menu");
      ul.addClass("typeahead");
      return $("<li class=\"result\" style=\"cursor: pointer\"></li>").data("item.autocomplete", item).append("<a><strong>" + item.label + "</strong></a>").appendTo(ul);
    };
  };

  Send.prototype.setupAircraftField = function() {
    var ac_collection_data,
      _this = this;
    ac_collection_data = this.aircraft_collection.reduce(function(a, b) {
      return a.concat({
        id: b.get('id'),
        text: b.get('long'),
        airframe: b
      });
    }, []);
    return this.$("#airframe").ready(function() {
      _this.$("#airframe").select2({
        placeholder: "Select Aircraft",
        data: ac_collection_data,
        initSelection: function(element, callback) {
          var airframe, data, id, text;
          id = parseInt(element.val());
          airframe = _this.aircraft_collection.where({
            id: id
          })[0];
          if (airframe != null) {
            text = airframe.get('long');
          } else {
            text = "Select Aircraft";
            $("#airframe").select2("val", null);
          }
          data = {
            id: id,
            text: text,
            airframe: airframe
          };
          return callback(data);
        }
      });
      _this.$(".airframe").css('width', '380px');
      _this.$("#airframe").on("select2-selecting", function(val) {
        return _this.airframeSelected(val.object.airframe);
      });
      if (_this.options && _this.options.airframe) {
        _this.$("#airframe").select2("val", _this.options.airframe.get("id"));
        return _this.airframeSelected(_this.options.airframe);
      }
    });
  };

  Send.prototype.reset = function() {
    this.$("#error-message").html("");
    this.validateForm();
    this.clearSpecSelected();
    this.$("#nospecs").hide();
    this.$("label[for='include-photos']").hide();
    this.$("#spec").val(null);
    if (this.$("#spec").data("select2")) this.$("#spec").data("select2").destroy();
    return this.clearEmailFields();
  };

  Send.prototype.airframeSelected = function(val) {
    var _this = this;
    this.reset();
    this.airframe = val;
    return this.airframe.fetch({
      success: function() {
        _this.airframe.updateChildren();
        _this.setupEmailFields();
        if (_this.airframe.specs.length > 0) {
          _this.setupSpecField(_this.airframe);
          if (_this.airframe.get('avatar')) {
            _this.$("label[for='include-photos']").show();
            $("#attachment-photos-link").show();
          }
        } else {
          _this.$("#nospecs").show();
        }
        return _this.validateForm();
      }
    });
  };

  Send.prototype.setupSpecField = function(airframe) {
    var data,
      _this = this;
    data = airframe.specs.reduce(function(a, b) {
      return a.concat({
        id: b.get('id'),
        spec: b,
        text: b.get('file_name').trunc(40)
      });
    }, []);
    this.$("#spec").select2({
      placeholder: "Select Spec File",
      data: data,
      initSelection: function(element, callback) {
        var id, spec, text;
        id = parseInt(element.val());
        spec = airframe.specs.where({
          id: id
        })[0];
        if (spec != null) {
          text = spec.get('file_name').trunc(40);
        } else {
          text = "Select Spec File";
          $("#spec").select2("val", null);
        }
        data = {
          id: id,
          text: text,
          spec: spec
        };
        return callback(data);
      }
    });
    this.$("#spec").on("select2-selecting", function(val) {
      return _this.specSelected(val.object.spec);
    });
    if (this.useDefaultSpec && this.options && this.options.spec) {
      this.useDefaultSpec = false;
      this.$("#spec").select2("val", this.options.spec.get("id"));
      return this.specSelected(this.options.spec);
    }
  };

  Send.prototype.clearSpecSelected = function(val) {
    this.$("#attachment-filename").removeClass("selected");
    this.$("#attachment-filename").html("Select a Spec File to Send <i class='icon-circle-arrow-up'></i>");
    this.$("#attachment-icon").hide();
    return $("#attachment-photos-link").hide();
  };

  Send.prototype.specSelected = function(val) {
    this.$("#attachment-filename").addClass("selected");
    this.$("#attachment-filename").html(val.get('file_name').rtrunc(38));
    this.$("#attachment-icon").show();
    this.setupEmailFields();
    this.showPhotosLink();
    return this.validateForm();
  };

  Send.prototype.showPhotosLink = function() {
    if ($("label[for='include-photos'] input").is(":visible") && $("label[for='include-photos'] input").is(":checked")) {
      return $("#attachment-photos-link").show();
    } else {
      return $("#attachment-photos-link").hide();
    }
  };

  Send.prototype.validateForm = function() {
    if (this.$("#spec").val() !== "" && this.$("#email").val() !== "") {
      return this.$("#send").removeAttr("disabled");
    } else {
      return this.$("#send").attr("disabled", "disabled");
    }
  };

  Send.prototype.clearEmailFields = function() {
    if (!this.touchedBody) this.$("#message-body").val("");
    if (!this.touchedSubject) return this.$("#message-subject").val("");
  };

  Send.prototype.setupEmailFields = function() {
    var message, subject;
    subject = "";
    if (this.airframe && (this.airframe.get('long') != null)) {
      subject += "" + (this.airframe.get('long'));
    }
    if (!this.touchedSubject) this.$("#message-subject").val(subject);
    message = "";
    if (this.recipient != null) message += "" + this.recipient + ",<br><br>";
    if (this.airframe && (this.airframe.get('to_s') != null)) {
      message += "Please review the attached document regarding the " + (this.airframe.get('to_s')) + ". Thank you,<br><br>";
    }
    if (message === "") message = "<br><br><br>";
    if (this.signature != null) message += this.signature;
    if (!this.touchedBody) return this.$("#message-body").html(message);
  };

  Send.prototype.initialize = function() {
    this.useDefaultSpec = true;
    this.airframe = null;
    this.recipient = null;
    this.touchedSubject = false;
    this.touchedBody = false;
    this.aircraft_collection = new Jetdeck.Collections.AirframesCollection();
    this.aircraft_collection.reset(window.data.airframe_index);
    return this.signature = window.data.signature;
  };

  Send.prototype.render = function() {
    var _this = this;
    $(this.el).html(this.template());
    $(function() {
      _this.setupToField();
      _this.setupAircraftField();
      _this.setupEmailFields();
      _this.$("#message-body").on("keyup", function() {
        return _this.touchedBody = true;
      });
      _this.$("#message-subject").on("keyup", function() {
        return _this.touchedSubject = true;
      });
      _this.$("#spec").on("change", function() {
        return _this.validateForm();
      });
      _this.$("#email").on("change keyup", function() {
        return _this.validateForm();
      });
      _this.$("label[for='include-photos'] input").on("change", function() {
        return _this.showPhotosLink();
      });
      return _this.$("#send").on("click", function() {
        return _this.send();
      });
    });
    this.message = new Jetdeck.Models.AirframeMessageModel();
    this.$("form").backboneLink(this.message);
    return this;
  };

  Send.prototype.send = function() {
    var messages_collection,
      _this = this;
    this.$("#send").button('loading');
    this.message.set({
      "recipient_email": this.$("#email").val(),
      "airframe_id": this.$("#airframe").val(),
      "airframe_spec_id": this.$("#spec").val(),
      "subject": this.$("#message-subject").val(),
      "body": this.$("#message-body").html(),
      "include_photos": this.$("#include-photos").is(":checked") && this.$("#include-photos").is(":visible")
    });
    messages_collection = new Jetdeck.Collections.AirframeMessagesCollection();
    messages_collection.create(this.message, {
      success: function() {
        mixpanel.track("Sent Spec", {
          to: _this.$("#email").val()
        });
        _this.$("#send").button('reset');
        return window.modalClose();
      },
      error: function(o, response) {
        var errors;
        errors = $.parseJSON(response.responseText);
        _this.$("#error-message").html(errors[0]);
        return _this.$("#send").button('reset');
      }
    });
    return this;
  };

  return Send;

})(Backbone.View);
