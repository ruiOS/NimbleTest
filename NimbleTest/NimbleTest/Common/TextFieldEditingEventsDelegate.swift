//
//  TextFieldEditingEventsDelegate.swift
//  NimbleTest
//
//  Created by rupesh on 21/03/22.
//

import Foundation
import UIKit.UITextField

///Protocol to observe all events in textField
@objc protocol TextFieldEditingEventsDelegate{
    @objc func textFieldDidChange(_ textField: UITextField)
}

extension TextFieldEditingEventsDelegate where Self:NSObject{

    /// sets observer for editing events for the textField
    /// - Parameter textField: textField to which observer need to be set
    func setEditingEventsObserver(forTextField textField: UITextField){
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

}
