import SwiftUI

struct ContentView: View {
    @State private var apiMode: APIMode = AppSettings.shared.apiMode
    @State private var apiKey: String = ""
    @State private var serverURL: String = AppSettings.shared.serverURL
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Logo
                    VStack(spacing: 10) {
                        Image(systemName: "keyboard")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)

                        Text("SmartKeyboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("AI 泡妞助手")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)

                    // 模式选择
                    VStack(alignment: .leading, spacing: 15) {
                        Text("选择使用方式")
                            .font(.headline)

                        Picker("API Mode", selection: $apiMode) {
                            Text("🆓 公司服务器（免费）").tag(APIMode.companyServer)
                            Text("🔑 我的 OpenAI Key").tag(APIMode.userKey)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: apiMode) { _, newValue in
                            AppSettings.shared.apiMode = newValue
                        }
                    }
                    .padding(.horizontal, 30)

                    // 根据模式显示不同的配置
                    if apiMode == .companyServer {
                        serverModeView
                    } else {
                        userKeyModeView
                    }

                    Spacer()

                    // 使用说明
                    usageInstructions

                    // 打开键盘设置按钮
                    Button(action: openKeyboardSettings) {
                        Text("📱 打开键盘设置")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .alert("提示", isPresented: $showingAlert) {
                Button("好的", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
            .onAppear {
                // 加载保存的配置
                if let savedKey = AppSettings.shared.userAPIKey {
                    apiKey = savedKey
                }
            }
        }
    }

    // 公司服务器模式
    var serverModeView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("服务器配置")
                .font(.headline)

            TextField("http://your-aws-server.com:8000", text: $serverURL)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)

            Button(action: saveServerURL) {
                Text("保存服务器地址")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("完全免费使用")
                        .font(.subheadline)
                }

                HStack {
                    Image(systemName: "server.rack")
                        .foregroundColor(.blue)
                    Text("由公司服务器提供支持")
                        .font(.subheadline)
                }

                HStack {
                    Image(systemName: "lock.shield")
                        .foregroundColor(.orange)
                    Text("无需担心 API Key 泄露")
                        .font(.subheadline)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
        }
        .padding(.horizontal, 30)
    }

    // 用户 Key 模式
    var userKeyModeView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("OpenAI API Key")
                .font(.headline)

            SecureField("sk-proj-...", text: $apiKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)

            Button(action: saveAPIKey) {
                Text("保存 API Key")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "key.fill")
                        .foregroundColor(.blue)
                    Text("使用你自己的 OpenAI Key")
                        .font(.subheadline)
                }

                HStack {
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(.green)
                    Text("费用：约 $0.0005/次请求")
                        .font(.subheadline)
                }

                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.orange)
                    Text("Key 安全存储在 Keychain")
                        .font(.subheadline)
                }
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(10)

            Link(destination: URL(string: "https://platform.openai.com/api-keys")!) {
                HStack {
                    Image(systemName: "link")
                    Text("获取 OpenAI API Key")
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
        }
        .padding(.horizontal, 30)
    }

    // 使用说明
    var usageInstructions: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("使用说明：")
                .font(.headline)

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("1️⃣")
                    Text("在设置中启用 SmartKeyboard 键盘")
                }
                HStack {
                    Text("2️⃣")
                    Text("允许完全访问（必须！）")
                }
                HStack {
                    Text("3️⃣")
                    Text("在任意聊天 app 中切换到此键盘")
                }
                HStack {
                    Text("4️⃣")
                    Text("输入文字，点击建议即可插入")
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 10)
    }

    func saveServerURL() {
        if serverURL.isEmpty {
            alertMessage = "请输入服务器地址"
            showingAlert = true
            return
        }

        AppSettings.shared.serverURL = serverURL
        alertMessage = "✅ 服务器地址保存成功！"
        showingAlert = true
    }

    func saveAPIKey() {
        if apiKey.isEmpty {
            alertMessage = "请输入 OpenAI API Key"
            showingAlert = true
            return
        }

        if !apiKey.hasPrefix("sk-") {
            alertMessage = "API Key 格式不正确，应该以 sk- 开头"
            showingAlert = true
            return
        }

        AppSettings.shared.userAPIKey = apiKey
        alertMessage = "✅ API Key 保存成功！"
        showingAlert = true
    }

    func openKeyboardSettings() {
        if let url = URL(string: "App-Prefs:root=General&path=Keyboard/KEYBOARDS") {
            UIApplication.shared.open(url)
        } else if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    ContentView()
}

