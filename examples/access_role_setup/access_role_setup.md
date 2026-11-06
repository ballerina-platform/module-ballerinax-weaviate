# Access role setup

This example creates a read-only role for a group of collections, reads the role back, and, when enabled, creates a database user, assigns the role to that user and lists the roles the user now holds.

## Prerequisites

### 1. Set up Weaviate

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-weaviate/blob/main/ballerina/README.md#setup-guide) to get the REST endpoint of a Weaviate instance with role-based access control enabled, and an admin API key.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
weaviateUrl = "<Weaviate REST endpoint, e.g. https://<cluster-id>.weaviate.cloud/v1>"
adminApiKey = "<Weaviate admin API key>"
roleName = "article-reader"
userId = "<id of the database user>"
collectionPattern = "Article*"
createUserAndAssignRole = false
```

Creating a user returns an API key that is shown only once, so the example creates the user and assigns the role only when `createUserAndAssignRole` is `true`.

## Run the example

Execute the following command to run the example:

```bash
bal run
```
