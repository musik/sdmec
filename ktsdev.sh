ktserver -port 1978 -tout 10 \
  -log /home/muzik/as3/tb3/log/ktserver.log -ls \
  -dmn -pid /home/muzik/as3/tb3/tmp/ktserver.pid \
  '/home/muzik/as3/tb3/db/dev.kch'
rake ts:start
