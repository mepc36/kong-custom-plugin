# Summary:

This repo is a minimal example for writing a custom Kong plugin. It's the result of following the tutorial in the Kong docs [here](https://docs.konghq.com/gateway/latest/plugin-development/get-started/).

## Installing the custom plugin:

1. Initialize the project folder:

```
pongo init
```

2. Start dependencies:

```
pongo up
```

3. Launch gateway and open shell:

```
pongo shell
```

4. Run database migrations:

```
kms
```

5. Validate plugin installation:

```
curl -s localhost:8001 | \
  jq '.plugins.available_on_server."my-plugin"'
```

You should see a response like this:

```
{
  "priority": 1000,
  "version": "0.0.1"
}
```

## Manually testing the custom plugin:

1. Add service:

```
curl -i -s -X POST http://localhost:8001/services \
    --data name=example_service \
    --data url='http://httpbin.org'
```

2. Associate custom plugin with `example_service`:

```
curl -is -X POST http://localhost:8001/services/example_service/plugins \
    --data 'name=my-plugin'
```

3. Add a new route for sending requests through the `example_service`:

```
curl -i -X POST http://localhost:8001/services/example_service/routes \
    --data 'paths[]=/mock' \
    --data name=example_route
```

4. The plugin is now configured and will be invoked when Kong Gateway proxies requests via the example_service. Prior to forwarding the response from the upstream, the plugin should append the X-MyPlugin header to the list of response headers.

Test the behavior by proxying a request and asking curl to show the response headers with the -i flag:

```
curl -i http://localhost:8000/mock/anything
```

curl should report HTTP/1.1 200 OK and show the response headers from the gateway. You should see X-MyPlugin: response in the set of headers, indicating that the plugin’s logic has been invoked.

For example:

```
HTTP/1.1 200 OK
Content-Type: application/json
Connection: keep-alive
Content-Length: 529
Access-Control-Allow-Credentials: true
Date: Tue, 12 Mar 2024 14:44:22 GMT
Access-Control-Allow-Origin: *
Server: gunicorn/19.9.0
X-MyPlugin: response
X-Kong-Upstream-Latency: 97
X-Kong-Proxy-Latency: 1
Via: kong/3.6.1
X-Kong-Request-Id: 8ab8c32c4782536592994514b6dadf55
```