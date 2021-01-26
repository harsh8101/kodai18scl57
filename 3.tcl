set ns [new Simulator]

set tf [open p3.tr w]

$ns trace-all $tf

set nf [open p3.nam w]

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

lappend nlist $n1 $n2 $n3 $n4 $n5 $n0

$ns make-lan $nlist 10Mb 10ms LL Queue/DropTail

set tcp0 [new Agent/TCP]

$ns attach-agent $n0 $tcp0

set tcp1 [new Agent/TCP]

$ns attach-agent $n2 $tcp1

set sink0 [new Agent/TCPSink]

$ns attach-agent $n3 $sink0

set sink1 [new Agent/TCPSink]

$ns attach-agent $n1 $sink1

$ns connect $tcp0 $sink0

$ns connect $tcp1 $sink1

set ftp0 [new Application/FTP]

set ftp1 [new Application/FTP]

$ftp0 attach-agent $tcp0

$ftp1 attach-agent $tcp1

$tcp0 attach $tf

$tcp0 trace cwnd_

$tcp1 attach $tf

$tcp1 trace cwnd_

$ns at 0.0 "$ftp0 start"

$ns at 0.2 "$ftp1 start"

$ns at 6.0 "Finish"

$ns run

BEGIN {

}

{

 if($6=="cwnd_")

     {

         if($2==0 && $4==3)

              printf("%4.2f\t%4.2f\t\n",$1,$7)>>"g1.txt";

         if($2==2 && $4==1)

              printf("%4.2f\t%4.2f\t\n",$1,$7)>>"g2.txt";

     }

 }

 END {

     puts "DONE";

     }
