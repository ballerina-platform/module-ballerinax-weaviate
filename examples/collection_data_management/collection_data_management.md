# Collection data management

This example creates a Weaviate collection with a few properties, adds another property, imports a batch of articles, lists the stored objects and then deletes the articles that match a filter. It can optionally remove the collection at the end so the example can be re-run.

## Prerequisites

### 1. Set up Weaviate

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-weaviate/blob/main/ballerina/README.md#setup-guide) to get the REST endpoint of a Weaviate instance and an API key that is allowed to create collections and objects.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
weaviateUrl = "<Weaviate REST endpoint, e.g. https://<cluster-id>.weaviate.cloud/v1>"
apiKey = "<Weaviate API key>"
collectionName = "Article"
deleteCollectionWhenDone = false
```

The example creates the collection `collectionName`, so it must not exist yet. Set `deleteCollectionWhenDone` to `true` to delete the collection, and all of its data, after the example finishes.

## Run the example

Execute the following command to run the example:

```bash
bal run
```
