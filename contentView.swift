import SwiftUI

extension Color {
    static let bgDark = Color(red: 0.05, green: 0.05, blue: 0.08)
    static let cardBg = Color(red: 0.12, green: 0.1, blue: 0.15)
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let green = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let red = Color(red: 0.9, green: 0.2, blue: 0.3)
    static let blue = Color(red: 0.0, green: 0.5, blue: 1.0)
}

// MARK: - Main App Entry
struct ContentView: View {
    @State private var isActivated = false
    @State private var keyInput = ""
    @State private var isLoading = false
    @State private var errorMsg = ""
    
    var body: some View {
        if isActivated {
            MainTabView()
        } else {
            ZStack {
                Color.bgDark.ignoresSafeArea()
                VStack(spacing: 25) {
                    Spacer()
                    Image(systemName: "key.fill").font(.system(size: 70)).foregroundColor(.blue)
                    Text("HOÀNG NAM").font(.system(size: 36, weight: .bold)).foregroundColor(.white)
                    
                    if errorMsg.isEmpty {
                        Text("KÍCH HOẠT THÀNH CÔNG").font(.subheadline.bold()).foregroundColor(.green)
                    } else {
                        Text(errorMsg).font(.subheadline.bold()).foregroundColor(.red)
                    }
                    
                    TextField("Nhập key của bạn", text: $keyInput)
                        .padding().background(Color.cardBg).cornerRadius(12).foregroundColor(.white).autocapitalization(.none)
                        .padding(.horizontal, 30)
                    
                    Button(action: checkKey) {
                        if isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("KÍCH HOẠT KEY").font(.headline).foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity).padding().background(Color.blue).cornerRadius(12)
                    .padding(.horizontal, 30).disabled(isLoading)
                    Spacer()
                }
            }
        }
    }
    
    func checkKey() {
        guard !keyInput.isEmpty else { return }
        isLoading = true
        errorMsg = ""
        
        // THAY ĐỔI ĐƯỜNG DẪN API TẠI ĐÂY NẾU CẦN
        guard let url = URL(string: "https://blue-lab-a886.baonam310112.workers.dev/api/check?key=\(keyInput)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    if responseString.contains("success") || responseString.contains("true") || responseString.contains("hợp lệ") {
                        isActivated = true
                    } else {
                        errorMsg = "Key sai hoặc đã hết hạn!"
                    }
                } else {
                    errorMsg = "Lỗi kết nối Server!"
                }
            }
        }.resume()
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { Label("HOME", systemImage: "house.fill") }
            PatchView().tabItem { Label("PATCH", systemImage: "bolt.fill") }
            AdminView().tabItem { Label("ADMIN", systemImage: "person.fill") }
        }
        .accentColor(.gold)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.bgDark)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

// MARK: - Home View (Theo ảnh mẫu)
struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // Header
                HStack {
                    Image(systemName: "crown.fill").foregroundColor(.gold).font(.title2)
                    VStack(alignment: .leading) {
                        Text("MINH DUC").font(.title3.bold()).foregroundColor(.white)
                        Text("PREMIUM EDITION").font(.caption2.bold()).foregroundColor(.red)
                    }
                    Spacer()
                    Image(systemName: "bell.fill").foregroundColor(.gold).padding(8).background(Color.cardBg).clipShape(Circle())
                }.padding(.horizontal)
                
                // Thẻ VIP
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "crown.fill").foregroundColor(.gold)
                        Text("VIP MEMBER").font(.headline).foregroundColor(.gold)
                        Spacer()
                        Text("ACTIVE").font(.caption2.bold()).foregroundColor(.green).padding(.horizontal, 8).padding(.vertical, 4).background(Color.green.opacity(0.2)).cornerRadius(8)
                    }
                    Text("KEY: HOANGNAM-2024-VIP").font(.system(.caption, design: .monospaced)).foregroundColor(.white)
                    HStack {
                        Text("HẾT HẠN").font(.caption2).foregroundColor(.gray)
                        Spacer()
                        Text("∞").foregroundColor(.gold)
                    }
                }.padding().background(Color.cardBg).cornerRadius(15).overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gold.opacity(0.3), lineWidth: 1)).padding(.horizontal)
                
                // Thông tin Game
                VStack(alignment: .leading, spacing: 10) {
                    Text("GAME INFO").font(.headline).foregroundColor(.white)
                    InfoRow(icon: "gamecontroller.fill", title: "Game", value: "Free Fire", valueColor: .white)
                    InfoRow(icon: "shippingbox.fill", title: "Bundle", value: "com.dts.freefireth", valueColor: .white)
                    InfoRow(icon: "number", title: "Version", value: "1.104.1", valueColor: .white)
                    InfoRow(icon: "checkmark.circle.fill", title: "Installed", value: "Có", valueColor: .green)
                }.padding().background(Color.cardBg).cornerRadius(15).padding(.horizontal)
                
                // Trạng thái thiết bị
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("DEVICE STATUS").font(.headline).foregroundColor(.white)
                        Spacer()
                        Text("OFF").font(.caption2.bold()).foregroundColor(.red).padding(.horizontal, 8).padding(.vertical, 4).background(Color.red.opacity(0.2)).cornerRadius(8)
                    }
                    InfoRow(icon: "applelogo", title: "iOS", value: "17.2.0", valueColor: .white)
                    InfoRow(icon: "iphone", title: "Model", value: "iPhone12,1", valueColor: .white)
                    InfoRow(icon: "gear", title: "Support", value: "UNSUPPORTED", valueColor: .red)
                }.padding().background(Color.cardBg).cornerRadius(15).padding(.horizontal)
                
                // Server Ready
                HStack {
                    Circle().fill(Color.green).frame(width: 10, height: 10)
                    Text("Server: Online").foregroundColor(.white)
                    Spacer()
                    Text("128ms").foregroundColor(.gray)
                }.padding().background(Color.cardBg).cornerRadius(15).padding(.horizontal)
                
                HStack {
                    Circle().fill(Color.green).frame(width: 10, height: 10)
                    Text("SYSTEM READY").foregroundColor(.white)
                    Spacer()
                    Text("👑 HOANG NAM v1.0").foregroundColor(.gold)
                }.padding().background(Color.cardBg).cornerRadius(15).padding(.horizontal)
            }.padding(.vertical)
        }.background(Color.bgDark.ignoresSafeArea())
    }
}

