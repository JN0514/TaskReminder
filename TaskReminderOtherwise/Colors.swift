//
//  Extensions.swift
//  TaskReminderOtherwise
//
//  Created by JAYA$URYA on 08/11/23.
//

import UIKit

struct ThemeColor{
    static var shared = ThemeColor()
    
    //Property to determine, dark mode or light mode
    var isDark: Bool{
        get{
            UserDefaults.standard.bool(forKey: "isDark")
        }
        set(newValue){
            UserDefaults.standard.set(newValue, forKey: "isDark")
            UserDefaults.standard.synchronize()
        }
    }
//    let isDark = true

    var primaryBackgroundColor: UIColor{
        return isDark ? UIColor.black : UIColor.white
    }
    
    var secondaryBackgroundColor: UIColor{
        return isDark ? UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1): UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    var labelColor: UIColor{
        return isDark ? UIColor.white : UIColor.black
    }
    
    var secondaryLabelColor: UIColor{
        return isDark ? UIColor.lightText.withAlphaComponent(0.75) : UIColor.darkText.withAlphaComponent(0.75)
    }
    
    var tertiaryLabelColor: UIColor{
        return isDark ? UIColor.lightText.withAlphaComponent(0.5) : UIColor.darkText.withAlphaComponent(0.5)
    }

    var separatorColor: UIColor{
        return isDark ? UIColor.lightGray : UIColor.darkGray
    }
    
    var userInterfaceStyle: UIUserInterfaceStyle{
        return isDark ? UIUserInterfaceStyle.dark : UIUserInterfaceStyle.light
    }
}
