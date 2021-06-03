#!/usr/bin/env php
<?php

$tmp = file_get_contents("/home/alexis/.cache/wal/colors.json");
$walColors = json_decode($tmp);

$template = "<fc={$walColors->colors->color3}> <fn=1>🙤</fn> <box type=Bottom width=3>%track%</box> <fn=1>🙚</fn></fc>"
    . "<fc={$walColors->colors->color4}><fn=1>🙙</fn> <box type=Bottom width=3>%album%</box> <fn=1>🙚</fn></fc>"
    . "<fc={$walColors->colors->color5}><fn=1>🙙</fn> <box type=Bottom width=3>%artist%</box> <fn=1>🙦</fn></fc>"
    . "}{ <fc={$walColors->special->foreground}><fn=1>🙤</fn> <fn=1>%volume%</fn></fc>";
//$index = 0;
//foreach (get_object_vars($walColors->colors) as $color) {
    //$template .= "<fc=#ffffff,{$color}> $index </fc>";
    //if ($index === 9) {
        //break;
    //}
    //++$index;
//}
$template .= "<fc={$walColors->special->foreground}> <fn=1>🙦</fn></fc>";

exec("xmobar -x 1 --bgcolor='{$walColors->special->background}' --template='$template' /home/alexis/.config/xmobar/xmobarrc2");
