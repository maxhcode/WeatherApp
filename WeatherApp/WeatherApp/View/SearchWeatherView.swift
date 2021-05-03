//
//  SearchWeatherView.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 18.04.21.
//

import SwiftUI


struct SearchWeatherView: View {
    @State var matchableValues: Array<String> = ["Berlin", "Hamburg", "Paris", "London"]
    @State var matchedValue: Array<String> = []
    @State var searchText: String = ""
    
    @StateObject var vm = SearchWeatherViewModel()
    @ObservedObject var listViewModel = ListViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UITableView.appearance().backgroundColor = UIColor.flatDarkBackground
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.flatDarkBackground.ignoresSafeArea()
                VStack{
                    MatchSearchBar(matchableValues: self.$matchableValues, matchedValues: self.$matchedValue,input: $searchText).textFieldStyle(RoundedBorderTextFieldStyle())
                    List{
                        ForEach(self.matchedValue, id: \.self){ value in
                            HStack{
                                Text(value)
                                    .foregroundColor(.white)
                                    .font(.system(size: 21))
                                Spacer()
                                Button(action: {
                                    listViewModel.weatherList.append(value)
                                }) {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(.green)
                                            .frame(width: 40, height: 50)
                                        
                                        Image(systemName: "plus.circle")
                                            .imageScale(.large)
                                            .foregroundColor(.white)
                                    }
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .contentShape(Rectangle())
                        }
                        .listRowBackground(Color.flatDarkCardBackground)
                        .background(Color.flatDarkCardBackground)
                        
                    }.listStyle(GroupedListStyle())
                    
                }
            }.navigationBarTitle(Text("Weather Search"))
        }.environmentObject(vm)
    }
}

struct SearchWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        SearchWeatherView()
    }
}


struct MatchSearchBar: View{
    @StateObject var searchWeatherViewModel = SearchWeatherViewModel()
    @Binding var matchableValues: Array<String>
    @Binding var matchedValues: Array<String>
    @Binding var input: String
    @State var matchingInterval: Double?
    @State var textFieldText: String?
    
    @State private var isBeingEdited: Bool = false
    
    init(matchableValues: Binding<Array<String>>, matchedValues: Binding<Array<String>>, input: Binding<String>, matchingInterval: Double? = 0.1){
        self._matchableValues = matchableValues
        self._matchedValues = matchedValues
        self._input = input
        
        self.textFieldText = textFieldText
        self.matchingInterval = matchingInterval
    }
    
    var body: some View {
        
        VStack{
            HStack{
                TextField(self.textFieldText ?? "Search", text: $input, onEditingChanged: { editing in self.realTimeMatching(status: editing); isBeingEdited=editing}, onCommit: { self.matchInput()})
                    .padding(7)
                    .padding(.horizontal, 25)
                    .cornerRadius(8)
                    .overlay(
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 0)
                            
                            if isBeingEdited {
                                Button(action: {
                                    self.input = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                
                if isBeingEdited {
                    Button(action: {
                        self.isBeingEdited = false
                        self.input = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Text("Cancel")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
        }
        .frame(width: 380, height: 100)
        .background(Color.flatDarkCardBackground)
    }
    
    func realTimeMatching(status: Bool) {
        self.isBeingEdited = status
        if status == true {
            Timer.scheduledTimer(withTimeInterval: self.matchingInterval ?? 1, repeats: true) { timer in
                self.matchInput()
                if self.isBeingEdited == false {
                    timer.invalidate()
                }
            }
        }
    }
    
    func matchInput(){
        self.matchedValues = []
        if !self.input.isEmpty{
            for matchable in matchableValues{
                if self.input.split(separator: " ").count > 1{
                    matchMultipleMatches(matchable: matchable)
                }
                
                else{
                    if matchable.contains(self.input) || matchable.contains(self.capitalizeFirstLetter(smallString: self.input)){
                        if !self.matchedValues.contains(String(matchable)){
                            self.matchedValues.append(String(matchable))
                        }
                    }
                }
            }
        }
    }
    
    func matchMultipleMatches(matchable: String) {
        for splittedInputString in self.input.split(separator: " ") {
            if matchable.contains(String(splittedInputString)) || matchable.contains(self.capitalizeFirstLetter(smallString: String(splittedInputString))){
                if !self.matchedValues.contains(matchable) {
                    self.matchedValues.append(matchable)
                }
            }
        }
    }
    
    private func capitalizeFirstLetter(smallString: String) -> String {
        return smallString.prefix(1).capitalized + smallString.dropFirst()
    }
}







