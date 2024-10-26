//
//  ContentView.swift
//  ColorFormator
//
//  Created by didi on 2024/10/21.
//

import SwiftUI

struct ContentView: View {
    @State private var hexColor: String = "#3498db" // 默认十六进制颜色值
    @State private var color: Color = Color.blue // 默认颜色
    @State private var rgba1Text: String = ""
    @State private var rgba255Text: String = ""
    @State private var swiftText: String = ""
    @State private var ocText: String = ""
    
    
    var body: some View {
        VStack {
            // 输入十六进制颜色值的文本框
//            TextField("Enter Hex Color", text: $hexColor, onCommit: {
//                updateColor()
//            })
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//            .padding()
            TextField("Enter Hex Color", text: $hexColor)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: hexColor) { _ in
                    updateColor()
                }
            
            // 实际显示颜色的矩形
            Rectangle()
                .fill(color)
                .frame(width: 200, height: 200)
                .border(Color.black, width: 2)
                .padding()
            
            // 显示RGBA值
            HStack {
                Button("复制") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(rgba255Text,
                                                   forType: .string)
                }
                Text("RGBA 0~255: " + rgba255Text)
                    .font(.system(size: 16))
            }
            HStack {
                Button("复制") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(rgba1Text,
                                                   forType: .string)
                }
                Text("RGBA 0~1: " + rgba1Text)
                    .font(.system(size: 16))
            }
            
            HStack {
                Button("复制") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(swiftText + " //" + hexColor,
                                                   forType: .string)
                }
                Text("Swift Code: " + swiftText)
                    .font(.system(size: 16))
            }
            HStack {
                Button("复制") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(ocText + " //" + hexColor,
                                                   forType: .string)
                }
                Text("OC Code: " + ocText)
                    .font(.system(size: 16))
            }
        }
        .padding()
        .frame(width: 800, height: 500)
        .onAppear {
            updateColor() // 初始化时更新颜色
        }
    }
    
    // 更新颜色和RGBA文本的方法
    func updateColor() {
        let uiColor = NSColor(hex: hexColor)
        color = Color(uiColor)
        rgba1Text = uiColor.toRGBA1()
        rgba255Text = uiColor.toRGBA255()
        swiftText = uiColor.toSwift()
        ocText = uiColor.toOC()
    }
}

// 扩展UIColor，将十六进制转换为RGBA
extension NSColor {
    convenience init(hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }

        var rgba: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgba)

        let length = hexFormatted.count

        var r, g, b, a: CGFloat
        switch length {
        case 3: // RGB (12-bit)
            r = CGFloat((rgba & 0xF00) >> 8) / 15.0
            g = CGFloat((rgba & 0x0F0) >> 4) / 15.0
            b = CGFloat(rgba & 0x00F) / 15.0
            a = 1.0
        case 4: // RGBA (16-bit)
            r = CGFloat((rgba & 0xF000) >> 12) / 15.0
            g = CGFloat((rgba & 0x0F00) >> 8) / 15.0
            b = CGFloat((rgba & 0x00F0) >> 4) / 15.0
            a = CGFloat(rgba & 0x000F) / 15.0
        case 6: // RRGGBB (24-bit)
            r = CGFloat((rgba & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgba & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgba & 0x0000FF) / 255.0
            a = 1.0
        case 8: // RRGGBBAA (32-bit)
            r = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgba & 0x000000FF) / 255.0
        default:
            r = 0.0
            g = 0.0
            b = 0.0
            a = 1.0
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    struct RGBA {
        var r: CGFloat
        var g: CGFloat
        var b: CGFloat
        var a: CGFloat
    }
    
    var rgba: RGBA {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return RGBA(r: r, g: g, b: b, a: a)
    }
    
    func toRGBA255() -> String {
        let rgba = self.rgba
        let r = rgba.r * 255.0;
        let g = rgba.g * 255.0;
        let b = rgba.b * 255.0;
        return String(format: "%g, %g, %g, %g", r, g, b, rgba.a)
    }
    
    func toRGBA1() -> String {
        let rgba = self.rgba
        return String(format: "%g, %g, %g, %g", rgba.r, rgba.g, rgba.b, rgba.a)
    }
    
    func toSwift() -> String {
        let rgba = self.rgba
        return String(format: "UIColor(red: %g, green: %g, blue: %g, alpha: %g)", rgba.r, rgba.g, rgba.b, rgba.a)
    }
    
    func toOC() -> String {
        let rgba = self.rgba
        return String(format: "[UIColor colorWithRed:%g green:%g blue:%g alpha:%g];", rgba.r, rgba.g, rgba.b, rgba.a)
    }
}




#Preview {
    ContentView()
}
