//
//  NetworkManager.swift
//  FinalProject
//
//  Created by Dmitry on 3.05.22.
//

import Firebase
import UIKit
import Alamofire
import AlamofireImage
import FirebaseSharedSwift

enum Reference {
    static let auth = Auth.auth()
    static let users = Database.database().reference().child(DBCategory.users)
    static let posts = Database.database().reference().child(DBCategory.posts)
    static let photos = Storage.storage().reference().child(DBCategory.photos)
}

class NetworkManager {
    
    static func uploadPhotos(photos: [UIImage], completion: @escaping (_ result: Result<[String], Error>) -> Void) {
        
        var arrayPhotoUrl = [String]()
        
        for photo in photos {
            
            let ref = Reference.photos.child(UUID().uuidString)
            
            guard let imageData = photo.jpegData(compressionQuality: 0.4) else {
                return
            }
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            
            ref.putData(imageData, metadata: metadata) { metadata, error in
                
                if let error = error {
                    
                    completion(.failure(error))
                    
                } else if let _ = metadata {
                    
                    ref.downloadURL { (url, error) in
                        
                        if let error = error {
                            
                            completion(.failure(error))
                            
                        } else if let url = url {
                            
                            arrayPhotoUrl.append(url.absoluteString)
                            
                            if arrayPhotoUrl.count == photos.count {
                                completion(.success(arrayPhotoUrl))
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func downloadPhoto(with pathUrl: String, completion: @escaping (_ result: Result<UIImage, Error>) -> Void) {
            
//        if let image = CacheManager.shared.imageCache.image(withIdentifier: pathUrl) {
//            completion(.success(image))
//        } else {
            AF.request(pathUrl).responseImage(completionHandler: { response in
                switch response.result {
                case .success(let image): completion(.success(image))
                case .failure(let error): completion(.failure(error))
                }
            })
//        }
    }
    
    static func updateData<T: Codable>(reference: DatabaseReference, key: AnyHashable,  object: T, completion: @escaping (_ result: Result<DatabaseReference, Error>) -> Void) {

        guard let data = try? FirebaseDataEncoder().encode(object) else { return }

        reference.updateChildValues([key : data]) { error, reference in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(reference))
        }
    }
    
    static func uploadData<T: Codable>(reference: DatabaseReference, pathValues: [String], object: T, completion: @escaping (_ result: Result<DatabaseReference, Error>) -> Void) {
        
        let data = try? FirebaseDataEncoder().encode(object)
        let path = pathValues.joined(separator: "/")
        reference.child(path).setValue(data) { error, reference in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(reference))
        }
    }
    
    static func deleteData(reference: DatabaseReference, completion: @escaping (_ result: Result<DatabaseReference, Error>) -> Void) {
        reference.removeValue { error, reference in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(reference))
        }
    }
    
    static func downloadData<T: Codable>(reference: DatabaseReference, modelType: T.Type, completion: @escaping (_ result: Result<T, Error>) -> Void) {
        
        reference.getData { error, snapshot in
            if let error = error {
                completion(.failure(error))
                return
            }
           
            guard let dict = snapshot.value as? [String: Any],
                  let object = try? FirebaseDataDecoder().decode(modelType, from: dict) else {
                return
            }
            completion(.success(object))
        }
    }
    
    static func changePassword(to password: String, completion: @escaping (Error?) -> ()) {
        Reference.auth.currentUser?.updatePassword(to: password, completion: { error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        })
    }
    
    static func changeEmail(to email: String, completion: @escaping (Error?) -> ()) {
        Reference.auth.currentUser?.updateEmail(to: email, completion: { error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        })
    }
    
    static func uploadEmail() -> String? {
        guard let currentUser = Reference.auth.currentUser else { return nil }
        return currentUser.email
    }
    
    static func signOut() {
        try? Reference.auth.signOut()
    }
}
