#!/bin/bash

echo "Checking InfluxDB container status..."
docker ps -a | grep influxdb_container

echo -e "\nChecking InfluxDB logs..."
docker logs influxdb_container --tail 20

echo -e "\nTesting InfluxDB ping..."
curl -v http://localhost:8086/ping

echo -e "\nTrying to access InfluxDB endpoints..."
echo "1. /query endpoint:"
curl -v http://localhost:8086/query?q=SHOW+DATABASES

echo -e "\n2. Status endpoint:"
curl -v http://localhost:8086/status

echo -e "\nNote: If you're trying to access the web UI, InfluxDB 1.8 doesn't have a built-in web UI."
echo "You need to access it through Grafana or use tools like influx CLI or Chronograf."
echo "Try accessing Grafana at http://localhost:3001 and add InfluxDB as a data source." 