//
//  UserDefaultManager.swift
//  Gwin
//
//  Created by Hai Vu Van on 8/20/19.
//  Copyright © 2019 Hai Vu Van. All rights reserved.
//
import Foundation

enum SaveManagerKeys: String {
  case saveLoginInfo = "saveLoginInfo"
  case loginInfoUserName = "loginInfoUserName"
  case loginInfoPassword = "loginInfoPassword"
  case autologin = "autologin"
  case settingSound = "settingSound"
  case pupupMessage = "pupupMessage"

}

class UserDefaultManager {


  // MARK: Singleton

  private static let instance = UserDefaultManager()

  class func sharedInstance () -> UserDefaultManager {
    return instance
  }


  // MARK: Manager

  func save (object: Any?, key: SaveManagerKeys) {
    standard().setValue(object, forKey: key.rawValue)
    sync()
  }

  func get (key: SaveManagerKeys) -> Any? {
    return standard().value(forKey: key.rawValue)
  }

  func delete (key: SaveManagerKeys) {
    standard().removeObject(forKey: key.rawValue)
    sync()
  }

  func rememberLoginInfo(_ remember: Bool){
    save(object: remember, key: .saveLoginInfo)
  }

  func isRememberLoginInfo() -> Bool {
    if let value =  get(key: .saveLoginInfo) as? Bool {
      return value
    }
    //12-11
    //gia tri default la true
    return true
  }

  func autoLogin() ->Bool {
    if let autologin = get(key: .autologin) as? Bool, autologin == true , let _ = loginInfoUserName(), let _ = loginInfoPassword() {
      return true
    }

    return false
  }

  func removeAutoLogin() {
    delete(key: .autologin)
  }

  func setAutoLogin() {

  }
  
  func saveLoginInfo(accountNo: String, password: String) {
    if isRememberLoginInfo() {
      save(object: accountNo, key: .loginInfoUserName)
      save(object: password, key: .loginInfoPassword)
      save(object: true, key: .autologin)
    } else {
      removeLoginInfo()
    }
  }

  func removeLoginInfo(){
    delete(key: .saveLoginInfo)
    delete(key: .loginInfoUserName)
    delete(key: .loginInfoPassword)
  }

  func loginInfoUserName() -> String? {
    return get(key: .loginInfoUserName) as? String
  }

  func loginInfoPassword() -> String? {
    return get(key: .loginInfoPassword) as? String
  }

  //MARK: Sound

  func setSettingSound(on: Bool){
    save(object: on, key: .settingSound)
  }

  func settingSound() -> Bool {
    if let sound =  get(key: .settingSound) as? Bool {
      return sound
    }

    return false
  }

  func isShowPoupMessage() -> String? {
    if let userno =  get(key: .pupupMessage) as? String {
      return userno
    }

    return nil
  }

  func didShowPopupMessage(userno: String) {
    save(object: userno, key: .pupupMessage)
  }
  // MARK: Helpers

  func standard () -> UserDefaults {
    return UserDefaults.standard
  }

  func sync () {
    standard().synchronize()
  }
}

