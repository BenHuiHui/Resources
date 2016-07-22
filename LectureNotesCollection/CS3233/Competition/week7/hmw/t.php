<?php
$str = "10001\n";
for($i = 0;$i<=10000;$i = $i+1){
    $str .= $i."\n";
    echo $i;
}
file_put_contents("test.in",$str);
