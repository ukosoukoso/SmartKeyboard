import SwiftUI

struct ContentView: View {
    @State private var apiKey: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Logo/标题
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
                .padding(.top, 40)

                Spacer()

                // 设置区域
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

                    Text("💡 API Key 安全存储在 Keychain，不会泄露")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 30)

                // 使用说明
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
                            Text("在任意聊天 app 中切换到此键盘")
                        }
                        HStack {
                            Text("3️⃣")
                            Text("输入文字，点击建议即可插入")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)

                Spacer()

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
                .padding(.bottom, 40)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .alert("提示", isPresented: $showingAlert) {
                Button("好的", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
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

        // 保存到 Keychain
        KeychainHelper.save(key: "openai_api_key", value: apiKey)

        alertMessage = "✅ API Key 保存成功！现在可以使用键盘了"
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
