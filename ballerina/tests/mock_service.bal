// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

listener http:Listener ep0 = new (9090);

service / on ep0 {
    # Delete objects in batch
    #
    # + consistencyLevel - Determines how many replicas must acknowledge a request before it is considered successful
    # + tenant - Specifies the tenant in a request targeting a multi-tenant collection (class)
    # + payload - The request body containing the match filter and output configuration 
    # + return - returns can be any of following types 
    # http:Ok (Request processed successfully. See response body for matching objects and deletion results)
    # http:BadRequest (Malformed request.)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:UnprocessableEntity (Invalid data provided. Please check the values in your request (e.g., invalid filter).)
    # http:InternalServerError (An error occurred while trying to fulfill the request. Check the ErrorResponse for details.)
    resource function delete batch/objects(@http:Query {name: "consistency_level"} string? consistencyLevel, string? tenant, @http:Payload BatchDelete payload) returns BatchDeleteResponse|ErrorResponseBadRequest|http:Unauthorized|ErrorResponseForbidden|ErrorResponseUnprocessableEntity|ErrorResponseInternalServerError {
        BatchDeleteResponse resp = {output: "minimal", dryRun: false, 'match: {'class: "Article"}, results: {matches: 2, 'limit: 10000, successful: 2, failed: 0}};
        return resp;
    }

    # Delete an object
    #
    # + className - Name of the collection (class) the object belongs to
    # + id - Unique UUID of the object to be deleted
    # + consistencyLevel - Determines how many replicas must acknowledge a request before it is considered successful
    # + tenant - Specifies the tenant in a request targeting a multi-tenant collection (class)
    # + return - returns can be any of following types 
    # http:NoContent (Object deleted successfully)
    # http:BadRequest (Malformed request.)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:NotFound (Object not found.)
    # http:UnprocessableEntity (The request syntax is correct, but the server couldn't process it due to semantic issues. Please check the values in your request.)
    # http:InternalServerError (An error occurred while trying to fulfill the request. Check the ErrorResponse for details.)
    resource function delete objects/[string className]/[string id](@http:Query {name: "consistency_level"} string? consistencyLevel, string? tenant) returns http:NoContent|ErrorResponseBadRequest|http:Unauthorized|ErrorResponseForbidden|http:NotFound|ErrorResponseUnprocessableEntity|ErrorResponseInternalServerError {
        return http:NO_CONTENT;
    }

    # Delete a collection (and all associated data)
    #
    # + className - The name of the collection (class) to delete
    # + return - returns can be any of following types 
    # http:Ok (Collection deleted successfully)
    # http:BadRequest (Could not delete the collection. See the error response for details.)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:InternalServerError (An error occurred during collection deletion. Check the ErrorResponse for details.)
    resource function delete schema/[string className]() returns http:Ok|ErrorResponseBadRequest|http:Unauthorized|ErrorResponseForbidden|ErrorResponseInternalServerError {
        return http:OK;
    }

    # List aliases
    #
    # + 'class - Optional filter to retrieve aliases for a specific collection (class) only. If not provided, returns all aliases
    # + return - returns can be any of following types 
    # http:Ok (Successfully retrieved the list of aliases)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:UnprocessableEntity (Invalid collection (class) parameter provided)
    # http:InternalServerError (An error has occurred while trying to fulfill the request. Most likely the ErrorResponse will contain more information about the error.)
    resource function get aliases(string? 'class) returns AliasResponse|http:Unauthorized|ErrorResponseForbidden|ErrorResponseUnprocessableEntity|ErrorResponseInternalServerError {
        AliasResponse resp = {aliases: [{alias: "ArticlesProd", 'class: "Article"}]};
        return resp;
    }

    # Get all roles
    #
    # + return - returns can be any of following types 
    # http:Ok (Successful response)
    # http:BadRequest (Malformed request.)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:InternalServerError (An error has occurred while trying to fulfill the request. Most likely the ErrorResponse will contain more information about the error.)
    resource function get authz/roles() returns RolesListResponse|ErrorResponseBadRequest|http:Unauthorized|ErrorResponseForbidden|ErrorResponseInternalServerError {
        RolesListResponse roles = [{name: "admin", permissions: [{action: "read_collections", collections: {collection: "*"}}]}];
        return roles;
    }

    # Get instance metadata
    #
    # + return - returns can be any of following types 
    # http:Ok (Successfully retrieved meta information)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:InternalServerError (An internal server error occurred while retrieving meta information. Check the ErrorResponse for details.)
    resource function get meta() returns Meta|http:Unauthorized|ErrorResponseForbidden|ErrorResponseInternalServerError {
        Meta meta = {hostname: "http://[::]:8080", version: "1.30.0", grpcMaxMessageSize: 10485760, modules: {}};
        return meta;
    }

    # Get node status
    #
    # + output - Controls the verbosity of the output, possible values are: `minimal`, `verbose`. Defaults to `minimal`
    # + return - returns can be any of following types 
    # http:Ok (Successfully retrieved the status for all nodes)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:NotFound (Not Found.)
    # http:UnprocessableEntity (Invalid request for node status.)
    # http:InternalServerError (An internal server error occurred while retrieving node status. Check the ErrorResponse for details.)
    resource function get nodes(string output = "minimal") returns NodesStatusResponse|http:Unauthorized|ErrorResponseForbidden|ErrorResponseNotFound|ErrorResponseUnprocessableEntity|ErrorResponseInternalServerError {
        NodesStatusResponse resp = {nodes: [{name: "node1", status: "HEALTHY", version: "1.30.0", gitHash: "a1b2c3d", operationalMode: "ReadWrite", stats: {objectCount: 100, shardCount: 1}}]};
        return resp;
    }

    # List objects
    #
    # + after - A threshold UUID of the objects to retrieve after, using an UUID-based ordering. This object is not part of the set. 
    # Must be used with collection name (`class`), typically in conjunction with `limit`. 
    # Note `after` cannot be used with `offset` or `sort`. 
    # For a null value similar to offset=0, set an empty string in the request, i.e. `after=` or `after`
    # + offset - The starting index of the result window. Note `offset` will retrieve `offset+limit` results and return `limit` results from the object with index `offset` onwards. Limited by the value of `QUERY_MAXIMUM_RESULTS`. 
    # Should be used in conjunction with `limit`. 
    # Cannot be used with `after`
    # + 'limit - The maximum number of items to be returned per page. The default is 25 unless set otherwise as an environment variable
    # + include - Include additional information, such as classification information. Allowed values include: `classification`, `vector` and `interpretation`
    # + sort - Name(s) of the property to sort by - e.g. `city`, or `country,city`
    # + 'order - Order parameter to tell how to order (asc or desc) data within given field. Should be used in conjunction with `sort` parameter. If providing multiple `sort` values, provide multiple `order` values in corresponding order, e.g.: `sort=author_name,title&order=desc,asc`
    # + 'class - The collection from which to query objects.  
    # Note that if the collection name (`class`) is not provided, the response will not include any objects
    # + tenant - Specifies the tenant in a request targeting a multi-tenant collection (class)
    # + return - returns can be any of following types 
    # http:Ok (Successful response containing the list of objects. If the collection name (`class`) is not provided, the response will not include any objects)
    # http:BadRequest (Malformed request.)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:NotFound (Successful query result but no matching objects were found.)
    # http:Gone (Endpoint not available in the current cluster configuration.)
    # http:UnprocessableEntity (The request syntax is correct, but the server couldn't process it due to semantic issues. Please check the values in your request. Ensure the specified collection exists.)
    # http:InternalServerError (An error occurred while trying to fulfill the request. Check the ErrorResponse for details.)
    resource function get objects(string? after, int? 'limit, string? include, string? sort, string? 'order, string? 'class, string? tenant, int offset = 0) returns ObjectsListResponse|ErrorResponseBadRequest|http:Unauthorized|ErrorResponseForbidden|http:NotFound|ErrorResponseGone|ErrorResponseUnprocessableEntity|ErrorResponseInternalServerError {
        ObjectsListResponse resp = {totalResults: 1, objects: [mockObject("Article", "5b6a08ba-1d46-43aa-89cc-8b070790c6f2")]};
        return resp;
    }

    # Get an object
    #
    # + className - Name of the collection (class) the object belongs to
    # + id - Unique UUID of the object to be retrieved
    # + include - Include additional information, such as classification information. Allowed values include: `classification`, `vector` and `interpretation`
    # + consistencyLevel - Determines how many replicas must acknowledge a request before it is considered successful
    # + nodeName - The target node which should fulfill the request
    # + tenant - Specifies the tenant in a request targeting a multi-tenant collection (class)
    # + return - returns can be any of following types 
    # http:Ok (Successful response containing the object)
    # http:BadRequest (Malformed request.)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:NotFound (Object not found.)
    # http:UnprocessableEntity (The request syntax is correct, but the server couldn't process it due to semantic issues. Please check the values in your request.)
    # http:InternalServerError (An error occurred while trying to fulfill the request. Check the ErrorResponse for details.)
    resource function get objects/[string className]/[string id](string? include, @http:Query {name: "consistency_level"} string? consistencyLevel, @http:Query {name: "node_name"} string? nodeName, string? tenant) returns WeaviateObject|ErrorResponseBadRequest|http:Unauthorized|ErrorResponseForbidden|http:NotFound|ErrorResponseUnprocessableEntity|ErrorResponseInternalServerError {
        return mockObject(className, id);
    }

    # Get all collection definitions
    #
    # + consistency - If true, the request is proxied to the cluster leader to ensure strong schema consistency. Default is true
    # + return - returns can be any of following types 
    # http:Ok (Successfully retrieved the database schema)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:InternalServerError (An error occurred while retrieving the schema. Check the ErrorResponse for details.)
    resource function get schema(@http:Header boolean? consistency = true) returns Schema|http:Unauthorized|ErrorResponseForbidden|ErrorResponseInternalServerError {
        Schema schema = {classes: [mockCollection("Article")], name: "weaviate", maintainer: "hello@weaviate.io"};
        return schema;
    }

    # Get a single collection
    #
    # + className - The name of the collection (class) to retrieve
    # + consistency - If true, the request is proxied to the cluster leader to ensure strong schema consistency. Default is true
    # + return - returns can be any of following types 
    # http:Ok (Successfully retrieved the collection definition)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:NotFound (Collection not found.)
    # http:UnprocessableEntity (Invalid collection name provided (e.g. malformed namespace prefix). Check the ErrorResponse for details.)
    # http:InternalServerError (An error occurred while retrieving the collection definition. Check the ErrorResponse for details.)
    resource function get schema/[string className](@http:Header boolean? consistency = true) returns Collection|http:Unauthorized|ErrorResponseForbidden|http:NotFound|ErrorResponseUnprocessableEntity|ErrorResponseInternalServerError {
        return mockCollection(className);
    }

    # Get the list of tenants
    #
    # + className - The name of the collection (class) whose tenants to list
    # + consistency - If true, the request is proxied to the cluster leader to ensure strong schema consistency. Default is true
    # + return - returns can be any of following types 
    # http:Ok (Successfully retrieved tenants)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:UnprocessableEntity (Invalid request.)
    # http:InternalServerError (An error occurred while listing tenants. Check the ErrorResponse for details.)
    resource function get schema/[string className]/tenants(@http:Header boolean? consistency = true) returns Tenant[]|http:Unauthorized|ErrorResponseForbidden|ErrorResponseUnprocessableEntity|ErrorResponseInternalServerError {
        Tenant[] tenants = [{name: "tenantA", activityStatus: "ACTIVE"}, {name: "tenantB", activityStatus: "INACTIVE"}];
        return tenants;
    }

    # List all users
    #
    # + includeLastUsedTime - Whether to include the last time the users were utilized
    # + return - returns can be any of following types 
    # http:Ok (Info about the users)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:InternalServerError (An error has occurred while trying to fulfill the request. Most likely the ErrorResponse will contain more information about the error.)
    resource function get users/db(boolean includeLastUsedTime = false) returns DBUserInfo[]|http:Unauthorized|ErrorResponseForbidden|ErrorResponseInternalServerError {
        DBUserInfo[] users = [{userId: "alice", roles: ["admin"], dbUserType: "db_user", active: true, createdAt: "2026-01-01T00:00:00Z"}];
        return users;
    }

    # Patch an object
    #
    # + className - Name of the collection (class) the object belongs to
    # + id - Unique UUID of the object to be patched
    # + consistencyLevel - Determines how many replicas must acknowledge a request before it is considered successful
    # + payload - RFC 7396-style JSON merge patch object containing the fields to update 
    # + return - returns can be any of following types 
    # http:NoContent (Object patched successfully)
    # http:BadRequest (Malformed patch request body.)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:NotFound (Object not found.)
    # http:UnprocessableEntity (The patch object is valid JSON but is unprocessable for other reasons (e.g., invalid schema).)
    # http:InternalServerError (An error occurred while trying to fulfill the request. Check the ErrorResponse for details.)
    resource function patch objects/[string className]/[string id](@http:Query {name: "consistency_level"} string? consistencyLevel, @http:Payload WeaviateObject payload) returns http:NoContent|ErrorResponseBadRequest|http:Unauthorized|ErrorResponseForbidden|http:NotFound|ErrorResponseUnprocessableEntity|ErrorResponseInternalServerError {
        return http:NO_CONTENT;
    }

    # Create a new alias
    #
    # + payload - Alias name and the collection it should point to 
    # + return - returns can be any of following types 
    # http:Ok (Successfully created a new alias for the specified collection (class))
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:UnprocessableEntity (Invalid create alias request.)
    # http:InternalServerError (An error has occurred while trying to fulfill the request. Most likely the ErrorResponse will contain more information about the error.)
    resource function post aliases(@http:Payload Alias payload) returns AliasOk|http:Unauthorized|ErrorResponseForbidden|ErrorResponseUnprocessableEntity|ErrorResponseInternalServerError {
        AliasOk resp = {body: payload};
        return resp;
    }

    # Create new role
    #
    # + payload - Role name and the permissions granted to the new role 
    # + return - returns can be any of following types 
    # http:Created (Role created successfully)
    # http:BadRequest (Malformed request.)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:Conflict (Role already exists.)
    # http:UnprocessableEntity (The request syntax is correct, but the server couldn't process it due to semantic issues. Please check the values in your request.)
    # http:InternalServerError (An error has occurred while trying to fulfill the request. Most likely the ErrorResponse will contain more information about the error.)
    resource function post authz/roles(@http:Payload Role payload) returns http:Created|ErrorResponseBadRequest|http:Unauthorized|ErrorResponseForbidden|ErrorResponseConflict|ErrorResponseUnprocessableEntity|ErrorResponseInternalServerError {
        return http:CREATED;
    }

    # Create objects in batch
    #
    # + consistencyLevel - Determines how many replicas must acknowledge a request before it is considered successful
    # + payload - The request body containing the objects to be created 
    # + return - returns can be any of following types 
    # http:Ok (Request processed successfully. Individual object statuses are provided in the response body)
    # http:BadRequest (Malformed request.)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:UnprocessableEntity (The request syntax is correct, but the server couldn't process it due to semantic issues. Please check the values in your request. Ensure the collection exists and the object properties are valid.)
    # http:TooManyRequests (The configured object-count usage limit was exceeded. The whole batch is rejected (no partial fill); the client decides what to retry. See `UsageLimitExceededResponse` for the limit value.)
    # http:InternalServerError (An error occurred while trying to fulfill the request. Check the ErrorResponse for details.)
    resource function post batch/objects(@http:Query {name: "consistency_level"} string? consistencyLevel, @http:Payload BatchObjectsBody payload) returns ObjectsGetResponseArrayOk|ErrorResponseBadRequest|http:Unauthorized|ErrorResponseForbidden|ErrorResponseUnprocessableEntity|UsageLimitExceededResponseTooManyRequests|ErrorResponseInternalServerError {
        ObjectsGetResponse item = {id: "5b6a08ba-1d46-43aa-89cc-8b070790c6f2", 'class: "Article", properties: {"title": "Hello Weaviate"}, result: {status: "SUCCESS"}};
        ObjectsGetResponseArrayOk resp = {body: [item]};
        return resp;
    }

    # Perform a GraphQL query
    #
    # + payload - The GraphQL query to execute, including the query string and optional variables 
    # + return - returns can be any of following types 
    # http:Ok (Query executed successfully. The response body contains the query result)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:Gone (Endpoint not available in the current cluster configuration.)
    # http:UnprocessableEntity (The request syntax is correct, but the server couldn't process it due to semantic issues. Please check the values in your request.)
    # http:InternalServerError (An internal server error occurred during query execution. Check the ErrorResponse for details.)
    resource function post graphql(@http:Payload GraphQLQuery payload) returns GraphQLResponseOk|http:Unauthorized|ErrorResponseForbidden|ErrorResponseGone|ErrorResponseUnprocessableEntity|ErrorResponseInternalServerError {
        GraphQLResponseOk resp = {body: {data: {"Get": {"Article": [{"title": "Hello Weaviate"}]}}}};
        return resp;
    }

    # Create an object
    #
    # + consistencyLevel - Determines how many replicas must acknowledge a request before it is considered successful
    # + payload - The object to be created 
    # + return - returns can be any of following types 
    # http:Ok (Object created successfully)
    # http:BadRequest (Malformed request.)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:UnprocessableEntity (The request syntax is correct, but the server couldn't process it due to semantic issues. Please check the values in your request. Ensure the collection exists and the object properties are valid.)
    # http:TooManyRequests (The configured object-count usage limit was exceeded. See `UsageLimitExceededResponse` for the limit value.)
    # http:InternalServerError (An error occurred while trying to fulfill the request. Check the ErrorResponse for details.)
    resource function post objects(@http:Query {name: "consistency_level"} string? consistencyLevel, @http:Payload WeaviateObject payload) returns WeaviateObjectOk|ErrorResponseBadRequest|http:Unauthorized|ErrorResponseForbidden|ErrorResponseUnprocessableEntity|UsageLimitExceededResponseTooManyRequests|ErrorResponseInternalServerError {
        WeaviateObject obj = payload.clone();
        obj.id = "5b6a08ba-1d46-43aa-89cc-8b070790c6f2";
        WeaviateObjectOk resp = {body: obj};
        return resp;
    }

    # Validate an object
    #
    # + payload - The object definition to validate 
    # + return - returns can be any of following types 
    # http:Ok (Object is valid according to the schema)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:UnprocessableEntity (Request body is well-formed but the object is invalid according to the schema.)
    # http:InternalServerError (An error occurred while trying to fulfill the request. Check the ErrorResponse for details.)
    resource function post objects/validate(@http:Payload WeaviateObject payload) returns http:Ok|http:Unauthorized|ErrorResponseForbidden|ErrorResponseUnprocessableEntity|ErrorResponseInternalServerError {
        return http:OK;
    }

    # Create a new collection
    #
    # + payload - The definition of the collection (class) to create 
    # + return - returns can be any of following types 
    # http:Ok (Collection created successfully and its definition returned)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:UnprocessableEntity (Invalid collection definition provided. Check the definition structure and properties.)
    # http:TooManyRequests (A configured usage limit (collections/shards) was exceeded. See the `UsageLimitExceededResponse` body for which limit and the configured value.)
    # http:InternalServerError (An error occurred during collection creation. Check the ErrorResponse for details.)
    resource function post schema(@http:Payload Collection payload) returns CollectionOk|http:Unauthorized|ErrorResponseForbidden|RestrictionViolationResponseUnprocessableEntity|UsageLimitExceededResponseTooManyRequests|ErrorResponseInternalServerError {
        CollectionOk resp = {body: payload};
        return resp;
    }

    # Add a property to a collection
    #
    # + className - The name of the collection (class) to add the property to
    # + payload - The definition of the property to add 
    # + return - returns can be any of following types 
    # http:Ok (Property added successfully and its definition returned)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:UnprocessableEntity (Invalid property definition provided.)
    # http:InternalServerError (An error occurred while adding the property. Check the ErrorResponse for details.)
    resource function post schema/[string className]/properties(@http:Payload Property payload) returns PropertyOk|http:Unauthorized|ErrorResponseForbidden|RestrictionViolationResponseUnprocessableEntity|ErrorResponseInternalServerError {
        PropertyOk resp = {body: payload};
        return resp;
    }

    # Create a new tenant
    #
    # + className - The name of the multi-tenant enabled collection (class)
    # + payload - An array of tenant objects to create 
    # + return - returns can be any of following types 
    # http:Ok (Tenants created successfully)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:UnprocessableEntity (Invalid request.)
    # http:TooManyRequests (The configured tenant-per-collection usage limit was exceeded. See `UsageLimitExceededResponse` for the limit value.)
    # http:InternalServerError (An error occurred while creating tenants. Check the ErrorResponse for details.)
    resource function post schema/[string className]/tenants(@http:Payload Tenant[] payload) returns TenantArrayOk|http:Unauthorized|ErrorResponseForbidden|ErrorResponseUnprocessableEntity|UsageLimitExceededResponseTooManyRequests|ErrorResponseInternalServerError {
        TenantArrayOk resp = {body: payload};
        return resp;
    }

    # Search a collection with hybrid
    #
    # + collection - The name (or alias) of the collection to search. A lowercase first letter is normalized to the canonical uppercase form
    # + payload - The hybrid search request 
    # + return - returns can be any of following types 
    # http:Ok (Search performed successfully)
    # http:BadRequest (An invalid parameter value (e.g. empty query, alpha outside [0, 1], negative paging, unknown property) or an unparseable request body.)
    # http:Unauthorized (Unauthorized or invalid credentials.)
    # http:Forbidden (Forbidden)
    # http:NotFound (Unknown collection or tenant.)
    # http:PayloadTooLarge (The request body exceeded the 4194304 byte (4 MiB) limit.)
    # http:UnprocessableEntity (Either a request-schema violation (a missing or null required `query`, or an invalid enum value), or a well-formed request that cannot run: no vectorizer module is configured for the collection while `alpha` is above 0, targetVector is missing on a multi-named-vector collection, a queried property has no searchable index, a reserved (not yet supported) parameter is present, the tenant usage does not match the collection's multi-tenancy configuration, or a where filter targets a property whose inverted index is disabled.)
    # http:TooManyRequests (The server's query rate limit was reached; retry later.)
    # http:InternalServerError (An error has occurred while trying to fulfill the request, including a failure of the embedding provider to vectorize the query for the vector part of the search. Most likely the ErrorResponse will contain more information about the error.)
    # http:ServiceUnavailable (The server is in an operational mode that blocks searches (e.g. WRITE_ONLY); retry once the server returns to normal operation.)
    resource function post search/[string collection]/hybrid(@http:Payload SearchHybridRequest payload) returns SearchResponseOk|ErrorResponseBadRequest|ErrorResponseUnauthorized|ErrorResponseForbidden|ErrorResponseNotFound|ErrorResponsePayloadTooLarge|ErrorResponseUnprocessableEntity|ErrorResponseTooManyRequests|ErrorResponseInternalServerError|ErrorResponseServiceUnavailable {
        return mockSearchResponse();
    }

    resource function post search/[string collection]/near\-text(@http:Payload SearchNearTextRequest payload) returns SearchResponseOk|ErrorResponseBadRequest|ErrorResponseUnauthorized|ErrorResponseForbidden|ErrorResponseNotFound|ErrorResponsePayloadTooLarge|ErrorResponseUnprocessableEntity|ErrorResponseTooManyRequests|ErrorResponseInternalServerError|ErrorResponseServiceUnavailable {
        return mockSearchResponse();
    }
}

// Service-mode response types. `bal openapi --mode client` collapses 4XX/5XX
// to `error` and never emits these, so they are defined here for the mock only.
public type AliasOk record {|
    *http:Ok;
    Alias body;
|};

public type CollectionOk record {|
    *http:Ok;
    Collection body;
|};

public type ErrorResponseBadRequest record {|
    *http:BadRequest;
    ErrorResponse body;
|};

public type ErrorResponseConflict record {|
    *http:Conflict;
    ErrorResponse body;
|};

public type ErrorResponseForbidden record {|
    *http:Forbidden;
    ErrorResponse body;
|};

public type ErrorResponseGone record {|
    *http:Gone;
    ErrorResponse body;
|};

public type ErrorResponseInternalServerError record {|
    *http:InternalServerError;
    ErrorResponse body;
|};

public type ErrorResponseNotFound record {|
    *http:NotFound;
    ErrorResponse body;
|};

public type ErrorResponsePayloadTooLarge record {|
    *http:PayloadTooLarge;
    ErrorResponse body;
|};

public type ErrorResponseServiceUnavailable record {|
    *http:ServiceUnavailable;
    ErrorResponse body;
|};

public type ErrorResponseTooManyRequests record {|
    *http:TooManyRequests;
    ErrorResponse body;
|};

public type ErrorResponseUnauthorized record {|
    *http:Unauthorized;
    ErrorResponse body;
|};

public type ErrorResponseUnprocessableEntity record {|
    *http:UnprocessableEntity;
    ErrorResponse body;
|};

public type GraphQLResponseOk record {|
    *http:Ok;
    GraphQLResponse body;
|};

public type ObjectsGetResponseArrayOk record {|
    *http:Ok;
    ObjectsGetResponse[] body;
|};

public type PropertyOk record {|
    *http:Ok;
    Property body;
|};

public type RestrictionViolationResponseUnprocessableEntity record {|
    *http:UnprocessableEntity;
    RestrictionViolationResponse body;
|};

public type SearchResponseOk record {|
    *http:Ok;
    SearchResponse body;
|};

public type TenantArrayOk record {|
    *http:Ok;
    Tenant[] body;
|};

public type UsageLimitExceededResponseTooManyRequests record {|
    *http:TooManyRequests;
    UsageLimitExceededResponse body;
|};

public type WeaviateObjectOk record {|
    *http:Ok;
    WeaviateObject body;
|};

# Returned with HTTP 422 from class create/update endpoints. For restriction violations (operator-disallowed config via ALLOWED_VECTOR_INDEX_TYPES or ALLOWED_COMPRESSION_TYPES) the structured fields (`errorCode`, `restriction`, `value`, `allowed`, `message`) are populated; the `message` text is rendered from the operator-overridable `RESTRICTIONS_ERROR_MESSAGE` template. For unrelated 422 errors the `error` array is populated (matching the legacy ErrorResponse shape) and the structured fields are omitted
public type RestrictionViolationResponse record {
    # The operator-configured allow-list
    string[] allowed?;
    # Which restriction was violated
    "vector_index_type"|"compression" restriction?;
    # Machine-stable identifier. Set to `CONFIG_NOT_ALLOWED` for restriction violations; omitted otherwise
    "CONFIG_NOT_ALLOWED" errorCode?;
    # Legacy ErrorResponse-style error list, populated for non-restriction 422 errors
    ErrorResponseError[] 'error?;
    # Human-readable message rendered from the `RESTRICTIONS_ERROR_MESSAGE` template with `{restriction}`, `{value}`, `{allowed}` placeholders substituted
    string message?;
    # The disallowed value the client submitted
    string value?;
};

# Returned with HTTP 429 when a configured Weaviate usage limit (objects/collections/tenants/shards) is exceeded. The structured fields (`errorCode`, `limit`, `value`) are stable contract; the `message` text is operator-overridable via the `USAGE_LIMITS_ERROR_MESSAGE` template
public type UsageLimitExceededResponse record {
    # Which limit was hit
    "objects"|"collections"|"tenants"|"shards" 'limit?;
    # Machine-stable identifier. Always `USAGE_LIMIT_EXCEEDED` for this response
    "USAGE_LIMIT_EXCEEDED" errorCode?;
    # Human-readable message rendered from the `USAGE_LIMITS_ERROR_MESSAGE` template with `{limit}` and `{value}` placeholders substituted
    string message?;
    # The configured threshold value (the cap, not the current count)
    int value?;
};

function mockObject(string className, string id) returns WeaviateObject => {
    id,
    'class: className,
    properties: {"title": "Hello Weaviate", "wordCount": 2},
    creationTimeUnix: 1760000000000,
    lastUpdateTimeUnix: 1760000000000
};

function mockCollection(string className) returns Collection => {
    'class: className,
    description: "A collection of news articles",
    vectorizer: "none",
    vectorIndexType: "hnsw",
    properties: [{name: "title", dataType: ["text"], description: "Article title"}]
};

function mockSearchResponse() returns SearchResponseOk => {
    body: {
        results: [{id: "5b6a08ba-1d46-43aa-89cc-8b070790c6f2", properties: {"title": {"value": "Hello Weaviate"}}}],
        tookMs: 4
    }
};
