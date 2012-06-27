var Updater =  { };

Updater.init = function() {
	this.wire_interval_field( $("#interval") );

	this.fetch_interval( $("#interval") );
	this.fetch_wallpapers( $("#wallpapers") );
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

Updater.wire_file_checkbox = function(checkbox, file, folder) {

};

Updater.fetch_interval = function(input) {
	$.ajax({
		type: 'GET',
		url: '/interval'
	}).done(function(ret) {
		input.val(ret.interval);
	});
};

Updater.fetch_wallpapers = function(container) {
	$.ajax({
		type: 'GET',
		url: '/wallpapers'
	}).done(function(ret){
		ret.folders.forEach(function(folder){
			var folderDiv = $("<div>").addClass('folder').append( $('<div>').text(folder.path) );
			folder.files.forEach(function(file){
				var checkbox = $('<input>').attr('type', 'checkbox');
				var fileDiv = $("<div>").addClass('file').append(
					$("<img>").
					attr('src', '/file?path=' + encodeURI(file))
				).append( checkbox );
				Updater.wire_file_checkbox( checkbox, file, folder );
				folderDiv.append( fileDiv );
			});
			container.append(folderDiv);
		});
	});
};
