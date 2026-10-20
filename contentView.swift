import SwiftUI

struct ContentView: View {
    @State private var key = ""
    @State private var message = "Nhập key để kích hoạt"
    @State private var loading = false
    @State private var activated = false

    private let server =
        "https://blue-lab-a886.baonam310112.workers.dev/verify"

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.02, green: 0.04, blue: 0.10),
                    Color(red: 0.06, green: 0.12, blue: 0.23)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "key.horizontal.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.blue)

                Text("HOANG NAM")
                    .font(.system(size: 30, weight: .black))
                    .tracking(3)
                    .foregroundStyle(.white)

                if activated {
                    Text("KÍCH HOẠT THÀNH CÔNG")
                        .foregroundStyle(.green)
                } else {
                    TextField("Nhập key của bạn", text: $key)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .padding()
                        .background(.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.white)

                    Button(action: verifyKey) {
                        Text(loading ? "ĐANG KIỂM TRA..." : "KÍCH HOẠT KEY")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .foregroundStyle(.white)
                    }
                    .disabled(loading || key.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty)

                    Text(message)
                        .foregroundStyle(.orange)
                }

                Spacer()
            }
            .padding(24)
            .padding(.top, 40)
        }
        .preferredColorScheme(.dark)
    }

    private func verifyKey() {
        guard let url = URL(string: server) else { return }

        loading = true
        message = "Đang kiểm tra key..."

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.httpBody = try? JSONSerialization.data(
            withJSONObject: ["key": key.trimmingCharacters(
                in: .whitespacesAndNewlines
            )]
        )

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                loading = false

                guard error == nil,
                      let data = data,
                      let result = try? JSONSerialization.jsonObject(
                        with: data
                      ) as? [String: Any],
                      let valid = result["valid"] as? Bool else {
                    message = "Không kết nối được máy chủ"
                    return
                }

                if valid {
                    activated = true
                    message = "Key hợp lệ"
                } else {
                    message = result["message"] as? String
                        ?? "Key không hợp lệ"
                }
            }
        }.resume()
    }
}
