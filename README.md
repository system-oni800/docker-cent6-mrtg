docker-cent6-mrtg
==================

mrtg on docker/centos6

Make a mrtg environment using the Docker.

### 1. Please correct the file to suit your environment

 - Dockerfile
 
   Your IP address, password to allow

 - monit.mrtg
set httpd port 2812 and
    allow localhost        # allow localhost to connect to the server and
    allow **Your IP address here**
    allow admin:monit      # require user 'admin' with password 'monit'
    allow @monit           # allow users of group 'monit' to connect (rw)
    allow @users readonly  # allow users of group 'users' to connect readonly

 - td-agent.conf
 
   Your log server's IP address

<match http.app.**>
  type forward
  <server>
  host **Your log server's IP address here**
  </server>
  flush_interval 2s
</match>


### 2. Build docker image

  Build a docker container.
  
```sh
  # ./build.sh 
   ....
  # docker images
  REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
  centos6             mrtg                54b06fdd740b        About an hour ago   858.9 MB
```

### 3. Run docker container

```sh
  $sudo ./start.sh
  a618599f2e4fb58a08ed718329ceb6ac9c876f9988d0cfd353fd9a7d0b3b4cfc
  Usage of loopback devices is strongly discouraged for production use. Either use `--storage-opt dm.thinpooldev` or use `--storage-opt dm.no_warn_on_loop_devices=true` to suppress this warning.
  CONTAINER ID        IMAGE                      COMMAND               CREATED             STATUS              PORTS                                                                 NAMES
  a618599f2e4f        centos6:mrtg               "/usr/bin/monit -I"   4 seconds ago       Up 3 seconds        0.0.0.0:8022->22/tcp, 0.0.0.0:8080->80/tcp, 0.0.0.0:12812->2812/tcp   mrtg                
  # docker exec -it mrtg /bin/bash   ...
  [root@a618599f2e4f /]# cd /root
```
 Set IP address(internal) to configuration files and go.
```
  [root@a618599f2e4f /]# ./set.sh
  ip address = 172.17.2.XX
   ....
  Reload monit..
  Reinitializing monit daemon
  USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
  root         1  0.3  0.1  56744  2632 ?        Ssl+ 14:15   0:00 /usr/bin/monit -I
  ....
  root       189  0.0  0.0 110232  1148 ?        R+   14:16   0:00 ps aux
  End of script(/root/mk-mrtg.sh).
```
