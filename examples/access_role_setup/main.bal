// Creates a read-only role, creates a database user and assigns the role to that user, then
// reads back the roles the user holds.

import ballerina/io;
import ballerinax/weaviate;

configurable string weaviateUrl = ?;
configurable string adminApiKey = ?;
configurable string roleName = "article-reader";
configurable string userId = ?;
configurable string collectionPattern = "Article*";
configurable boolean createUserAndAssignRole = false;

public function main() returns error? {
    weaviate:Client weaviateClient = check new ({auth: {token: adminApiKey}}, weaviateUrl);

    // Step 1: Create a role that can read the matching collections.
    check weaviateClient->createRole({
        name: roleName,
        permissions: [
            {action: "read_collections", collections: {collection: collectionPattern}},
            {action: "read_data", data: {collection: collectionPattern}}
        ]
    });
    io:println("Created role: ", roleName);

    // Step 2: Read the role back and show the permissions it holds.
    weaviate:Role role = check weaviateClient->getRole(roleName);
    io:println("Role ", role.name, " holds ", role.permissions.length(), " permission(s)");

    if !createUserAndAssignRole {
        io:println("Skipping user creation. Set createUserAndAssignRole = true to create user ", userId);
        return;
    }

    // Step 3: Create the database user. The API key is only returned once.
    weaviate:UserApiKey apiKey = check weaviateClient->createUser(userId, {});
    io:println("Created user ", userId, ". Store the API key securely: ", apiKey.apikey);

    // Step 4: Assign the role to the user.
    check weaviateClient->assignRoleToUser(userId, {roles: [roleName], userType: "db"});

    // Step 5: Confirm the roles now held by the user.
    weaviate:RolesListResponse assigned = check weaviateClient->getUserRolesByType(userId, "db");
    foreach weaviate:Role assignedRole in assigned {
        io:println("User ", userId, " holds role ", assignedRole.name);
    }
}
