//
//  FirebaseMethods.swift
//  Sense
//
//  Created by Andrea Bottino on 24/11/2023.
//


import UIKit
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
            } catch let signOutError as NSError {
                completion(.failure(signOutError))
            }
        }
    }
}

