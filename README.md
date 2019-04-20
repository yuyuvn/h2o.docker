# h2o.docker

docker files for h2o http2 webserver with arm architecture, see https://h2o.examp1e.net/

[![](https://badge.imagelayers.io/clicia/h2o-http2-server:latest.svg)](https://imagelayers.io/?images=clicia%2Fh2o-http2-server:latest)
[![](https://img.shields.io/docker/stars/clicia/h2o-http2-server.svg)](https://hub.docker.com/r/clicia/h2o-http2-server/)
[![](https://img.shields.io/docker/pulls/clicia/h2o-http2-server.svg)](https://hub.docker.com/r/clicia/h2o-http2-server/)

- ```latest``` (*[master/Dockerfile](https://github.com/clicia/h2o.docker/blob/master/Dockerfile)*)

version specific tags below

---

simplest run
```bash
docker run -p "8080:8080" -ti clicia/h2o-http2-server
```
test with 
```bash
$ curl http://localhost:8080/
not found
```

A short tutorial can be found on https://blog.lgohlke.de/docker/h2o/2016/03/01/dockerized-h2o-webserver.html

A sample docker-compose file with reduced capability set

```yaml
version: '2'

services:
  h2o:
    image: clicia/h2o-http2-server:v2.1.0
    ports:
       - "444:1443"
    volumes:
       - "/etc/h2o:/etc/h2o"
       - "/etc/letsencrypt:/etc/letsencrypt"
       - "/var/log/h2o:/var/log/h2o"
    working_dir: /etc/h2o
    restart: always
    cap_add:
       - setuid
       - setgid
       - chown
       - sys_admin
    cap_drop:
       - ALL

# vim: syntax=yaml expandtab
```

---

automatically ...

 - checks for new releases 
 - create new tags with changed Dockerfile
 - pushes the tags
 
```bash
./check_releases.sh
```

in crontab
```bash
12 23 * * * bash -c 'cd ~/h2o.docker; git pull; ./check_releases.sh'
```