// MARK: - Patch View (Theo ảnh mẫu)
struct PatchView: View {
    @State private var aimBody = false
    @State private var aimLock = false
    @State private var antiBan = false
    @State private var nheTam = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                HStack {
                    Image(systemName: "bolt.shield.fill").foregroundColor(.gold).font(.title2)
                    VStack(alignment: .leading) {
                        Text("PATCH CONTROL").font(.title3.bold()).foregroundColor(.white)
                        Text("FREE FIRE").font(.caption2.bold()).foregroundColor(.red)
                    }
                    Spacer()
                }.padding(.horizontal)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                    PatchCard(title: "AimBody", color: .red, isOn: $aimBody)
                    PatchCard(title: "AimLock", color: .gold, isOn: $aimLock)
                    PatchCard(title: "Antiban", color: .green, isOn: $antiBan)
                    PatchCard(title: "Nhẹ Tâm", color: .orange, isOn: $nheTam)
                }.padding(.horizontal)
                
                HStack {
                    Circle().fill(Color.red).frame(width: 10, height: 10)
                    Text("READY — SELECT A PATCH").foregroundColor(.white).font(.caption.bold())
                }.padding().frame(maxWidth: .infinity).background(Color.cardBg).cornerRadius(15).padding(.horizontal)
                
                VStack(spacing: 10) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "arrow.up.right.square.fill").foregroundColor(.red)
                            Text("FF NORMAL").foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }.padding().background(Color.cardBg).cornerRadius(15)
                    }
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "trash.fill").foregroundColor(.orange)
                            Text("Dọn Cache & Temp").foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }.padding().background(Color.cardBg).cornerRadius(15)
                    }
                }.padding(.horizontal)
                
            }.padding(.vertical)
        }.background(Color.bgDark.ignoresSafeArea())
    }
}

// MARK: - Admin View (Theo ảnh mẫu)
struct AdminView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    ZStack {
                        Circle().fill(Color.cardBg).frame(width: 90, height: 90).overlay(Circle().stroke(Color.gold, lineWidth: 2))
                        Text("HN").font(.title.bold()).foregroundColor(.gold)
                    }
                    Text("Admin Hoàng Nam").font(.title3.bold()).foregroundColor(.white)
                    Text("👑 BẢN PREMIUM").font(.caption.bold()).foregroundColor(.gold).padding(.horizontal, 12).padding(.vertical, 6).background(Color.gold.opacity(0.2)).cornerRadius(10)
                }.padding().frame(maxWidth: .infinity).background(Color.cardBg).cornerRadius(20).padding(.horizontal)
                
                VStack(spacing: 15) {
                    AdminMenuItem(icon: "key.fill", title: "Thông tin License", color: .gold)
                    AdminMenuItem(icon: "gearshape.fill", title: "Cài đặt", color: .red)
                    AdminMenuItem(icon: "doc.text.fill", title: "Dự án Patch", color: .blue)
                    AdminMenuItem(icon: "arrow.right.square.fill", title: "Xoá kích hoạt", color: .red)
                }.padding(.horizontal)
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "phone.fill").foregroundColor(.white)
                        Text("Zalo: 0358648824").font(.headline).foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(.white)
                    }.padding().background(Color.red).cornerRadius(15)
                }.padding(.horizontal)
            }.padding(.vertical)
        }.background(Color.bgDark.ignoresSafeArea())
    }
}

// MARK: - Components
struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    var valueColor: Color = .white
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(.gray).frame(width: 20)
            Text(title).foregroundColor(.gray)
            Spacer()
            Text(value).foregroundColor(valueColor)
        }
    }
}

struct PatchCard: View {
    let title: String
    let color: Color
    @Binding var isOn: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "bolt.fill").foregroundColor(.white).padding(8).background(color).clipShape(Circle())
                Spacer()
                Toggle("", isOn: $isOn).labelsHidden().tint(color)
            }
            Text(title).font(.headline).foregroundColor(.white)
            Text("FREE FIRE").font(.caption2.bold()).foregroundColor(color)
        }.padding().background(Color.cardBg).cornerRadius(15).overlay(RoundedRectangle(cornerRadius: 15).stroke(isOn ? color.opacity(0.5) : Color.clear, lineWidth: 1))
    }
}

struct AdminMenuItem: View {
    let icon: String
    let title: String
    let color: Color
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(.white).padding(10).background(color).clipShape(Circle())
            Text(title).foregroundColor(.white)
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.gray)
        }.padding().background(Color.cardBg).cornerRadius(15)
    }
}
