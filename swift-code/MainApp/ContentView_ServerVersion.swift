import SwiftUI

struct ContentView: View {
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

                // 使用说明（不需要输入 API Key）
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
                            Text("允许"完全访问"（访问服务器需要）")
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
                .padding(.vertical, 20)

                // 提示信息
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("免费使用，无需 OpenAI Key")
                            .font(.subheadline)
                    }

                    HStack {
                        Image(systemName: "server.rack")
                            .foregroundColor(.blue)
                        Text("由公司服务器提供支持")
                            .font(.subheadline)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 30)

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
        }
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
