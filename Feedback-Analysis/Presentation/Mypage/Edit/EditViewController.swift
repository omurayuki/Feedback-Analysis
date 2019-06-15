import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol UpdatingDelegate: class {
    func updateMypage(completion: @escaping () -> Void)
}

class EditViewController: UIViewController {
    // picker切り分け
    // [string: string] をstructに
    
    var delegate: UpdatingDelegate?
    
    var ui: EditUI!
    
    var routing: EditRouting!
    
    var presenter: EditPresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {
            ui.cancelBtn.rx.tap.asDriver()
                .drive(onNext: { _ in
                    self.routing.dismiss()
                }).disposed(by: disposeBag)
            
            ui.saveBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.validateUser(name: self.ui.nameField.text ?? "",
                                      content: self.ui.contentField.text ?? "",
                                      residence: self.ui.residenceField.text ?? "",
                                      birth: self.ui.birthField.text ?? "", account: { _name, _content, _residence, _birth in
                        self.presenter.update(to: .userRef, user: Update(name: _name,
                                                                         content: _content,
                                                                         residence: _residence,
                                                                         birth: _birth))
                    })
                }).disposed(by: disposeBag)
            
            ui.residenceDoneBtn.rx.tap
                .bind { [unowned self] _ in
                    self.ui.residenceField.resignFirstResponder()
                }.disposed(by: disposeBag)
            
            ui.datePicker.rx.controlEvent(.allEvents)
                .bind { [unowned self] _ in
                    self.ui.birthField.text = self.ui.formatter.convertToMonthAndYears(self.ui.datePicker.date)
                }.disposed(by: disposeBag)
            
            ui.viewTapGesture.rx.event
                .bind { [unowned self] _ in
                    self.view.endEditing(true)
                }.disposed(by: disposeBag)
            
            presenter.isLoading
                .subscribe(onNext: { [unowned self] isLoading in
                    self.view.endEditing(true)
                    self.setIndicator(show: isLoading)
                }).disposed(by: disposeBag)

            NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification, object: nil)
                .subscribe(onNext: { [unowned self] notification in
                    self.adjustForKeyboard(notification: notification)
                }).disposed(by: disposeBag)
            
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification, object: nil)
                .subscribe(onNext: { [unowned self] notification in
                    self.adjustForKeyboard(notification: notification)
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: EditUI,
                presenter: EditPresenter,
                routing: EditRouting,
                disposeBag: DisposeBag,
                user: [String: String]) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
        
        mapping(user: user)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        ui.setupToolBar(ui.residenceField, toolBar: ui.residenceToolBar,
                        type: .residence, content: Residence.getResidence())
    }
}

extension EditViewController: EditPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didEditUserData() {
        delegate?.updateMypage(completion: {
            self.routing.dismiss()
        })
    }
    
    func mapping(user: [String: String]) {
        ui.nameField.text = user["name"]
        ui.contentField.text = user["content"]
        ui.residenceField.text = user["residence"]
        ui.birthField.text = user["birth"]
    }
    
    func adjustForKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        } else {
            view.frame = CGRect(x: 0, y: -ui.contentField.frame.height, width: view.bounds.width, height: view.bounds.height)
        }
        ui.contentField.scrollIndicatorInsets = ui.contentField.contentInset
        
        let selectedRange = ui.contentField.selectedRange
        ui.contentField.scrollRangeToVisible(selectedRange)
    }
}

extension EditViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case is ResidencePickerView: return Residence.getResidence().count
        default: return 0
        }
    }
}

extension EditViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case is ResidencePickerView: return Residence.getResidence()[row]
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case is ResidencePickerView: ui.residenceField.text = Residence.getResidence()[row]
        default: break
        }
    }
}
