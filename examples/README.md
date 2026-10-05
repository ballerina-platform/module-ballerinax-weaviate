# Examples

The `ballerinax/weaviate` connector provides practical examples illustrating usage in various scenarios.

1. **[Collection data management](https://github.com/ballerina-platform/module-ballerinax-weaviate/tree/main/examples/collection_data_management)** - Create a collection, add a property, import a batch of objects, list them and delete the objects that match a filter.

2. **[Access role setup](https://github.com/ballerina-platform/module-ballerinax-weaviate/tree/main/examples/access_role_setup)** - Create a read-only role, create a database user, assign the role to the user and read back the user's roles.

## Prerequisites

1. Get the REST endpoint and an API key of a Weaviate instance as described in the [Setup guide](https://central.ballerina.io/ballerinax/weaviate/latest#setup-guide).

2. For each example, create a `Config.toml` file with the related configuration. Here's an example of how your Config.toml file should look:

```toml
weaviateUrl = "<Weaviate REST endpoint, e.g. https://<cluster-id>.weaviate.cloud/v1>"
apiKey = "<Weaviate API key>"
```

Each example lists the additional values it needs in its own README.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
