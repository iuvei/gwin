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

  func fetchPackages(userno: String, packageid: Int64? = nil, game:Int = 1) -> [NSManagedObject] {

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

    if let `packageid` = packageid {
      fetchRequest.predicate = NSPredicate(format: "userno == %@ AND packageid == %d AND game == %d", userno, packageid, game)
    } else {
      fetchRequest.predicate = NSPredicate(format: "userno == %@ AND game == %d", userno, game)
    }

    //3
    do {
      packages = try _context.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    return packages
  }

  func savePackage(userno: String, packageid: Int64, status: Bool = false, isbiggest: Bool = false, game:Int = 1) -> NSManagedObject? {

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
    package.setValue(status, forKey: "isBoom")
    package.setValue(isbiggest, forKey: "isbiggest")
    package.setValue(game, forKey: "game")
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

  func updateStatus(userno: String, packageid: Int64, status: String) {
    if let context = getContext() {

      let packages = fetchPackages(userno: userno,packageid: packageid)
      if let package = packages.first {
        package.setValue(status, forKey: "status")
      }

      do {
        try context.save()
      }catch {
        print("\(error)")
      }
    }
  }

  func isKing(userno: String, packageid: Int64) -> Bool {
    if let context = getContext() {
      var packages: [NSManagedObject] = []
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "PackageInfo")

        fetchRequest.predicate = NSPredicate(format: "userno == %@ AND packageid == %d", userno, packageid)

      //3
      do {
        packages = try context.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
      if let first = packages.first {
        return first.value(forKey: "isbiggest") as? Bool ?? false
      }
    }

    return false
  }

  func getContext() -> NSManagedObjectContext? {
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

    return managedContext
  }

}


