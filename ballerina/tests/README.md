# Running Tests

## Prerequisites

To run the tests against a live Weaviate instance you need its REST endpoint and an API key that can manage collections, objects, tenants, aliases, roles and users. Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-weaviate/blob/main/ballerina/README.md#setup-guide) to obtain them.

## Test environments

There are two test environments. The default is a mock server that implements 25 representative operations of the Weaviate REST API. The other is a live Weaviate instance.

 Test Groups | Environment
-------------|------------------------------------------------
 mock_tests  | Mock server for the Weaviate REST API (default)
 live_tests  | Weaviate instance

## Running tests against the mock server

No configuration is needed. When `IS_LIVE_SERVER` is not set to `true`, the tests run against the mock server on port `9090`.

```bash
./gradlew clean test
```

## Running tests against a live Weaviate instance

Set the following environment variables, then run the tests.

| Variable | Description |
|---|---|
| `IS_LIVE_SERVER` | Set to `true` to target the Weaviate instance instead of the mock server |
| `WEAVIATE_URL` | REST endpoint of the instance, for example `https://<cluster-id>.weaviate.cloud/v1` |
| `WEAVIATE_API_KEY` | API key of a user with administrative permissions |

```bash
export IS_LIVE_SERVER=true
export WEAVIATE_URL=<endpoint>
export WEAVIATE_API_KEY=<api-key>
./gradlew clean test -Pgroups=live_tests
```

The live tests create and delete a collection named `Article` and create a role named `reader`, so run them against a disposable instance.
