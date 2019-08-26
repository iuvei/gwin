//
//  LocalDataManager.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/26/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import CoreData

class LocalDataManager {
  static let shared = LocalDataManager()


  init() {

  }

  func fetchPackages(userno: String) -> [NSManagedObject] {

    var packages: [NSManagedObject] = []
    //1
    guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
        return []
    }

    var managedContext: NSManagedObjectContext? = nil
    if #available(iOS 10.0, *) {
      managedContext =
        appDelegate.persistentContainer.viewContext
    } else {
      managedContext = appDelegate.managedObjectContext
    }

    guard let _context = managedContext else { return packages }
      //2
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "PackageInfo")
      fetchRequest.predicate = NSPredicate(format: "userno == %@", userno)

      //3
      do {
        packages = try _context.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }



    return packages
  }

  func savePackage(userno: String, packageid: Int64) -> NSManagedObject? {

    guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
        return nil
    }

    // 1
    var managedContext:NSManagedObjectContext? = nil
    if #available(iOS 10.0, *) {
      managedContext = appDelegate.persistentContainer.viewContext
    } else {
      managedContext = appDelegate.managedObjectContext
    }
    
    guard let _context = managedContext else { return nil }
    // 2
    let entity =
      NSEntityDescription.entity(forEntityName: "PackageInfo",
                                 in: _context)!

    let package = NSManagedObject(entity: entity,
                                 insertInto: managedContext)

    // 3
    package.setValue(userno, forKeyPath: "userno")
    package.setValue(packageid, forKeyPath: "packageid")
    package.setValue(true, forKeyPath: "isread")

    // 4
    do {
      try _context.save()
//      people.append(person)
      return package
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return nil
  }
}

