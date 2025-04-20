//
//  RealmStorage.swift
//  PokedexUIKit
//
//  Created by Elvis Susanto on 15/04/25.
//

import RealmSwift

final class RealmStorage {
    
    static let shared = RealmStorage()
    
    func store(object: Object) -> Bool {
        
        do {
            
            let realm = try Realm()
            
            try realm.write {
                realm.add(object)
            }
            
            return true
            
        } catch {
            
            print(StorageError.failedSaving)
            
            return false
            
        }
    
    }
    
    func fetch<T: Object>(ofType type: T.Type) -> [T]? {
        
        do {
            
            let realm = try Realm()
            let objects = realm.objects(type)
            return objects.map { $0 }
            
        } catch {
            
            print(StorageError.failedFetching)
            
        }
        
        return nil
        
    }
    
    func deleteSingleObject(object: Object) -> Bool {
        
        do {
            
            let realm = try Realm()
            
            try realm.write {
                realm.delete(object)
            }
            
            return true
            
        } catch {
            
            print(StorageError.failedDeleting)
            
            return false
            
        }
        
    }
    
    func deleteObjects<T: Object>(ofType type: T.Type) -> Bool {
        
        do {
            
            let realm = try Realm()
            let objects = realm.objects(type)
            
            try realm.write {
                realm.delete(objects)
            }
            
            return true
            
        } catch {
            
            print(StorageError.failedDeleting)
            
            return false
            
        }
        
    }
    
}
