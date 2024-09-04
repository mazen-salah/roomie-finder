import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get data from a collection
  Future<List<Map<String, dynamic>>> getCollectionData({
    required String collectionPath,
    Query<Map<String, dynamic>>? Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(Map<String, dynamic> a, Map<String, dynamic> b)? sort,
    int limit = 20,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);

      if (queryBuilder != null) {
        query = queryBuilder(query)!;
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await query.limit(limit).get();
      List<Map<String, dynamic>> data =
          querySnapshot.docs.map((doc) => doc.data()).toList();

      if (sort != null) {
        data.sort(sort);
      }

      return data;
    } catch (e) {
      rethrow;
    }
  }

  // Get data from a sub-collection
  Future<List<Map<String, dynamic>>> getSubCollectionData({
    required String collectionPath,
    required String docId,
    required String subCollectionPath,
    Query<Map<String, dynamic>>? Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(Map<String, dynamic> a, Map<String, dynamic> b)? sort,
    int limit = 20,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection(collectionPath)
          .doc(docId)
          .collection(subCollectionPath);

      if (queryBuilder != null) {
        query = queryBuilder(query)!;
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await query.limit(limit).get();
      List<Map<String, dynamic>> data =
          querySnapshot.docs.map((doc) => doc.data()).toList();

      if (sort != null) {
        data.sort(sort);
      }

      return data;
    } catch (e) {
      rethrow;
    }
  }

  // Filter and sort data example
  Query<Map<String, dynamic>> exampleFilterAndSort(
      Query<Map<String, dynamic>> query) {
    return query
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true);
  }

  // Example: Get collection with filtering and sorting
  Future<List<Map<String, dynamic>>> getActiveItems(String collectionPath) {
    return getCollectionData(
      collectionPath: collectionPath,
      queryBuilder: exampleFilterAndSort,
    );
  }

  // Get a document by ID
  Future<Map<String, dynamic>?> getDocumentById({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection(collectionPath).doc(docId).get();
      return doc.data();
    } catch (e) {
      rethrow;
    }
  }

  // Add a document to a collection
  Future<void> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).add(data);
    } catch (e) {
      rethrow;
    }
  }

  // Update a document
  Future<void> updateDocument({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // Delete a document
  Future<void> deleteDocument({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
