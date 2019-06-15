import Foundation
import UIKit

enum PickerType {
    case residence
}

extension UIPickerView {
    
    static func getPickerView(type: PickerType, vc: UIViewController) -> UIPickerView {
        var pickerView = UIPickerView()
        switch type {
        case .residence:
            pickerView = ResidencePickerView()
        }
        pickerView.dataSource = vc as? UIPickerViewDataSource
        pickerView.delegate = vc as? UIPickerViewDelegate
        pickerView.backgroundColor = .white
        return pickerView
    }
}
