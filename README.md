# Ejabberd XMPP Server Docker image
Docker image with [Ejabberd XMPP Server](https://www.ejabberd.im/).

## Supported tags and respective `Dockerfile` links

* [`17.01`](https://github.com/VGoshev/ejabberd-docker/blob/17.01/docker/Dockerfile), [`latest`](https://github.com/VGoshev/ejabberd-docker/blob/master/docker/Dockerfile) - ejabberd v17.01 - Latest stable version.
* [`16.12-beta1`](https://github.com/VGoshev/ejabberd-docker/blob/16.12-beta1/docker/Dockerfile), [`beta`](https://github.com/VGoshev/ejabberd-docker/blob/beta/docker/Dockerfile) - Latest available beta version.

Dockerfiles for older versions of Seafile Server you can find [there](https://github.com/VGoshev/ejabberd-docker/tags).
## Quickstart

To run container you can use following command:
```bash
docker run \  
  -v /home/docker/ejabberd:/home/ejabberd \  
  -p 5222:5222 -p 5223:5223 -p 5269:5269 \  
  -d sunx/ejabberd
```

After first run container will create default configuration files for ejabberd in `/home/ejabberd/etc/ejabberd/` directory, which you should edit manually. Default configuration file is well documented, so you shouldn't have any problems in changeing it. Also you can read [official manual](https://docs.ejabberd.im/admin/configuration/) for help.

## Detailed description of image and containers

### Used ports

This image uses (at least) 3 tcp ports:
* 5222 - XMPP client connection
* 5223 - XMPP client connection over SSL (you can disable it if you don't plan to use it)
* 5269 - XMPP server connection

### Volume
This image uses one volume with internal path `/home/ejabberd`, it will store configuration files, databases and ejabberd logs.

I would recommend you use host directory mapping of named volume to run containers, so you will not lose your valuable data after image update and starting new container.

## ejabberd configuration

For ejabberd configuration you can read [official ejabberd documentation](https://docs.ejabberd.im/), but there are some useful tips:
* Most of ejabberd configuration\administration could be done via **`ejabberdctl`** utility. call it without arguments for help (for example, you can use `docker exec -ti <container_name> ejabberdctl` for it).
* You can find some useful ejabberd plugins in [ejabberd-contrib](https://github.com/processone/ejabberd-contrib). Installation procedure is described there as well.
* Ejabberd have feature of web-based administration. If you want to use so, then you should turn on it in ejabberd configuration file and public needed port.

## License

This Dockerfile and scripts are released under [MIT License](https://github.com/VGoshev/ejabberd-docker/blob/master/LICENSE).

[ejabberd](https://github.com/processone/ejabberd/blob/master/COPYING) has its own license.
