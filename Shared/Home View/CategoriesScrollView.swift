//
//  SwiftUIView.swift
//  Festivals
//
//  Created by Tariq Almazyad on 1/15/21.
//

import SwiftUI

enum FestivalCategory: String, CaseIterable {
    case Musical
    case Book
    case Dance
    case Outdoor
    case Indoor
    case Club
    case VIPs
    
    var title: String{
        switch self {
        case .Musical: return "Musical Festival"
        case .Book: return "Book Festival"
        case .Dance: return "Dance Festival"
        case .Outdoor: return "Outdoor Festival"
        case .Indoor: return "Indoor Festival"
        case .Club: return "Club Festival"
        case .VIPs: return "VIPs Festival"
        }
    }
}


struct CategoriesScrollView: View {
    @Binding var selectedCategory: FestivalCategory
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(FestivalCategory.allCases, id:\.self) { category in
                    Button(action: {
                        withAnimation{
                            selectedCategory = category
                        }
                    }, label: {
                        Text(category.title)
                            .foregroundColor( selectedCategory == category ? .white : .gray)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .padding()
                            .background(selectedCategory == category ? Color(#colorLiteral(red: 0.5644914508, green: 0.406172514, blue: 0.8325149417, alpha: 1)) : Color(#colorLiteral(red: 0.207616061, green: 0.2596839666, blue: 0.3324835896, alpha: 1)))
                            .cornerRadius(20)
                            .shadow(color: selectedCategory == category ? Color.white.opacity(0.6) : Color.clear, radius: 8, x: 0.0, y: 0.0)
                        
                    }).padding(.horizontal, 6)
                }
            }.padding(18)
            .padding(.bottom, 34)
        }
    }
}
struct CategoriesScrollView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1401646137, green: 0.1773337126, blue: 0.2355768085, alpha: 1)), Color(#colorLiteral(red: 0.09998283535, green: 0.1434168518, blue: 0.1889503896, alpha: 1))]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            CategoriesScrollView(selectedCategory: .constant(FestivalCategory.Book))
        }.frame(width: 460, height: 160)
        .previewLayout(.sizeThatFits)
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1401646137, green: 0.1773337126, blue: 0.2355768085, alpha: 1)), Color(#colorLiteral(red: 0.09998283535, green: 0.1434168518, blue: 0.1889503896, alpha: 1))]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            HomeView()
                .foregroundColor(.white)
        }
            
    }
}
