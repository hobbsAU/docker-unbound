#!/bin/sh


if [ ! -z "$CACHE_MIN_TTL" ]
then
    sed -i -E "s/(.*)cache-min-ttl: (.*)/cache-min-ttl: $CACHE_MIN_TTL/" /etc/unbound/unbound.conf
fi

if [ ! -z "$CACHE_MAX_TTL" ]
then
    sed -i -E "s/(.*)cache-max-ttl: (.*)/cache-max-ttl: $CACHE_MAX_TTL/" /etc/unbound/unbound.conf
fi

if [ ! -z "$NUM_THREADS" ]
then
    sed -i -E "s/(.*)num-threads: (.*)/num-threads: $NUM_THREADS/" /etc/unbound/unbound.conf
fi

if [ "$UPDATE_DNSSEC_ANCHOR" = "yes" ]
then
	echo "Receiving anchor key..."
	/usr/sbin/unbound-anchor -4 -a /etc/unbound/trusted-key.key
fi

if [ "$UPDATE_ROOT_DNS_SERVERS" = "yes" ]
then
	echo "Receiving root hints..."
	curl -#o /etc/unbound/root.hints https://www.internic.net/domain/named.cache
fi

exec "$@"
