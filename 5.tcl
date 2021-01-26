set ns [new Simulator]
set tf [open p5.tr w]
$ns trace-all $tf
set nf [open p5.nam w]
$ns namtrace-all $tf
set ms1 [$ns node]
set bs1 [$ns node]
set msc [$ns node]
set bs2 [$ns node]
set ms2 [$ns node]
$ns duplex-link $ms1 $bs1 1Mb 1ms DropTail
$ns duplex-link $bs1 $msc 1Mb 1ms DropTail
$ns duplex-link $msc $bs2 1Mb 1ms DropTail
$ns duplex-link $bs2 $ms2 1Mb 1ms DropTail
puts "Cell Topology"
$ns bandwidth $ms1 $bs1 9.6Kb simplex
$ns bandwidth $bs1 $ms1 9.6Kb simplex
$ns bandwidth $ms2 $bs2 9.6Kb simplex
$ns bandwidth $bs2 $ms2 9.6Kb simplex
$ns insert-delayer $ms1 $bs1 [new Delayer]
$ns insert-delayer $bs2 $ms2 [new Delayer]
set tcp1 [new Agent/TCP]
$ns attach-agent $ms1 $tcp1
set tcpsink1 [new Agent/TCPSink]
$ns attach-agent $ms2 $tcpsink1
$ns connect $tcp1 $tcpsink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
proc Finish {} {
    global node ms2 nf ms1 bs1
    set sid [$ms1 id]
    set did [$bs1 id]
    puts $sid
    puts $did
    exec /home/ise/ex56/getrc -s $sid -d $did -f 0 p5.tr |\
    /home/ise/ex56/raw2xg -s 0.01 -m 100 -r >> p5.xgr
    exec /home/ise/ex56/getrc -s $sid -d $did -f 0 p5.tr |\
    /home/ise/ex56/raw2xg -a -s 0.01 -m 100 >> p5.xgr
    exec ./p5.awk p5.xgr
    exec xgraph -bb -tk -nl -m -x time -y packet p5.xgr &
    exit 0
}
$ns at 0.1 "$ftp1 start"
$ns at 20 "Finish"
$ns  run


#! /usr/bin/awk -f
BEGIN {system("rm -f acks packets drops")}
{if (ack) print $1 " " $2 >>"acks"}
{if (pkt) print $1 " " $2 >>"packets"}
{if (drp) print $1 " " $2 >>"drops"}
$1 ~ /^.ack/ {ack=1}
$1 ~ /^.packets/ {pkt=1}
$1 ~ /^.drops/ {drp=1}
$1 ~ /^.$/ {ack=0; pkt=0; drp=0}
