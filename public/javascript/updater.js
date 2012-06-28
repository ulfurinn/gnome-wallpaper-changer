var Updater =  { };

Updater.init = function() {
	this.wire_autostart( $("#autostart") );
	this.wire_interval_field( $(".rotation-interval form"), $("#interval") );
	this.wire_add_folder_form( $(".add-folder form"), $("#folder") );

	this.fetch_autostart( $("#autostart") );
	this.fetch_interval( $("#interval") );
	this.fetch_wallpapers( $("#wallpapers") );
};

Updater.wire_autostart = function( input ) {
	input.change(function(e){
		$.ajax({
			type: 'POST',
			url: '/autostart',
			data: {enable: e.target.checked}
		}).done(function(ret) {
			input.attr('checked', ret.enabled);
			input.stop().css("opacity", 0).animate({ opacity: 1 }, 500);
		});
	});
};

Updater.wire_interval_field = function( form, input ) {
	form.submit(function() {
		$.ajax({
			type: 'POST',
			url: '/interval',
			data: {interval: parseInt(input.val())}
		}).done(function(ret) {
			input.val(ret.interval);
			input.stop().css("background-color", "#55FF55").animate({ backgroundColor: $.Color("#FFFFFF")}, 500);
		});
		return false;
	});
};

Updater.wire_add_folder_form = function( form, input ) {
	input.autocomplete({
		source: '/folder-suggest',
		minLength: 1,
		delay: 200
	});
	form.submit(function(){
		$.ajax({
			type: 'POST',
			url: '/add',
			data: { folder: input.val() }
		}).done(function( folder ) {
			input.val('');
			if(folder) {
				Updater.build_folder( $("#wallpapers"), folder );
			}
		});
		return false;
	});
};

Updater.wire_file_checkbox = function(checkbox, file, folder) {
	if(folder.excluded.indexOf(file) == -1)
		checkbox.attr('checked', true);
	checkbox.change(function(e) {
		var url = e.target.checked ? '/include' : '/exclude';
		$.ajax({
			type: 'POST',
			url: url,
			data: {
				folder: folder.path,
				file: file
			}
		}).done(function(){
			checkbox.stop().css("opacity", 0).animate({ opacity: 1 }, 500);
		});

	});
};

Updater.make_include_all_button = function( container, folderDiv, folder ) {
	var container = $('<div>').addClass('command');
	var button = $('<a>').attr('href', '#').text('include all');
	button.click(function(){
		$.ajax({
			type: 'POST',
			url: '/include',
			data: { folder: folder.path }
		}).done(function(){
			$.ajax({
				type: 'GET',
				url: '/wallpapers',
				data: { folder: folder.path }
			}).done(function(ret){
				Updater.build_folder( container, ret, folderDiv );
			});
		});
		return false;
	});
	container.append( button );
	return container;
};

Updater.make_exclude_all_button = function( container, folderDiv, folder ) {
	var container = $('<div>').addClass('command');
	var button = $('<a>').attr('href', '#').text('exclude all');
	button.click(function(){
		$.ajax({
			type: 'POST',
			url: '/exclude',
			data: { folder: folder.path }
		}).done(function(){
			$.ajax({
				type: 'GET',
				url: '/wallpapers',
				data: { folder: folder.path }
			}).done(function(ret){
				Updater.build_folder(container, ret, folderDiv);
			});
		});
		return false;
	});
	container.append( button );
	return container;
};

Updater.make_remove_folder_button = function( container, folderDiv, folder ) {
	var container = $('<div>').addClass('command');
	var button = $('<a>').attr('href', '#').text('remove folder');
	button.click(function(){
		$.ajax({
			type: 'POST',
			url: '/remove',
			data: { folder: folder.path }
		}).done(function(){
			$.ajax({
				type: 'GET',
				url: '/wallpapers',
				data: { folder: folder.path }
			}).done(function(){
				folderDiv.remove();
			});
		});
		return false;
	});
	container.append( button );
	return container;
};

Updater.fetch_autostart = function(input) {
	$.ajax({
		type: 'GET',
		url: '/autostart'
	}).done(function(ret) {
		input.attr('checked', ret.enabled);
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

Updater.build_folder = function(container, folder, existingFolderDiv) {
	var folderDiv = $("<div>");
	folderDiv.addClass('folder').
	append( $('<div>').addClass('top-bar').text(folder.path).
		append( Updater.make_include_all_button( container, folderDiv, folder ) ).
		append( Updater.make_exclude_all_button( container, folderDiv, folder ) ).
		append( Updater.make_remove_folder_button( container, folderDiv, folder ) )
	);
	var filesDiv = $('<div>').addClass('wallpaper-list');
	folder.files.forEach(function(file){
		var checkbox = $('<input>').attr('type', 'checkbox');
		var fileName = file.substring( file.lastIndexOf('/') + 1 );
		var fileDiv = $("<div>").addClass('file').append(
			$("<img>").attr('src', '/file?path=' + encodeURI(file)).
			attr('title', fileName).
			dblclick(function(){
				$.ajax({
					type: 'POST',
					url: '/change',
					data: { file: file }
				})
			})
		).append( checkbox );
		Updater.wire_file_checkbox( checkbox, file, folder );
		filesDiv.append( fileDiv );
	});
	folderDiv.append( filesDiv );
	if(existingFolderDiv) {
		existingFolderDiv.replaceWith(folderDiv);
		folderDiv.css("background-color", "#55FF55").animate({ backgroundColor: $.Color("#FFFFFF")}, 500);
	}
	else
		container.append(folderDiv);
};

Updater.fetch_wallpapers = function(container) {
	$.ajax({
		type: 'GET',
		url: '/wallpapers'
	}).done(function(ret){
		ret.folders.forEach(function(folder){
			Updater.build_folder(container, folder);
		});
	});
};
