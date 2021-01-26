set ns [new Simulator]
set tf [open p2.tr w]
$ns trace-all $tf
set nf [open p2.nam w]
$ns namtrace-all $nf
proc Finish {} {
    global ns nf tf
    $ns flush-trace
    close $tf
    close $nf
    exit 0
}
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
$ns duplex-link $n0 $n5 1Mb 10ms DropTail
$ns duplex-link $n1 $n5 1Mb 10ms DropTail
$ns duplex-link $n2 $n5 1Mb 10ms DropTail
$ns duplex-link $n3 $n5 1Mb 10ms DropTail
$ns duplex-link $n5 $n4 1Mb 10ms DropTail
$ns queue-limit $n0 $n5 2
$ns queue-limit $n1 $n5 2
$ns queue-limit $n2 $n5 2
$ns queue-limit $n3 $n5 2
$ns queue-limit $n5 $n4 2
Agent/Ping instproc recv {from rtt} {
$self instvar node_
puts "node [$node_ id] received ping msg from $from with rtt as $rtt ms"
}
set p0 [$ns create-connection Ping $n0 Ping $n1 1]
set p1 [$ns create-connection Ping $n1 Ping $n3 2]
set p2 [$ns create-connection Ping $n2 Ping $n4 3]
set p3 [$ns create-connection Ping $n3 Ping $n5 4]
set p4 [$ns create-connection Ping $n4 Ping $n1 0]
set p5 [$ns create-connection Ping $n5 Ping $n2 5]
for {set i 0} {$i<6} {incr i} {
$ns at [expr $i/10] "$p0 send"
$ns at [expr $i/10] "$p1 send"
$ns at [expr $i/10] "$p2 send"
$ns at [expr $i/10] "$p3 send"
$ns at [expr $i/10] "$p4 send"
}
$ns at 3.0 "Finish"
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
