//
//  ListView.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 18.04.21.
//

import SwiftUI


struct ListView: View {
    @Binding var searchText: String
    var body: some View {
        ZStack{
            Color.flatDarkBackground.ignoresSafeArea()
            VStack{
                SearchBar(text: $searchText)
                    .padding(.top)
                Box(country: "Germany", city: "Berlin", temperature: 10)
                
            }
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(searchText: .constant(""))
        
    }
}





struct Box: View {
    
    var country: String
    var city: String
    var temperature: Int
    
    var body: some View {
        ZStack{
            HStack(spacing: 30){
                
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .red]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    HStack {
                        Text("\(temperature)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("km")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }.frame(width: 70, height: 70, alignment: .center)
                
                HStack(spacing: 20) {
                    HStack(){
                    Image(systemName: "mappin").foregroundColor(.white)
                    Text(country)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .padding(.bottom, 5)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    }
                    Text(city)
                        .padding(.bottom, 5)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    Image(systemName: "cloud.sun.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                }
                
                
            }.frame(width: 380, height: 100, alignment: .center)
            .background(Color.flatDarkCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

//
//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        Box(country: "Germany", city: "Berlin", temperature: 10)
//    }
//}




    
struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    var body: some View {
        
            HStack{
                TextField("Search ...", text: $text)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if isEditing {
                                Button(action: {
                                    self.text = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                    .onTapGesture {self.isEditing = true}
                
                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.text = ""
                        // Dismiss the keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Text("Cancel")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
                
            }.frame(width: 380, height: 100)
            .background(Color.flatDarkCardBackground)
    }
}

//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar(text: .constant(""))
//    }
//}



extension UIColor {
    
    static let flatDarkBackground = UIColor(red: 36, green: 36, blue: 36)
    static let flatDarkCardBackground = UIColor(red: 46, green: 46, blue: 46)

    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: a)
    }
}


extension Color {
    public init(decimalRed red: Double, green: Double, blue: Double) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }
    
    public static var flatDarkBackground: Color {
        return Color(decimalRed: 36, green: 36, blue: 36)
    }
    
    public static var flatDarkCardBackground: Color {
        return Color(decimalRed: 46, green: 46, blue: 46)
    }
}
