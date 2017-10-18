//
//  UIViewController+CoreData.swift
//  RafaelAlessandro
//
//  Created by RafaelAlessandro on 15/10/17.
//  Copyright © 2017 ComprasUSA. All rights reserved.
//

import CoreData
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
