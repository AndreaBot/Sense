//
//  FirebaseMethods.swift
//  Sense
//
//  Created by Andrea Bottino on 24/11/2023.
//


import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct FirebaseMethods {
    
    struct Authentication {
        
        static func register(_ userEmail: String, _ userPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
            Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
        
        static func login(_ userEmail: String, _ userPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
            Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
        
        static func logout(completion: @escaping (Result<Void, Error>) -> Void) {
            do {
                try Auth.auth().signOut()
                completion(.success(()))
            } catch let signOutError {
                completion(.failure(signOutError))
            }
        }
        
        static func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
            if let user = Auth.auth().currentUser {
                user.delete { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
        
        static func sendPasswordResetEmail(to emailAddress: String, completion: @escaping (Result<Void, Error>) -> Void) {
            Auth.auth().sendPasswordReset(withEmail: emailAddress) { error in
                if let e = error {
                    completion(.failure(e))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    struct Database {
        
        static let db = Firestore.firestore()
        
        static func writeToDatabase(_ currentDate: String, _ timeOfDay: String, _ mood: String, _ userId: String, _ text1: String, _ text2: String, _ text3: String, _ text4: String, _ text5: String, _ text6: String, _ diaryText: String, completion: @escaping (Result<Void, Error>) -> Void) {
            
            db.collection(userId).document(currentDate).collection(currentDate).document(timeOfDay).setData([
                "timeOfDay": timeOfDay,
                "mood": mood,
                "txtField1": text1,
                "txtField2": text2,
                "txtField3": text3,
                "txtField4": text4,
                "txtField5": text5,
                "txtField6": text6,
                "diaryEntry": diaryText
                
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
        
        static func checkForDoc(_ timeOfDay: String, _ currentDate: String, _ userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
            let databaseContent = db.collection(userId).document(currentDate).collection(currentDate)
            let doc = databaseContent.document(timeOfDay)
            
            doc.getDocument { document , error in
                if let document = document, document.exists {
                    completion(.success(()))
                } else {
                    let genericError = NSError(domain: "YourDomain", code: 1, userInfo: nil)
                    completion(.failure(genericError))
                }
            }
        }
        
        static func getDoc(_ userId: String, _ formattedDate: String, _ buttonTitle: String, completion: @escaping (DiaryEntryModel?) -> Void) {
            let collectionRef = db.collection(userId).document(formattedDate).collection(formattedDate)
            let docRef = collectionRef.document(buttonTitle)
            
            docRef.getDocument { (documentSnapshot, error)  in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                } else {
                    let entry = createDiaryEntryModel(documentSnapshot)
                    completion(entry)
                }
            }
        }
        
        static func createDiaryEntryModel(_ docSnapshot: DocumentSnapshot?) -> DiaryEntryModel? {
            guard let data = docSnapshot?.data() else {
                return nil
            }
            
            let timeOfDay = data["timeOfDay"] as? String
            let mood = data["mood"] as? String
            let text1 = data["txtField1"] as? String
            let text2 = data["txtField2"] as? String
            let text3 = data["txtField3"] as? String
            let text4 = data["txtField4"] as? String
            let text5 = data["txtField5"] as? String
            let text6 = data["txtField6"] as? String
            let diaryText = data["diaryEntry"] as? String
            
            let entryContent = DiaryEntryModel(
                timeOfDay: timeOfDay,
                mood: mood,
                txtField1: text1,
                txtField2: text2,
                txtField3: text3,
                txtField4: text4,
                txtField5: text5,
                txtField6: text6,
                diaryText: diaryText
            )
            return entryContent
        }
        
        static func getDaysWithEvents(_ userId: String, _ date: String, completion: @escaping (Result<String, Error>) -> Void) {
            let documentRef = db.collection(userId).document(date).collection(date)
            
            documentRef.getDocuments { querySnapshot, error in
                if let e = error {
                    print(e)
                    completion(.failure(e))
                } else {
                    if querySnapshot!.documents.count > 0 {
                        completion(.success(documentRef.collectionID))
                    }
                }
            }
        }
    }
}

