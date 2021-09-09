#!/usr/bin/env php
<?php

require_once('toFancyNumber.php');

$tmp = file_get_contents("/home/alexis/.cache/wal/colors.json");
$walColors = json_decode($tmp);
$background = $walColors->special->background;

$template = "<fc={$walColors->colors->color3}> <fn=1>🙤</fn> <box type=Bottom width=3>%track%</box> <fn=1>🙚</fn></fc>"
    . "<fc={$walColors->colors->color4}><fn=1>🙙</fn> <box type=Bottom width=3>%album%</box> <fn=1>🙚</fn></fc>"
    . "<fc={$walColors->colors->color5}><fn=1>🙙</fn> <box type=Bottom width=3>%artist%</box> <fn=1>🙦</fn></fc>";
    //. "}{ <fc={$walColors->special->foreground}><fn=1>🙤</fn> <fn=1>%volume%</fn> <fn=1>🙦</fn></fc>";
$index = 0;
$colors = get_object_vars($walColors->colors);
foreach ($colors as $color) {
    $nextIndex = $index + 1;
    $nextColor = $colors["color$nextIndex"];
    $fancyIndex = toFancyNumber((string) $index);
    if ($index !== 9) {
        $template .= "<fn=0><fc={$color},{$nextColor}>█</fc></fn>";
    } else {
        $template .= "<fn=0><fc={$color},{$background}>█</fc></fn>";
        break;
    }
    ++$index;
}
$template .= "<fc={$walColors->special->foreground}> <fn=1>🙦</fn></fc>";

exec("xmobar -x 1 --bgcolor='{$walColors->special->background}' --template='$template' /home/alexis/.config/xmobar/xmobarrc2");
