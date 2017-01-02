#! /bin/sh

if env | egrep -q "DOCKER_RIAK_CS_AUTOMATIC_CLUSTERING=1"; then

  until curl -s "http://${SEED_PORT_8080_TCP_ADDR}:8080/riak-cs/ping" | egrep "OK" > /dev/null;
  do
    sleep 5
  done

  # Join node to the Riak and Serf clusters
  (sleep 30; if env | egrep -q "SEED_PORT_8080_TCP_ADDR"; then
    serf join "${SEED_PORT_8080_TCP_ADDR}" &> /var/log/cluster_auto
    riak-admin cluster join "riak@${SEED_PORT_8080_TCP_ADDR}" &> /var/log/cluster_auto
  fi) &

  # Are we the last node to join?
  (sleep 30;
    riak-admin cluster plan &> /var/log/cluster_auto && riak-admin cluster commit &> /var/log/cluster_auto
  ) &
fi
