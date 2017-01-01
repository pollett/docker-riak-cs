## 0.8.0

* Update riak

## 0.7.2

* Fix container ID extraction by container name.

## 0.7.1

* Fix reference to `phusion/baseimage` insecure key.

## 0.7.0

* Use Trusty packages for Riak and Riak CS.
* Bump Serf version to `0.6.3`.

## 0.6.0

* Bump Riak version to `1.4.10`.
* Bump `phusion/baseimage` version to `0.9.15`.
* Bump Riak CS version to `1.5.2`.
* Bump Stanchion version to `1.5.0`.

## 0.5.1

* Add support for BusyBox distribution.

## 0.5.0

* Add support for an HAProxy container that load balances against all nodes.

## 0.4.0

* Use `localhost` if `DOCKER_HOST` is not defined.
* Emit Riak CS admin key and secret after cluster start.

## 0.3.0

* Bump Riak version to `1.4.9`.
* Bump `phusion/baseimage` version to `0.9.11`.
* Bump Serf version to `0.6.2`.
* Default Docker port is now `2375`.
* Ensure host contained in `DOCKER_HOST` is used to detect node liveness.

## 0.2.0

* Remove `sysctl` specific settings from `Dockerfile`.
* Add better detection of an invalid cluster start state.
* Fix broken conditional for peer vs. seed Serf event handler script.

## 0.1.2

* Fix broken `test-cluster` target.

## 0.1.1

* Include a minimum Docker version requirement (`0.10.0`).

## 0.1.0

* Initial release.
