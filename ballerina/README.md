## Overview

[Weaviate](https://weaviate.io/) is an open-source, AI-native vector database that stores objects together with their vector embeddings, so applications can run semantic, keyword and hybrid searches over their data.

The Weaviate connector lets Ballerina applications manage collections and their properties, import, read, update and delete objects, run vector, keyword and hybrid searches, and administer tenants, aliases, backups, replication, users and roles. It supports version 1 of the Weaviate REST API.

### Key features

- Create, inspect, update and delete collections and their properties
- Import objects in batches and read, patch, replace and delete them individually
- Search collections with near-text, near-object, BM25 and hybrid queries, and run GraphQL queries
- Manage multi-tenancy, aliases, backups, exports and replication
- Administer database users, roles, permissions and namespaces

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
