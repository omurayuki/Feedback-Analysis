import UIKit
import GrowingTextView

protocol ReplyUI: UI {
    var cancelBtn: UIBarButtonItem { get }
    var expandBtn: UIBarButtonItem { get }
    var textViewBottomConstraint: NSLayoutConstraint { get set }
    var comment: UITableView { get }
    var replyTable: UITableView { get }
    var inputToolBar: UIView { get }
    var replyField: GrowingTextView { get }
    var replyFieldTextCount: UILabel { get }
    var submitBtn: UIButton { get }
    var viewTapGesture: UITapGestureRecognizer { get }
    
    func setup()
    func determineHeight(height: CGFloat)
    func isHiddenSubmitBtn(_ bool: Bool)
    func isHiddenTextCount(_ bool: Bool)
    func clearReplyField()
    func updateReplyCount(_ count: Int)
    func changeViewWithKeyboardY(_ bool: Bool, height: CGFloat)
}

final class ReplyUIImpl: ReplyUI {
    
    weak var viewController: UIViewController?
    
    private(set) var cancelBtn: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.title = "キャンセル"
        item.style = .plain
        return item
    }()
    
    private(set) var expandBtn: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .compose, target: nil, action: nil)
        item.style = .done
        return item
    }()
    
    var textViewBottomConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint()
        return constraint
    }()
    
    private(set) var comment: UITableView = {
        let table = UITableView.Builder()
            .estimatedRowHeight(400)
            .isUserInteractionEnabled(false)
            .build()
        table.register(CommentCell.self, forCellReuseIdentifier: String(describing: CommentCell.self))
        return table
    }()
    
    private(set) var replyTable: UITableView = {
        let table = UITableView.Builder()
            .backgroundImage(#imageLiteral(resourceName: "logo"))
            .backGroundViewContentMode(.scaleAspectFit)
            .backgroundAlpha(0.1)
            .build()
        table.register(ReplyCell.self, forCellReuseIdentifier: String(describing: ReplyCell.self))
        return table
    }()
    
    private(set) var inputToolBar: UIView = {
        let view = UIView()
        view.backgroundColor = .tabbarColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) var replyField: GrowingTextView = {
        let textView = GrowingTextView.Builder()
            .placeHolder("リプライを記入")
            .build()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private(set) var replyFieldTextCount: UILabel = {
        let label = UILabel()
        label.apply(.appMain10)
        label.isHidden = true
        return label
    }()
    
    private(set) var submitBtn: UIButton = {
        let button = UIButton.Builder()
            .title("   返信   ")
            .border(width: 1, color: UIColor.appMainColor.cgColor)
            .cornerRadius(15)
            .backgroundColor(.appSubColor)
            .component(.appSub)
            .build()
        button.isHidden = true
        return button
    }()
    
    private(set) var viewTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        return gesture
    }()
}

extension ReplyUIImpl {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.navigationItem.title = "返信"
        vc.navigationItem.leftBarButtonItem = cancelBtn
        vc.navigationItem.rightBarButtonItem = expandBtn
        vc.view.backgroundColor = .appMainColor
        [replyField, submitBtn].forEach { inputToolBar.addSubview($0) }
        vc.view.addGestureRecognizer(viewTapGesture)
        [comment, replyTable, inputToolBar, replyFieldTextCount].forEach { vc.view.addSubview($0) }
        
        comment.anchor()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .activate()
        
        replyTable.anchor()
            .top(to: comment.bottomAnchor)
            .width(to: vc.view.widthAnchor)
            .bottom(to: inputToolBar.topAnchor)
            .activate()
        
        let topConstraint = replyField.topAnchor.constraint(equalTo: inputToolBar.topAnchor, constant: 8)
        topConstraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            inputToolBar.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            inputToolBar.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            inputToolBar.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            topConstraint
        ])
        
        if #available(iOS 11, *) {
            textViewBottomConstraint = replyField.bottomAnchor.constraint(equalTo: inputToolBar.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            NSLayoutConstraint.activate([
                replyField.leadingAnchor.constraint(equalTo: inputToolBar.safeAreaLayoutGuide.leadingAnchor, constant: 8),
                replyField.trailingAnchor.constraint(equalTo: inputToolBar.safeAreaLayoutGuide.trailingAnchor, constant: -8),
                textViewBottomConstraint
            ])
        } else {
            let textViewBottomConstraint = replyField.bottomAnchor.constraint(equalTo: inputToolBar.bottomAnchor, constant: -8)
            NSLayoutConstraint.activate([
                replyField.leadingAnchor.constraint(equalTo: inputToolBar.leadingAnchor, constant: 8),
                replyField.trailingAnchor.constraint(equalTo: inputToolBar.trailingAnchor, constant: -8),
                textViewBottomConstraint
            ])
        }
        
        replyFieldTextCount.anchor()
            .top(to: replyField.bottomAnchor, constant: 10)
            .left(to: replyField.leftAnchor, constant: 2)
            .activate()
        
        submitBtn.anchor()
            .top(to: replyField.bottomAnchor, constant: 10)
            .right(to: replyField.rightAnchor, constant: -2)
            .activate()
    }
    
    func determineHeight(height: CGFloat) {
        comment.anchor()
            .height(constant: height)
            .activate()
    }
    
    func isHiddenSubmitBtn(_ bool: Bool) {
        UIView.Animator(duration: 1.0)
            .animations {
                self.submitBtn.isHidden = bool
            }.animate()
    }
    
    func isHiddenTextCount(_ bool: Bool) {
        UIView.Animator(duration: 1.0)
            .animations {
                self.replyFieldTextCount.isHidden = bool
            }.animate()
    }
    
    func clearReplyField() {
        UIView.Animator(duration: 2.0)
            .animations {
                self.replyField.text = ""
            }.animate()
    }
    
    func updateReplyCount(_ count: Int) {
        let indexPath = NSIndexPath(row: 0, section: 0)
        guard let cell = comment.cellForRow(at: indexPath as IndexPath) as? CommentCell else { return }
        cell.repliedCount.text = "\(count)"
    }
    
    func changeViewWithKeyboardY(_ bool: Bool, height: CGFloat) {
        guard let vc = viewController else { return }
        vc.view.addGestureRecognizer(viewTapGesture)
        isHiddenSubmitBtn(bool)
        isHiddenTextCount(bool)
        textViewBottomConstraint.constant = -(height) - 8
        vc.view.layoutIfNeeded()
    }
}
