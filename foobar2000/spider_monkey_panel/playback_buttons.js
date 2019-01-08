'use strict';

window.DefinePanel('Playback Buttons', {
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
    buttons: window.GetColourCUI(0),
	background : window.GetColourCUI(3),
};

function _unicodeToImg(chr, colour) {
    const size = 256;
	let temp_bmp = gdi.CreateImage(size, size);
	let temp_gr = temp_bmp.GetGraphics();
	temp_gr.SetTextRenderingHint(4);
    let fontItemsEnlarged = gdi.Font(window.GetFontCUI(0).Name, window.GetFontCUI(0).Size * 15, 1);
	temp_gr.DrawString(chr, fontItemsEnlarged, colour, 0, 0, size, size, SF_CENTRE);
	temp_bmp.ReleaseGraphics(temp_gr);
	temp_gr = null;
	return temp_bmp;
}

//////////////////////////////////////////////////////////////

let panel = new _panel();
let buttons = new _buttons();
const bs = _scale(24);
on_playback_new_track(fb.GetNowPlaying());

buttons.update = () => {
	const y = Math.round((panel.h - bs) / 2);
	buttons.buttons.stop = new _button(LM + (bs * 0), y, bs, bs, {normal : _unicodeToImg('\u25fc', colours.buttons)}, () => { fb.Stop(); }, 'Stop');
	buttons.buttons.previous = new _button(LM + (bs * 1), y, bs, bs, {normal : _unicodeToImg('\u23EE', colours.buttons)}, () => { fb.Prev(); }, 'Previous');
	buttons.buttons.play = new _button(LM + (bs * 2), y, bs, bs, {normal : !fb.IsPlaying || fb.IsPaused ? _unicodeToImg('\u2bc8', colours.buttons) : _unicodeToImg('\u23F8', colours.buttons)}, () => { fb.PlayOrPause(); }, !fb.IsPlaying || fb.IsPaused ? 'Play' : 'Pause');
	buttons.buttons.next = new _button(LM + (bs * 3), y, bs, bs, {normal : _unicodeToImg('\u23ED', colours.buttons)}, () => { fb.Next(); }, 'Next');
}

function on_mouse_lbtn_down(x, y) {
	return;
}

function on_mouse_lbtn_up(x, y) {
	if (buttons.lbtn_up(x, y)) {
		return;
	}
}

function on_mouse_leave() {
	buttons.leave();
}

function on_mouse_move(x, y) {
	if (buttons.move(x, y)) {
		return;
	}
}

function on_mouse_rbtn_up(x, y) {
	return panel.rbtn_up(x, y);
}

function on_paint(gr) {
	gr.FillSolidRect(0, 0, panel.w, panel.h, colours.background);
	buttons.paint(gr);
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
	buttons.update();
	window.Repaint();
}

function on_playback_starting() {
	buttons.update();
	window.Repaint();
}

function on_playback_stop() {
	buttons.update();
	window.Repaint();
}

function on_size() {
	panel.size();
	buttons.update();
}
