// Creates a Weaviate collection, loads a batch of articles into it, lists the stored objects and
// then removes the articles that match a filter.

import ballerina/io;
import ballerinax/weaviate;

configurable string weaviateUrl = ?;
configurable string apiKey = ?;
configurable string collectionName = "Article";
configurable boolean deleteCollectionWhenDone = false;

public function main() returns error? {
    weaviate:Client weaviateClient = check new ({auth: {token: apiKey}}, weaviateUrl);

    // Step 1: Create a collection that stores vectors supplied by the caller.
    weaviate:Collection collection = check weaviateClient->createCollection({
        'class: collectionName,
        description: "News articles",
        vectorizer: "none",
        properties: [
            {name: "title", dataType: ["text"], description: "Article title"},
            {name: "wordCount", dataType: ["int"], description: "Number of words in the article"}
        ]
    });
    io:println("Created collection: ", collection?.'class);

    // Step 2: Add a property to the collection after creation.
    weaviate:Property category = check weaviateClient->addCollectionProperty(collectionName, {
        name: "category",
        dataType: ["text"],
        description: "Editorial category of the article"
    });
    io:println("Added property: ", category?.name);

    // Step 3: Load a batch of articles.
    weaviate:ObjectsGetResponse[] created = check weaviateClient->createObjectsBatch({
        objects: [
            {'class: collectionName, properties: {"title": "Vector databases explained", "wordCount": 1200, "category": "technology"}},
            {'class: collectionName, properties: {"title": "Quarterly results", "wordCount": 800, "category": "business"}}
        ]
    });
    foreach weaviate:ObjectsGetResponse item in created {
        weaviate:ObjectsGetResponseResult? outcome = item?.result;
        io:println("Stored object ", item?.id, " with status ", outcome is () ? "unknown" : outcome.status);
    }

    // Step 4: List the objects that are now stored in the collection.
    weaviate:ObjectsListResponse listing = check weaviateClient->listObjects(queries = {'class: collectionName});
    io:println("Objects in ", collectionName, ": ", listing?.totalResults);

    // Step 5: Delete the articles in the business category.
    weaviate:BatchDeleteResponse deletion = check weaviateClient->deleteObjectsBatch({
        output: "verbose",
        'match: {
            'class: collectionName,
            'where: {path: ["category"], operator: "Equal", valueText: "business"}
        }
    });
    weaviate:BatchDeleteResponseResults? results = deletion?.results;
    io:println("Deleted objects: ", results is () ? 0 : results?.successful);

    if deleteCollectionWhenDone {
        check weaviateClient->deleteCollection(collectionName);
        io:println("Deleted collection: ", collectionName);
    }
}
