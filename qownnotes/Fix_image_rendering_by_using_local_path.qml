import QtQml 2.0

QtObject {

	function noteToMarkdownHtmlHook(note, html) {
		var fileName = note.fileName;
		var fullNoteFilePath = note.fullNoteFilePath;
		var	correctLocalPath = fullNoteFilePath.replace(fileName, '');
		html = html.replace(/src="\.\/media/g, 'src="file:///' + correctLocalPath + 'media');
		return html;
	}

}