#!/bin/php
<?php

$domain = "http://d8lkzio2al7h7.cloudfront.net/";
$file = fopen("t","r");
while (!feof($file)) {
  $f = trim(fgets($file));
  echo $f . "," . $domain . $f . "\n";
}
fclose($file);

?>
