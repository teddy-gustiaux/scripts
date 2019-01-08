'use strict';

// Seekbar component using the defined user theme
// Other features:
// - Click outside of the seebar to trigger "View/Show now playing in playlist'
// - Use the mouse wheel outside of the seebar to change the volume

window.DefinePanel('Seekbar', {
    author: "Teddy Gustiaux, adapted from marc2k3's script",
    version: '2019.01.06',
});
// Based on the script found at https://github.com/marc2k3/smp_2003/blob/master/track%20info%20%2B%20seekbar%20%2B%20buttons.txt

include(fb.ComponentPath + 'samples\\complete\\js\\lodash.min.js');
include(fb.ComponentPath + 'samples\\complete\\js\\helpers.js');
include(fb.ComponentPath + 'samples\\complete\\js\\panel.js');
include(fb.ComponentPath + 'samples\\complete\\js\\seekbar.js');

// For more documentation, refer to
// https://github.com/marc2k3/smp_2003/blob/master/js/helpers.js
// https://github.com/TheQwertiest/foo_spider_monkey_panel/blob/master/component/docs/Flags.js
// %AppData%\foobar2000\user-components\foo_spider_monkey_panel\docs\html

//////////////////////////////////////////////////////////////

let colours = {
	background : window.GetColourCUI(3),
	time : window.GetColourCUI(0),
    seekbar_background: _blendColours(window.GetColourCUI(3), window.GetColourCUI(0), 0.5),
	seekbar_progress : window.GetColourCUI(5),
	seekbar_knob : window.GetColourCUI(4),
};

let font = {
    items: window.GetFontCUI(0),
    itemsEmphasized: gdi.Font(window.GetFontCUI(0).Name, window.GetFontCUI(0).Size + 2, 1),
    labels: window.GetFontCUI(1),
}

let tfo = {
	playback_time : fb.TitleFormat('%playback_time%  '),
	length : fb.TitleFormat('  %length% / -%playback_time_remaining%')
};

//////////////////////////////////////////////////////////////

let panel = new _panel();
let seekbar = new _seekbar(0, 0, 0, 0);
const bs = _scale(24);
on_playback_new_track(fb.GetNowPlaying());

function on_mouse_lbtn_down(x, y) {
	seekbar.lbtn_down(x, y);
}

function on_mouse_lbtn_up(x, y) {
	if (seekbar.lbtn_up(x, y)) {
		return;
	}
	fb.RunMainMenuCommand('View/Show now playing in playlist');
}

function on_mouse_leave() {
	return;
}

function on_mouse_move(x, y) {
	seekbar.move(x, y);
}

function on_mouse_rbtn_up(x, y) {
	return panel.rbtn_up(x, y);
}

function on_mouse_wheel(s) {
	if (seekbar.wheel(s)) {
		return;
	}
	if (s == 1) {
		fb.VolumeUp();
	} else {
		fb.VolumeDown();
	}
}

function on_paint(gr) {
    // Draw the background of the panel
	gr.FillSolidRect(0, 0, panel.w, panel.h, colours.background);
    // Fill the "unplayed" portion of the seekbar
	gr.FillSolidRect(seekbar.x, seekbar.y, seekbar.w + _scale(6), seekbar.h, colours.seekbar_background);
	if (fb.IsPlaying) {
		gr.SetSmoothingMode(2);
		if (fb.PlaybackLength > 0) {
			const pos = seekbar.pos();
            // Fill the "played" portion of the seekbar
			gr.FillSolidRect(seekbar.x, seekbar.y, pos, seekbar.h, colours.seekbar_progress);
            // Draw a rectangle around the seekbar
            gr.DrawRect(seekbar.x, seekbar.y, seekbar.w + _scale(6), seekbar.h, 1, colours.background);
            // Draw the seekbar cursor
            let cursorExtraHeight = 16;
			gr.FillSolidRect(seekbar.x + pos, seekbar.y - (cursorExtraHeight / 2), _scale(6), seekbar.h + cursorExtraHeight, colours.seekbar_knob);
            // Display the playback time
			gr.GdiDrawText(tfo.playback_time.Eval(), font.itemsEmphasized, colours.time, seekbar.x - _scale(45), 0, _scale(45), panel.h, RIGHT);
            // Display the playback length and time remaining
			gr.GdiDrawText(tfo.length.Eval(), font.itemsEmphasized, colours.time, seekbar.x + seekbar.w + _scale(6), 0, _scale(70), panel.h, LEFT);
		}
	} else {
        // Display placeholders for the playback time, playback length and time remaining
        gr.GdiDrawText('-:--  ', font.itemsEmphasized, colours.time, seekbar.x - _scale(45), 0, _scale(45), panel.h, RIGHT);
        gr.GdiDrawText('  -:-- / --:--', font.itemsEmphasized, colours.time, seekbar.x + seekbar.w + _scale(6), 0, _scale(70), panel.h, LEFT);
    }
}

function on_playback_edited() {
	window.Repaint();
}

function on_playback_new_track(metadb) {
	if (!metadb) {
		return;
	}
	window.Repaint();
}

function on_playback_pause() {
	window.Repaint();
}

function on_playback_starting() {
	window.Repaint();
}

function on_playback_seek() {
	seekbar.playback_seek();
}

function on_playback_stop() {
	window.Repaint();
}

function on_size() {
	panel.size();
	seekbar.x = Math.round(panel.w * 0.10);
	seekbar.w = panel.w - seekbar.x - _scale(100);   
	seekbar.h = _scale(12);
	seekbar.y = (panel.h - seekbar.h) / 2;
}
