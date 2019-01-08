# Foobar2000 Theme

## Colors

**Foreground color:**

- #dbdbdb
- rgb(219,219,219)

**Bakground color of non-selected items:**

- #141414
- rgb(20,20,20)

**Bakground color of selected items:**

- #dc2328
   rgb(220,35,40)

**Bakground color of selected but inactive items:**

- #8c161a
- rgb(140,22,26)

## OSD

```
// For line breaks, use $char(10)
// Color for the first text information (paused or track title)
$rgb(220,35,40,0,0,0)
// Indicates if the track is paused or not
$if(%_ispaused%,'[paused]'$char(10))
// Display title
$pad_right(%title%,80)
// Display album artist if set
[$char(10)%album artist%]
// Display album name if set
[$char(10)%album%]
// Display date if set
[$char(10)%date%]
```