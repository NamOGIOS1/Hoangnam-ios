import SwiftUI

extension Color {
    static let bgDark = Color(red: 0.05, green: 0.05, blue: 0.08)
    static let cardBg = Color(red: 0.1, green: 0.08, blue: 0.1)
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let green = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let red = Color(red: 0.9, green: 0.2, blue: 0.3)
    static let blue = Color(red: 0.0, green: 0.5, blue: 1.0)
}

struct ContentView: View {
    @State private var isActivated = false
    @State private var keyInput = ""
    @State private var isLoading = false
    @State private var errorMsg = ""
    
    var body: some View {
        if isActivated {
            MainTabView()
        } else {
            VStack(spacing: 20) {
                Image(systemName: "key.fill").font(.system(size: 60)).foregroundColor(.blue)
                Text("HOÀNG NAM").font(.largeTitle.bold()).foregroundColor(.white)
                Text("KÍCH HOẠT THÀNH CÔNG").font(.caption.bold()).foregroundColor(.green)
                
                TextField("Nhập key của bạn", text: $keyInput)
                    .padding().background(Color.cardBg).cornerRadius(10).foregroundColor(.white).autocapitalization(.none)
                
                if !errorMsg.isEmpty {
                    Text(errorMsg).foregroundColor(.red).font(.caption)
                }
                
                Button(action: checkKey) {
                    if isLoading {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("KÍCH HOẠT KEY").bold().foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity).padding().background(Color.blue).cornerRadius(10)
                .disabled(isLoading)
            }
            .padding().background(Color.bgDark.ignoresSafeArea())
        }
    }
    
    func checkKey() {
        guard !keyInput.isEmpty else { return }
        isLoading = true
        errorMsg = ""
        
        // ĐÃ SỬA LINK API THEO SERVER CỦA BẠN
        guard let url = URL(string: "https://blue-lab-a886.baonam310112.workers.dev/check") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["key": keyInput]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let status = json["status"] as? String, status == "success" {
                    isActivated = true
                } else {
                    errorMsg = "Key sai hoặc đã hết hạn!"
                }
            }
        }.resume()
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { Label("TRANG CHỦ", systemImage: "house.fill") }
            PatchView().tabItem { Label("PATCH", systemImage: "bolt.fill") }
            AdminView().tabItem { Label("ADMIN", systemImage: "person.fill") }
        }.accentColor(.gold)
    }
}

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "key.fill").foregroundColor(.blue).font(.title)
                    VStack(alignment: .leading) {
                        Text("HOÀNG NAM").font(.title2.bold()).foregroundColor(.white)
                        Text("KÍCH HOẠT THÀNH CÔNG").font(.caption.bold()).foregroundColor(.green)
                    }
                    Spacer()
                }.padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "crown.fill").foregroundColor(.gold)
                        Text("VIP MEMBER").font(.headline).foregroundColor(.gold)
                        Spacer()
                    }
                    Text("KEY: HOANGNAM-2024").font(.system(.caption, design: .monospaced)).foregroundColor(.white)
                }.padding().background(Color.cardBg).cornerRadius(15).padding(.horizontal)
            }.padding(.vertical)
        }.background(Color.bgDark.ignoresSafeArea())
    }
}

struct PatchView: View {
    @State private var aimbodyOn = false
    @State private var aimlockOn = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                HStack {
                    Text("Aimbody").font(.headline).foregroundColor(.white)
                    Spacer()
                    Toggle("", isOn: $aimbodyOn).labelsHidden()
                }.padding().background(Color.cardBg).cornerRadius(15)
                
                HStack {
                    Text("Aimlock").font(.headline).foregroundColor(.white)
                    Spacer()
                    Toggle("", isOn: $aimlockOn).labelsHidden()
                }.padding().background(Color.cardBg).cornerRadius(15)
            }.padding(.horizontal).padding(.vertical)
        }.background(Color.bgDark.ignoresSafeArea())
    }
}

struct AdminView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill").font(.system(size: 80)).foregroundColor(.gold)
            Text("Admin Hoàng Nam").font(.title2.bold()).foregroundColor(.white)
            Text("Phiên bản: 1.0.0").font(.caption).foregroundColor(.gray)
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.bgDark.ignoresSafeArea())
    }
}
