import SwiftUI

struct ContentView: View {
    @State private var key = ""
    @State private var activated = false
    @State private var message = "Nhập key để kích hoạt"

    private let blue = Color(red: 0.15, green: 0.48, blue: 1.0)
    private let features = [
        "AntiBan",
        "AimBody",
        "Nhẹ Tâm",
        "AimLock"
    ]

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
                    .foregroundStyle(blue)

                Text("HOANG NAM")
                    .font(.system(size: 30, weight: .black))
                    .tracking(3)
                    .foregroundStyle(.white)

                Text("KEY ACTIVATION")
                    .font(.caption.bold())
                    .tracking(4)
                    .foregroundStyle(blue)

                if !activated {
                    VStack(spacing: 16) {
                        TextField("Nhập key của bạn", text: $key)
                            .textInputAutocapitalization(.characters)
                            .autocorrectionDisabled()
                            .padding()
                            .background(.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .foregroundStyle(.white)

                        Button {
                            message = "Chưa kết nối máy chủ xác thực key"
                        } label: {
                            Text("KÍCH HOẠT KEY")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(blue)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .foregroundStyle(.white)
                        }
                        .disabled(key.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty)

                        Text(message)
                            .font(.footnote)
                            .foregroundStyle(.orange)
                    }
                    .padding(20)
                    .background(.white.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    ForEach(features, id: \.self) { feature in
                        HStack {
                            Image(systemName: "circle.grid.2x2.fill")
                                .foregroundStyle(blue)

                            Text(feature)
                                .foregroundStyle(.white)

                            Spacer()

                            Text("CHƯA TÍCH HỢP")
                                .font(.caption2)
                                .foregroundStyle(.orange)
                        }
                        .padding()
                        .background(.white.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }

                Spacer()
            }
            .padding(24)
            .padding(.top, 35)
        }
        .preferredColorScheme(.dark)
    }
}