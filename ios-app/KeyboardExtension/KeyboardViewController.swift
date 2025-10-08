import UIKit
import OpenAI

class KeyboardViewController: UIInputViewController {

    private var openAIService: OpenAIService?
    private var contextTextField: UITextField!
    private var suggestionsStackView: UIStackView!
    private var generateButton: UIButton!
    private var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化 OpenAI 服务
        setupOpenAI()

        // 设置 UI
        setupUI()
    }

    func setupOpenAI() {
        // 初始化 OpenAI 服务（会自动根据 AppSettings 选择模式）
        openAIService = OpenAIService()
    }

    func setupUI() {
        view.backgroundColor = UIColor.systemGray6

        // 主容器
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        // 输入框
        contextTextField = UITextField()
        contextTextField.placeholder = "输入你想说的话..."
        contextTextField.borderStyle = .roundedRect
        contextTextField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(contextTextField)

        // 生成按钮
        generateButton = UIButton(type: .system)
        generateButton.setTitle("🤖 生成建议", for: .normal)
        generateButton.backgroundColor = .systemBlue
        generateButton.setTitleColor(.white, for: .normal)
        generateButton.layer.cornerRadius = 8
        generateButton.translatesAutoresizingMaskIntoConstraints = false
        generateButton.addTarget(self, action: #selector(generateSuggestions), for: .touchUpInside)
        containerView.addSubview(generateButton)

        // 加载指示器
        loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        containerView.addSubview(loadingIndicator)

        // 建议显示区域
        suggestionsStackView = UIStackView()
        suggestionsStackView.axis = .vertical
        suggestionsStackView.spacing = 8
        suggestionsStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(suggestionsStackView)

        // 切换键盘按钮
        let switchKeyboardButton = UIButton(type: .system)
        switchKeyboardButton.setTitle("🌐", for: .normal)
        switchKeyboardButton.titleLabel?.font = .systemFont(ofSize: 24)
        switchKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        switchKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        containerView.addSubview(switchKeyboardButton)

        // 布局约束
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),

            contextTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
            contextTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contextTextField.trailingAnchor.constraint(equalTo: generateButton.leadingAnchor, constant: -8),
            contextTextField.heightAnchor.constraint(equalToConstant: 40),

            generateButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            generateButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            generateButton.widthAnchor.constraint(equalToConstant: 100),
            generateButton.heightAnchor.constraint(equalToConstant: 40),

            loadingIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: contextTextField.bottomAnchor, constant: 20),

            suggestionsStackView.topAnchor.constraint(equalTo: contextTextField.bottomAnchor, constant: 12),
            suggestionsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            suggestionsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            switchKeyboardButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            switchKeyboardButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            switchKeyboardButton.widthAnchor.constraint(equalToConstant: 44),
            switchKeyboardButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc func generateSuggestions() {
        guard let context = contextTextField.text, !context.isEmpty else {
            showAlert(message: "请输入一些文字")
            return
        }

        guard let service = openAIService else {
            showAlert(message: "请先在主 App 中设置 OpenAI API Key")
            return
        }

        // 显示加载
        loadingIndicator.startAnimating()
        generateButton.isEnabled = false
        clearSuggestions()

        // 调用 OpenAI
        Task {
            do {
                let suggestions = try await service.generateSuggestions(context: context, style: "幽默风趣")

                await MainActor.run {
                    loadingIndicator.stopAnimating()
                    generateButton.isEnabled = true
                    displaySuggestions(suggestions)
                }
            } catch {
                await MainActor.run {
                    loadingIndicator.stopAnimating()
                    generateButton.isEnabled = true
                    showAlert(message: "生成失败：\(error.localizedDescription)")
                }
            }
        }
    }

    func displaySuggestions(_ suggestions: [String]) {
        clearSuggestions()

        for suggestion in suggestions {
            let button = UIButton(type: .system)
            button.setTitle(suggestion, for: .normal)
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .left
            button.contentHorizontalAlignment = .left
            button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.addTarget(self, action: #selector(suggestionTapped(_:)), for: .touchUpInside)

            suggestionsStackView.addArrangedSubview(button)
        }
    }

    @objc func suggestionTapped(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }

        // 插入到文本框
        textDocumentProxy.insertText(text)

        // 清空输入框和建议
        contextTextField.text = ""
        clearSuggestions()
    }

    func clearSuggestions() {
        suggestionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    func showAlert(message: String) {
        // 简单提示（键盘扩展不能显示 UIAlert）
        print("⚠️ \(message)")

        // 可以显示一个临时的 label
        let label = UILabel()
        label.text = message
        label.textColor = .red
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        suggestionsStackView.addArrangedSubview(label)

        // 3秒后移除
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            label.removeFromSuperview()
        }
    }
}

