<?php

function hello()
{
    echo "Hello World !\n";
    $output = "Server is started MATE :D";
    $fp = fopen("php://stdout", 'rw');
    fputs($fp, "$output\n");
}

hello();
?>