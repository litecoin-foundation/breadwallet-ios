import UIKit

class ConfirmPaperPhraseViewController: UITableViewController {
    var didCompleteConfirmation: (() -> Void)?

    @IBOutlet var headerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var headerTitleLabel: UILabel!
    @IBOutlet var headerDescriptionLabel: UILabel!
    @IBOutlet var firstWordCell: ConfirmPhraseTableViewCell!
    @IBOutlet var secondWordCell: ConfirmPhraseTableViewCell!
    @IBOutlet var thirdWordCell: ConfirmPhraseTableViewCell!
    @IBOutlet var fourthWordCell: ConfirmPhraseTableViewCell!
    @IBOutlet var footerView: UIView!
    @IBOutlet var submitButton: UIButton!

    private let fourIndices: (Int, Int, Int, Int) = {
        var indexSet = Set(arrayLiteral: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
        let first = indexSet.randomElement()!
        indexSet.remove(first)
        var second = indexSet.randomElement()!
        indexSet.remove(second)
        var third = indexSet.randomElement()!
        indexSet.remove(third)
        var fourth = indexSet.randomElement()!
        return (first, second, third, fourth)
    }()

    private lazy var words: [String] = {
        guard let pin = self.pin,
            let phraseString = self.walletManager?.seedPhrase(pin: pin) else {
            NSLog("Error: Phrase string empty")
            return []
        }
        var wordArray = phraseString.components(separatedBy: " ")
        let lastWord = wordArray.last
        if let trimmed = lastWord?.replacingOccurrences(of: "\0", with: "") {
            wordArray[11] = trimmed // This end line \0 is being read as an element...removing it
        }
        return wordArray
    }()

    private lazy var confirmFirstPhrase: ConfirmPhrase = { ConfirmPhrase(text: String(format: S.ConfirmPaperPhrase.word, "\(self.fourIndices.0 + 1)"), word: self.words[self.fourIndices.0])
    }()

    private lazy var confirmSecondPhrase: ConfirmPhrase = { ConfirmPhrase(text: String(format: S.ConfirmPaperPhrase.word, "\(self.fourIndices.1 + 1)"), word: self.words[self.fourIndices.1]) }()
    private lazy var confirmThirdPhrase: ConfirmPhrase = { ConfirmPhrase(text: String(format: S.ConfirmPaperPhrase.word, "\(self.fourIndices.2 + 1)"), word: self.words[self.fourIndices.2]) }()
    private lazy var confirmFourthPhrase: ConfirmPhrase = { ConfirmPhrase(text: String(format: S.ConfirmPaperPhrase.word, "\(self.fourIndices.3 + 1)"), word: self.words[self.fourIndices.3]) }()

    var store: Store?
    var walletManager: WalletManager?
    var pin: String?

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear(_: Bool) {
        firstWordCell.confirmPhraseView = confirmFirstPhrase
        secondWordCell.confirmPhraseView = confirmSecondPhrase
        thirdWordCell.confirmPhraseView = confirmThirdPhrase
        fourthWordCell.confirmPhraseView = confirmFourthPhrase
    }

    override func viewDidLoad() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        setupSubViews()
        firstWordCell.confirmPhraseView?.textField.becomeFirstResponder()
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func setupSubViews() {
        headerView.backgroundColor = .liteWalletBlue
        headerTitleLabel.font = UIFont.barlowBold(size: 18.0)
        headerDescriptionLabel.font = UIFont.barlowRegular(size: 14.0)

        headerTitleLabel.text = S.SecurityCenter.Cells.paperKeyTitle
        headerDescriptionLabel.text = S.ConfirmPaperPhrase.label
        headerTitleLabel.textColor = .white
        headerDescriptionLabel.textColor = .white

        firstWordCell.addSubview(confirmFirstPhrase)
        firstWordCell.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "|-[confirmFirstPhrase]-|", options: [], metrics: nil,
            views: ["confirmFirstPhrase": confirmFirstPhrase]
        ))

        secondWordCell.addSubview(confirmSecondPhrase)
        secondWordCell.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "|-[confirmSecondPhrase]-|", options: [], metrics: nil,
            views: ["confirmSecondPhrase": confirmSecondPhrase]
        ))

        thirdWordCell.addSubview(confirmThirdPhrase)
        thirdWordCell.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "|-[confirmThirdPhrase]-|", options: [], metrics: nil,
            views: ["confirmThirdPhrase": confirmThirdPhrase]
        ))

        fourthWordCell.addSubview(confirmFourthPhrase)
        fourthWordCell.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "|-[confirmFourthPhrase]-|", options: [], metrics: nil,
            views: ["confirmFourthPhrase": confirmFourthPhrase]
        ))

        backButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        submitButton.setTitle(S.Button.submit, for: .normal)
        submitButton.titleLabel?.font = UIFont.barlowBold(size: 18.0)
        submitButton.backgroundColor = .liteWalletBlue
        submitButton.layer.cornerRadius = 4.0
        submitButton.clipsToBounds = true
        submitButton.addTarget(self, action: #selector(checkPhrases), for: .touchUpInside)

        confirmFirstPhrase.callback = { [weak self] in
            if self?.confirmFirstPhrase.textField.text == self?.confirmFirstPhrase.word {
                self?.confirmSecondPhrase.textField.becomeFirstResponder()
            }
        }
        confirmFirstPhrase.isEditingCallback = { [weak self] in
            self?.adjustScrollView(set: 1)
        }
        confirmSecondPhrase.callback = { [weak self] in
            if self?.confirmSecondPhrase.textField.text == self?.confirmSecondPhrase.word {
                self?.confirmThirdPhrase.textField.becomeFirstResponder()
            }
        }
        confirmSecondPhrase.isEditingCallback = { [weak self] in
            self?.adjustScrollView(set: 2)
        }
        confirmThirdPhrase.callback = { [weak self] in
            if self?.confirmThirdPhrase.textField.text == self?.confirmThirdPhrase.word {
                self?.confirmFourthPhrase.textField.becomeFirstResponder()
            }
        }
        confirmThirdPhrase.isEditingCallback = { [weak self] in
            self?.adjustScrollView(set: 3)
        }
        confirmFourthPhrase.isEditingCallback = { [weak self] in
            self?.adjustScrollView(set: 4)
        }
    }

    private func adjustScrollView(set: Int) {
        let constant = 20.0
        let offset = CGFloat(constant) * CGFloat(set)
        tableView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
    }

    @objc private func dismissController() {
        dismiss(animated: true)
    }

    @objc private func checkPhrases() {
        guard let store = self.store else {
            NSLog("ERROR: Store not initialized")
            return
        }

        if firstWordCell.confirmPhraseView?.textField.text == words[fourIndices.0] &&
            secondWordCell.confirmPhraseView?.textField.text == words[fourIndices.1] &&
            thirdWordCell.confirmPhraseView?.textField.text == words[fourIndices.2] &&
            fourthWordCell.confirmPhraseView?.textField.text == words[fourIndices.3] {
            UserDefaults.writePaperPhraseDate = Date()
            store.trigger(name: .didWritePaperKey)
            didCompleteConfirmation?()
        } else {
            firstWordCell.confirmPhraseView?.validate()
            secondWordCell.confirmPhraseView?.validate()
            thirdWordCell.confirmPhraseView?.validate()
            fourthWordCell.confirmPhraseView?.validate()
            showErrorMessage(S.ConfirmPaperPhrase.error)
        }
    }
}

class ConfirmPhraseTableViewCell: UITableViewCell {
    var confirmPhraseView: ConfirmPhrase?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
