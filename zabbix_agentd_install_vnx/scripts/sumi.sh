#!/bin/sh
#
while read n1
do
sum=`expr $sum + $n1`
#echo $sum
done
echo $sum
RAWCAPACITY=$sum
#echo $RAWCAPACITY
