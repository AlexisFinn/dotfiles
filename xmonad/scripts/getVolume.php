#!/usr/bin/env php
<?php

require_once('toFancyNumber.php');

$volume = exec('pamixer --get-volume');
if (is_numeric($volume)) {
    $fancyVolume = toFancyNumber($volume);
} else {
    echo '--';
}

echo $fancyVolume;
