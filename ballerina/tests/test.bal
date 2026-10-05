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
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? os:getEnv("WEAVIATE_URL") : "http://localhost:9090";
final string apiKey = isLiveServer ? os:getEnv("WEAVIATE_API_KEY") : "test_api_key";

final Client weaviate = check new ({auth: {token: apiKey}, httpVersion: isLiveServer ? http:HTTP_2_0 : http:HTTP_1_1}, serviceUrl);

const string OBJECT_ID = "5b6a08ba-1d46-43aa-89cc-8b070790c6f2";

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListCollections() returns error? {
    Schema response = check weaviate->listCollections();
    test:assertTrue(response?.classes is Collection[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateCollection() returns error? {
    Collection response = check weaviate->createCollection({'class: "Article", vectorizer: "none", properties: [{name: "title", dataType: ["text"]}]});
    test:assertEquals(response?.'class, "Article");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetCollection() returns error? {
    Collection response = check weaviate->getCollection("Article");
    test:assertEquals(response?.'class, "Article");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testDeleteCollection() returns error? {
    Collection created = check weaviate->createCollection({'class: "Scratch", vectorizer: "none"});
    error? response = weaviate->deleteCollection(created?.'class ?: "Scratch");
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testAddCollectionProperty() returns error? {
    Property response = check weaviate->addCollectionProperty("Article", {name: "summary", dataType: ["text"]});
    test:assertEquals(response?.name, "summary");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListObjects() returns error? {
    ObjectsListResponse response = check weaviate->listObjects();
    test:assertTrue((response?.objects ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateObject() returns error? {
    WeaviateObject response = check weaviate->createObject({'class: "Article", properties: {"title": "Hello Weaviate"}});
    test:assertTrue(response?.id !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetCollectionObject() returns error? {
    WeaviateObject response = check weaviate->getCollectionObject("Article", OBJECT_ID);
    test:assertEquals(response?.id, OBJECT_ID);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testDeleteCollectionObject() returns error? {
    WeaviateObject created = check weaviate->createObject({'class: "Article", properties: {"title": "To be deleted"}});
    error? response = weaviate->deleteCollectionObject("Article", created?.id ?: OBJECT_ID);
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testUpdateCollectionObject() returns error? {
    error? response = weaviate->updateCollectionObject("Article", OBJECT_ID, {'class: "Article", properties: {"title": "Updated"}});
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testValidateObject() returns error? {
    error? response = weaviate->validateObject({'class: "Article", properties: {"title": "Hello Weaviate"}});
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateObjectsBatch() returns error? {
    ObjectsGetResponse[] response = check weaviate->createObjectsBatch({objects: [{'class: "Article", properties: {"title": "Hello Weaviate"}}]});
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testDeleteObjectsBatch() returns error? {
    ObjectsGetResponse[] created = check weaviate->createObjectsBatch({objects: [{'class: "Article", properties: {"title": "To be deleted"}}]});
    test:assertTrue(created.length() > 0);
    BatchDeleteResponse response = check weaviate->deleteObjectsBatch({'match: {'class: "Article"}});
    test:assertTrue(response?.results is BatchDeleteResponseResults);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testExecuteGraphql() returns error? {
    GraphQLResponse response = check weaviate->executeGraphql({query: "{ Get { Article { title } } }"});
    test:assertTrue(response?.data !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetInstanceMeta() returns error? {
    Meta response = check weaviate->getInstanceMeta();
    test:assertTrue(response?.version !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListNodes() returns error? {
    NodesStatusResponse response = check weaviate->listNodes();
    test:assertTrue((response?.nodes ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testSearchNearText() returns error? {
    SearchResponse response = check weaviate->searchNearText("Article", {query: ["weaviate"]});
    test:assertTrue(response.results.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testSearchHybrid() returns error? {
    SearchResponse response = check weaviate->searchHybrid("Article", {query: "weaviate"});
    test:assertTrue(response.results.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListTenants() returns error? {
    Tenant[] response = check weaviate->listTenants("Article");
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateTenants() returns error? {
    Tenant[] response = check weaviate->createTenants("Article", [{name: "tenantC"}]);
    test:assertEquals(response.length(), 1);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListAliases() returns error? {
    AliasResponse response = check weaviate->listAliases();
    test:assertTrue((response?.aliases ?: []).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateAlias() returns error? {
    Alias response = check weaviate->createAlias({alias: "ArticlesProd", 'class: "Article"});
    test:assertEquals(response?.alias, "ArticlesProd");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListRoles() returns error? {
    RolesListResponse response = check weaviate->listRoles();
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testCreateRole() returns error? {
    error? response = weaviate->createRole({name: "reader", permissions: [{action: "read_collections", collections: {collection: "*"}}]});
    test:assertTrue(response is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListUsers() returns error? {
    DBUserInfo[] response = check weaviate->listUsers();
    test:assertTrue(response.length() > 0);
}
