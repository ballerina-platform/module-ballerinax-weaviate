_Author_:  @DimuthuMadushan \
_Created_: 2026/10/05 \
_Updated_: 2026/10/05 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Weaviate. 
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/weaviate/weaviate/v1/openapi.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Replace OpenAPI 3.1 style `type` arrays with a single `type` plus `x-nullable: true`
- **Original**: `"type": ["string", "null"]` (and `["integer", "null"]`) on `DBUserInfo.createdAt`, `DBUserInfo.apiKeyFirstLetters`, `DBUserInfo.lastUsedAt`, `DBUserCredential.secureHash`, `ReplicationScalePlan.shardScaleActions.addNodes` values, `NodeShardStatus.numberOfReplicas` and `NodeShardStatus.replicationFactor`.
- **Updated**: `"type": "string"` or `"type": "integer"` with `"x-nullable": true`.
- **Reason**: The Swagger 2.0 parser does not understand type arrays and dropped the type of these properties, so they were generated untyped.

2. Add `host` and `basePath` to the Swagger 2.0 specification
- **Original**: The server was declared only in an OpenAPI 3 style `servers` block with `{protocol}://{WEAVIATE_HOSTNAME}:{PORT}/v1`, which a Swagger 2.0 document does not honour, so the aligned specification had no server.
- **Updated**: `"host": "localhost:8080"` and `"basePath": "/v1"` (the `https` scheme was already declared), giving the server URL `https://localhost:8080/v1`.
- **Reason**: Gives the generated client a usable default `serviceUrl`; callers override it for their own Weaviate instance.

3. Make operation summaries unique
- **Original**: Nine summaries were shared by a deprecated `/objects/{id}...` or `/authz/...` operation and its replacement (for example `Get an object`).
- **Updated**: The deprecated operation summaries now read `Get users assigned to a role (deprecated)`, `Get roles assigned to a user (deprecated)`, `Get an object by ID`, `Delete an object by ID`, `Check if an object exists by ID`, `Patch an object by ID`, `Replace object references by object ID`, `Add an object reference by object ID` and `Delete an object reference by object ID`.
- **Reason**: Every operation needs a distinct summary so that the generated method documentation is unambiguous.

4. Add descriptions to 18 request bodies
- **Original**: The inline request bodies of `/replication/replicate` (POST), `/replication/replicate/force-delete`, `/experimental/import-db-users`, `/users/db/{userId}` (POST), `/users/db/{userId}/deactivate`, `/authz/roles` (POST), `/authz/roles/{id}/add-permissions`, `/authz/roles/{id}/remove-permissions`, `/authz/users/{id}/assign`, `/authz/users/{id}/revoke`, `/authz/groups/{id}/assign`, `/authz/groups/{id}/revoke`, `/tokenize`, `/schema/{className}/properties/{propertyName}/index/{indexName}` (PUT), `/schema/{className}/properties/{propertyName}/tokenize`, `/aliases` (POST), `/aliases/{aliasName}` (PUT) and `/export/{backend}` (POST) had no description.
- **Updated**: Each now has a short description of the submitted payload.
- **Reason**: Documentation for the generated `payload` parameter.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json --mode client --license docs/license.txt -o ballerina --client-methods remote
```

Note: The license year is hardcoded to 2024, change if necessary.
