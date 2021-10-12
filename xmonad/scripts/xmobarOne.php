#!/usr/bin/env php
<?php


$tmp = file_get_contents("/home/alexis/.cache/wal/colors.json");
$walColors = json_decode($tmp);
$template = "%StdinReader%}{"
    . "<fc={$walColors->colors->color3}>%cpu%</fc>"
    . "<fc={$walColors->colors->color4}>%memory%</fc>"
    . "<fc={$walColors->colors->color5}>%disku%</fc>"
    . "<fc={$walColors->colors->color6}>%wlp2s0%</fc>"
    . "<fc={$walColors->colors->color7}>%battery%</fc>"
    . "<fc={$walColors->colors->color9}><fn=1>🙙 <box type=Bottom width=3>%volume%</box> 🙚</fn></fc>"
    . "<fc={$walColors->colors->color10}>%date%</fc>";

exec("xmobar -x 0 --bgcolor='{$walColors->special->background}' --template='$template'");
