#!/usr/bin/env php
<?php

$volume = exec('pamixer --get-volume');
if (is_numeric($volume)) {
    $fancyNumbers = ['𝟎', '𝟏', '𝟐', '𝟑', '𝟒', '𝟓', '𝟔', '𝟕', '𝟖', '𝟗'];
    $fancyVolume = $fancyNumbers[$volume[0]].$fancyNumbers[$volume[1]];
} else {
    echo '--';
}

echo $fancyVolume;
