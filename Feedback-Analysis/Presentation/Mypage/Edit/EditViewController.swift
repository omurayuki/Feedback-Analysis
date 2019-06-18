import Foundation
import UIKit
import RxSwift
import RxCocoa

struct UpdatingItem {
    let userImage: UIImage
    let name, content, residence, birth: String
}

protocol UpdatingDelegate: class {
    func updateMypage(completion: @escaping () -> Void)
}

class EditViewController: UIViewController {
    
    var delegate: UpdatingDelegate?
    
    var imagePicker: ImagePicker?
    
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
                    self.presenter.uploadImage(self.ui.userImage.image ?? R.image.logo()!, at: .userImageRef)
                }).disposed(by: disposeBag)
            
            ui.userImageEditBtn.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.imagePicker?.present(from: self.view)
                }).disposed(by: disposeBag)
            
            Observable.of(Residence.residences)
                .bind(to: self.ui.residencePickerView.rx.itemTitles) {
                    return $1
                }.disposed(by: disposeBag)
            
            ui.residencePickerView.rx.modelSelected(String.self).asDriver()
                .drive(onNext: { str in
                    self.ui.residenceField.text = str.first
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

            NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification, object: nil)
                .subscribe(onNext: { [unowned self] notification in
                    self.ui.adjustForKeyboard(notification: notification)
                }).disposed(by: disposeBag)
            
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification, object: nil)
                .subscribe(onNext: { [unowned self] notification in
                    self.ui.adjustForKeyboard(notification: notification)
                }).disposed(by: disposeBag)
            
            presenter.isLoading
                .subscribe(onNext: { [unowned self] isLoading in
                    self.view.endEditing(true)
                    self.setIndicator(show: isLoading)
                }).disposed(by: disposeBag)
        }
    }
    
    func inject(ui: EditUI,
                presenter: EditPresenter,
                routing: EditRouting,
                disposeBag: DisposeBag,
                user: UpdatingItem,
                imagePicker: ImagePicker) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.disposeBag = disposeBag
        self.imagePicker = imagePicker
        
        self.ui.mapping(user: user)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
    }
}

extension EditViewController: EditPresenterView {
    
    func updateLoading(_ isLoading: Bool) {
        presenter.isLoading.accept(isLoading)
    }
    
    func didUploadImage(userImage: String) {
        self.validateUser(name: self.ui.nameField.text ?? "",
                          content: self.ui.contentField.text ?? "",
                          residence: self.ui.residenceField.text ?? "",
                          birth: self.ui.birthField.text ?? "",
                          account: { _name, _content, _residence, _birth in
            self.presenter.update(to: .userRef, user: Update(userImage: userImage,
                                                             name: _name,
                                                             content: _content,
                                                             residence: _residence,
                                                             birth: _birth))
        })
    }
    
    func didEditUserData() {
        delegate?.updateMypage(completion: {
            self.routing.dismiss()
        })
    }
}

extension EditViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        ui.setImage(image: image)
    }
}
