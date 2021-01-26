set ns [new Simulator]

set nf [open p1.nam w]

$ns namtrace-all $nf

set tf [open p1.tr w]

$ns trace-all $tf

proc Finish {} {

    global ns tf nf

    $ns flush-trace

    close $tf

    close $nf

    exit 0

}

set n0 [$ns node]

set n1 [$ns node]

set n2 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail

$ns duplex-link $n1 $n2 800Kb 10ms DropTail

$ns queue-limit $n0 $n1 10

$ns queue-limit $n1 $n2 10

set udp [new Agent/UDP]

$ns attach-agent $n0 $udp

set null0 [new Agent/Null]

$ns attach-agent $n2 $null0

$ns connect $udp $null0

set cbr0 [new Application/Traffic/CBR]

$cbr0 set type_ CBR

$cbr0 set packetSize_ 100

$cbr0 set rate_ 1Mb

$cbr0 set random_ false

$cbr0 attach-agent $udp

$ns at 0.0 "$cbr0 start"

$ns at 5.0 "Finish"

$ns run

BEGIN {

    cnt=0;

}

{

  if($1=="d")

  {

    cnt++;

  }

}

END {

    printf("The number of packets dropped is :%d\n",cnt);

}
