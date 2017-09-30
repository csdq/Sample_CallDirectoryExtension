//
//  ViewController.swift
//  CallDirectoryExtensionApp
//
//  Created by csdq on 2017/9/29.
//  Copyright © 2017年 iCSDQ. All rights reserved.
//

import UIKit
import CallKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let extensionIdentifer = "com.csdq.CallDirectoryExtensionApp.CallDirectoryExtension";
        if #available(iOS 10.0, *) {
            let manager : CXCallDirectoryManager = CXCallDirectoryManager.sharedInstance;
            manager.getEnabledStatusForExtension(withIdentifier: extensionIdentifer) { (status:CXCallDirectoryManager.EnabledStatus, error:Error?) in
                print("CXCallDirectoryManager status : \(status)");
                if let _ = error {
                    print("\(String(describing: error?.localizedDescription))");
                }
                if(status == CXCallDirectoryManager.EnabledStatus.enabled){
                    print("OK 可以使用")
                }
            };
            let contactList : [String:String] = [
                "17012341234":"张三",
                "17012345678":"李四",
                "17023456789":"王五"
            ]
            let blackList : [String:String] = [
                "17055667788":"骗子张",
                "17033441122":"飞贼李",
                "17022334455":"大刀王"
            ]
            //写入共享区域
//            UserDesaults测试
            let ud = UserDefaults.standard
            print(ud.value(forKey: "Test"));
            //nil
            ud.addSuite(named: "group.CSDQAppGroup");
            print(ud.value(forKey: "Test"));
            //Error
            ud.set("Standard", forKey: "Test");
            print(ud.value(forKey: "Test"))
            //OK
            let ud2 = UserDefaults.init(suiteName: "group.CSDQAppGroup")
            print(ud2?.value(forKey: "Test1"));
            //OK
            ud.setValue(contactList, forKey: "ContactList");
            ud.setValue(blackList, forKey: "BlackList");
            ud.synchronize();

            /*
             let testValue = ud.value(forKey: "Test");
             当使用不存在的键去访问时，会产生一下错误信息：
             [User Defaults] Couldn't read values in CFPrefsPlistSource<0x11bd421a0> (Domain: group.CSDQAppGroup, User: kCFPreferencesAnyUser, ByHost: Yes, Container: (null), Contents Need Refresh: Yes): Using kCFPreferencesAnyUser with a container is only allowed for System Containers, detaching from cfprefsd
             */

            manager.reloadExtension(withIdentifier: extensionIdentifer, completionHandler: { error in
                if let _ = error{
                    print("A error \(error?.localizedDescription as String!)");
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    @IBAction func openSetting(_ sender: UIButton) {
        UIApplication.shared.openURL(URL.init(string:UIApplicationOpenSettingsURLString)!)
    }
}

