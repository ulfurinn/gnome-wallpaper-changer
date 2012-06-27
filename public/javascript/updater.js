var Updater =  { };

Updater.init = function() {
	this.wire_interval_field( $("#interval") );

	this.fetch_interval( $("#interval") );
};

Updater.wire_interval_field = function(input) {
	input.blur(function() {
		$.ajax({
			type: 'POST',
			url: '/interval',
			data: {interval: parseInt(input.val())}
		}).done(function(ret) {
			input.val(ret.interval);
			input.stop().css("background-color", "#55FF55").animate({ backgroundColor: $.Color("#FFFFFF")}, 500);
		});
	});
};

Updater.fetch_interval = function(input) {
	$.ajax({
		type: 'GET',
		url: '/interval'
	}).done(function(ret) {
		input.val(ret.interval);
	});
};
