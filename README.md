# Ballerina Weaviate connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-weaviate/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-weaviate/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-weaviate.svg)](https://github.com/ballerina-platform/module-ballerinax-weaviate/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/weaviate.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fweaviate)

## Overview

[Weaviate](https://weaviate.io/) is an open-source, AI-native vector database that stores objects together with their vector embeddings, so applications can run semantic, keyword and hybrid searches over their data.

The Weaviate connector lets Ballerina applications manage collections and their properties, import, read, update and delete objects, run vector, keyword and hybrid searches, and administer tenants, aliases, backups, replication, users and roles. It supports version 1 of the Weaviate REST API.

## Setup guide

To use the Weaviate connector, you need a running Weaviate instance and an API key that is allowed to access it.

### Step 1: Get a Weaviate instance

1. Create a free sandbox cluster in [Weaviate Cloud](https://console.weaviate.cloud/), or run Weaviate yourself by following the [installation guide](https://docs.weaviate.io/deploy).

2. Note the REST endpoint of the instance. For a cloud cluster it looks like `https://<cluster-id>.weaviate.cloud/v1`, and for a local Docker deployment it is `http://localhost:8080/v1`.

### Step 2: Get an API key

1. For a Weaviate Cloud cluster, open the cluster details page and copy an API key from the **API keys** section.

2. For a self-hosted instance, enable API key authentication as described in the [authentication guide](https://docs.weaviate.io/weaviate/configuration/authentication) and use one of the configured keys.

## Quickstart

To use the Weaviate connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `weaviate` module.

```ballerina
import ballerinax/weaviate;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the endpoint and API key obtained in the steps above:

```toml
weaviateUrl = "<Weaviate REST endpoint, e.g. https://<cluster-id>.weaviate.cloud/v1>"
apiKey = "<Weaviate API key>"
```

2. Create a `weaviate:ConnectionConfig` with the API key and initialize the connector with the endpoint.

```ballerina
configurable string weaviateUrl = ?;
configurable string apiKey = ?;

final weaviate:Client weaviateClient = check new ({auth: {token: apiKey}}, weaviateUrl);
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Get the instance metadata

```ballerina
public function main() returns error? {
    weaviate:Meta _ = check weaviateClient->getInstanceMeta();
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The Weaviate connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-weaviate/tree/main/examples/), covering the following use cases:

1. [Collection data management](https://github.com/ballerina-platform/module-ballerinax-weaviate/tree/main/examples/collection_data_management) - Create a collection, add a property, import a batch of objects, list them and delete the objects that match a filter.

2. [Access role setup](https://github.com/ballerina-platform/module-ballerinax-weaviate/tree/main/examples/access_role_setup) - Create a read-only role, create a database user, assign the role to the user and read back the user's roles.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`weaviate` package](https://central.ballerina.io/ballerinax/weaviate/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
