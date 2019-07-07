import UIKit
import GrowingTextView

protocol ReplyUI: UI {
    var cancelBtn: UIBarButtonItem { get }
    var expandBtn: UIBarButtonItem { get }
    var textViewBottomConstraint: NSLayoutConstraint { get set }
    var comment: UITableView { get set }
    var replyTable: UITableView { get set }
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
    
    var comment: UITableView = {
        let table = UITableView()
        table.backgroundColor = .appMainColor
        table.separatorColor = .appCoolGrey
        table.separatorInset = .zero
        table.estimatedRowHeight = 400
        table.isUserInteractionEnabled = false
        table.rowHeight = UITableView.automaticDimension
        table.register(CommentCell.self, forCellReuseIdentifier: String(describing: CommentCell.self))
        return table
    }()
    
    var replyTable: UITableView = {
        let table = UITableView()
        table.backgroundView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        table.backgroundView?.alpha = 0.1
        table.backgroundView?.clipsToBounds = true
        table.backgroundView?.contentMode = UIView.ContentMode.scaleAspectFit
        table.backgroundColor = .appMainColor
        table.separatorColor = .appCoolGrey
        table.tableFooterView = UIView()
        table.register(ReplyCell.self, forCellReuseIdentifier: String(describing: ReplyCell.self))
        return table
    }()
    
    var inputToolBar: UIView = {
        let view = UIView()
        view.backgroundColor = .tabbarColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var replyField: GrowingTextView = {
        let textView = GrowingTextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .appSubColor
        textView.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        textView.layer.cornerRadius = 5
        textView.trimWhiteSpaceWhenEndEditing = true
        textView.placeholder = "リプライを記入"
        textView.placeholderColor = UIColor(white: 0.8, alpha: 1.0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var replyFieldTextCount: UILabel = {
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
}
