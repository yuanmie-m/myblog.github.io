#!/bin/bash
NGINX_COMMAND=$1
NGINX_PORT=80
CACHEFILE="/tmp/nginx_status.txt"
CMD="/usr/bin/curl http://127.0.0.1:"$NGINX_PORT"/nginx_status/"
# Check and run the script
TIMEFLM=`stat -c %Y $CACHEFILE`
TIMENOW=`date +%s`
if [ `expr $TIMENOW - $TIMEFLM` -gt 60 ]; then
    rm -f $CACHEFILE
fi
if [ ! -f $CACHEFILE  ];then
   $CMD >$CACHEFILE 2>/dev/null
fi
nginx_active(){
	 grep 'Active' $CACHEFILE| awk '{print $NF}'
         exit 0;
}
nginx_reading(){
	 grep 'Reading' $CACHEFILE| awk '{print $2}'
         exit 0;
}
nginx_writing(){
	 grep 'Writing' $CACHEFILE | awk '{print $4}'
         exit 0;
}
nginx_waiting(){
	 grep 'Waiting' $CACHEFILE| awk '{print $6}'
         exit 0;
}
nginx_accepts(){
	 awk NR==3 $CACHEFILE| awk '{print $1}' 
         exit 0;
}
nginx_handled(){
	 awk NR==3 $CACHEFILE| awk '{print $2}' 
         exit 0;
}
nginx_requests(){
	 awk NR==3 $CACHEFILE| awk '{print $3}'
         exit 0;
}
case $NGINX_COMMAND in
active)
nginx_active;
;;
reading)
nginx_reading;
;;
writing)
nginx_writing;
;;
waiting)
nginx_waiting;
;;
accepts)
nginx_accepts;
;;
handled)
nginx_handled;
;;
requests)
nginx_requests;
;;
*)
echo 'Invalid credentials';
exit 2;
esac;
