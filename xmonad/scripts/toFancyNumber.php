<?php

function toFancyNumber(string $number)
{
    $fancyNumbers = ['𝟎', '𝟏', '𝟐', '𝟑', '𝟒', '𝟓', '𝟔', '𝟕', '𝟖', '𝟗'];
    switch (strlen($number)) {
        case 0: return '';
        default: return $fancyNumbers[$number[0]] . toFancyNumber(substr($number, 1));
    }
}
