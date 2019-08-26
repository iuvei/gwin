//
//  AppDelegate.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/18/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


  var window: UIWindow?
  var navigationController: UINavigationController?
  var timer: Timer?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    configureNavigator()
    let frame = UIScreen.main.bounds
    window = UIWindow(frame: frame)

    let wellcomeViewController = WellcomeViewController(nibName: "WellcomeViewController", bundle: Bundle.main)
    if let window = self.window{
      navigationController = UINavigationController(rootViewController: wellcomeViewController)
      window.rootViewController = navigationController
      window.makeKeyAndVisible()
    }
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }

  // MARK: - Core Data stack

  @available(iOS 10.0, *)
  lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "Gwin")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  lazy var applicationDocumentsDirectory: URL = {

    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.count-1]
  }()

  lazy var managedObjectModel: NSManagedObjectModel = {
    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
    let modelURL = Bundle.main.url(forResource: "Gwin", withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()

  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    // Create the coordinator and store
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.appendingPathComponent("Gwin.sqlite")
    var failureReason = "There was an error creating or loading the application's saved data."
    do {
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
    } catch {
      // Report any error we got.
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
      dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

      dict[NSUnderlyingErrorKey] = error as NSError
      let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      // Replace this with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      abort()
    }

    return coordinator
  }()

  lazy var managedObjectContext: NSManagedObjectContext = {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    let coordinator = self.persistentStoreCoordinator
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
  }()


  // MARK: - Core Data Saving support

  func saveContext () {
    if #available(iOS 10.0, *) {

      let context = persistentContainer.viewContext
      if context.hasChanges {
        do {
          try context.save()
        } catch {
          // Replace this implementation with code to handle the error appropriately.
          // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    } else  {
      // iOS 9.0 and below - however you were previously handling it
      if managedObjectContext.hasChanges {
        do {
          try managedObjectContext.save()
        } catch {
          // Replace this implementation with code to handle the error appropriately.
          // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
          let nserror = error as NSError
          NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
          abort()
        }
      }

    }


  }


  // MARK: - Utils

  public func setHomeAsRootViewControlelr() {
    if let window = self.window {
      let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
      let tabbarController = storyboard.instantiateViewController(withIdentifier: "tabbarController")

      window.rootViewController = tabbarController
      window.makeKeyAndVisible()
    }
  }

  public func setLoginViewController() {
    if let window = self.window {
      if let `navigationController` = navigationController {
        if  let viewcontroller = LoginBuilder().build(withListener: nil).viewController {
          navigationController.initRootViewController(vc: viewcontroller)
          window.rootViewController = navigationController
          window.makeKeyAndVisible()
        }
      }
    }
  }

  public func setWellcomeAsRootViewController() {
    if let window = self.window {
      let wellcomeViewController = WellcomeViewController(nibName: "WellcomeViewController", bundle: nil)
      navigationController = UINavigationController(rootViewController: wellcomeViewController)
      window.rootViewController = navigationController
    }
  }

  public func setLaunchAsRootViewController () {
    if let window = self.window {
      if let `navigationController` = navigationController {
        let viewcontroller = LaunchViewController(nibName: "LaunchViewController", bundle: nil)
        navigationController.initRootViewController(vc: viewcontroller)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
      }
    }
  }

  func configureNavigator() {
    let attrs = [
      NSAttributedString.Key.foregroundColor: UIColor(hexString: "FBEAAC"),
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)
    ]

    UINavigationBar.appearance().titleTextAttributes = attrs

    let barColor = UIColor(hexString:"e75f48")
//    UINavigationBar.appearance().backgroundColor =  barColor
    UINavigationBar.appearance().barTintColor = barColor
//    UINavigationBar.appearance().tintColor = .white

//    UIBarButtonItem.appearance().tintColor =  barColor
//    UITabBar.appearance().backgroundColor =  barColor
    UINavigationBar.appearance().isTranslucent = false
  }

  func selectTabIndex(index: TabIndex) {
    if let _window = window{
      if let tabBarController = _window.rootViewController as? UITabBarController {
        tabBarController.selectedIndex = index.rawValue
      }
    }
  }

  func startFetchUserStatus() {
    if let _ = timer {
      timer?.invalidate()
      timer = nil
    }

    timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(getUerOnline), userInfo: nil, repeats: true)
  }

  func stopFetchUserStatus() {
    if let _ = timer {
      timer?.invalidate()
      timer = nil
    }
  }

  @objc func getUerOnline() {

    guard let user = RedEnvelopComponent.shared.user else { return }

    UserAPIClient.setOnline(ticket: user.ticket, guid: user.guid) { [weak self] (onlineStatus, errorMessage) in
      if let status =  onlineStatus {
        if status == .loginOtherPlace {
          UserAPIClient.logout(ticket: user.ticket, guid: user.guid, completion: {  [weak self](success, msg) in
            if success {
              self?.setWellcomeAsRootViewController()
            }
          })
        }
      }
    }
  }
}



