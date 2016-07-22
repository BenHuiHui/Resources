<?php
$str="";
$size = 10000;
for($i = 0;$i < 10;$i += $size){
    $n = rand(100000000, 1000000000);
    for($j = 2; $j < 50; $j += 1) {
        $str .= $n ." ".$j."\n";
    }
}

file_put_contents("c.in2",$str);
?>
