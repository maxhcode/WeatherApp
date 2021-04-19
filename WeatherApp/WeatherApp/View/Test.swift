//
//  Test.swift
//  WeatherApp
//
//  Created by Maximilian Hues on 18.04.21.
//

import SwiftUI


struct WeatherView2: View {
    //    @State var textFieldInput: String = "F"
    @State var predictableValues: Array<String> = ["First", "Second", "Third", "Fourth Second"]
    @State var predictedValue: Array<String> = []
    @State var searchText: String = "" //the .isEmpty only works if the strign cotains nothing thats why ""
    
    var body: some View {
        ZStack{
            Color.flatDarkBackground.ignoresSafeArea()
            VStack{
                Predict(predictableValues: self.$predictableValues, predictedValues: self.$predictedValue,input: $searchText).textFieldStyle(RoundedBorderTextFieldStyle())
                
                //This is going thorugh an empty list if something is added it will be shwon in a list view
                List{
                    ForEach(self.predictedValue, id: \.self){ value in
                        Text(value)
                    }
                }
            }
        }
    }
}

struct Predict: View{
    /// All possible predictable values. Can be only one.
    @Binding var predictableValues: Array<String>
    
    /// This returns the values that are being predicted based on the predictable values
    @Binding var predictedValues: Array<String>
    
    /// Current input of the user in the TextField. This is Binded as perhaps there is the urge to alter this during live time. E.g. when a predicted value was selected and the input should be cleared
    @Binding var input: String
    
    /// The time interval between predictions based on current input. Default is 0.1 second. I would not recommend setting this to low as it can be CPU heavy.
    @State var predictionInterval: Double?
    
    // Placeholder in empty TextField JUST FOR WHAT GOES INTO THE SEARCH FIELD
    @State var textFieldTitle: String?
    
    @State private var isBeingEdited: Bool = false
    
    init(predictableValues: Binding<Array<String>>, predictedValues: Binding<Array<String>>, input: Binding<String>, predictionInterval: Double? = 0.1){
        self._predictableValues = predictableValues
        self._predictedValues = predictedValues
        self._input = input //Variables with this _ infornt are binding variables
        
        self.textFieldTitle = textFieldTitle
        self.predictionInterval = predictionInterval
    }
    
    var body: some View {
        
        VStack{
            HStack{
                //editing is a vraible that is being created when going through the on EditingChanged which is triggered when the user is selecting the text field
                //;print(editing) editing is automattically a boolean which chnages its value if pressed on editing
                //This editing boolean is then being passed in the function while being in the loop / being constantly checked if true or false
                TextField(self.textFieldTitle ?? "Search", text: $input, onEditingChanged: { editing in self.realTimePrediction(status: editing); isBeingEdited=editing}, onCommit: { self.matchInput()})
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
                        // Dismiss the keyboard
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
   
    
    
    /// Schedules prediction based on interval and only a if input is being made
    //This here is then receieving the boolean value into the fucntion if it is editing in the search field or not
    func realTimePrediction(status: Bool) {
        //This value then is being saved into the variable
        self.isBeingEdited = status
        //If the status is true
        if status == true {
            //predictionInterval has default value double = 0.2
            //?? means short termn != nil
            //The timer is therefore to keep repating functions all the time over and over again to keep chekcing
            Timer.scheduledTimer(withTimeInterval: self.predictionInterval ?? 1, repeats: true) { timer in
                self.matchInput()
                //If it is not being edited anymore stop the timer
                if self.isBeingEdited == false {
                    timer.invalidate()
                }
            }
        }
    }
    
    /// Makes prediciton based on current input
    func matchInput(){
        self.predictedValues = []
        if !self.input.isEmpty{ //IF NOT EMPTY
            for predictable in predictableValues{
                // This is checking if more than one word is typed if yes it will return true otherwise it will return false
                if self.input.split(separator: " ").count > 1{
                    //If this happens make mutliple predtions otherwise make one
                    makeMultiPrediction(predictable: predictable)
                }
                
                else{
                    //If the predictable values contain the input OR if the predictable value contain the first captialized letter from the input
                    if predictable.contains(self.input) || predictable.contains(self.capitalizeFirstLetter(smallString: self.input)){
                        //When the predictedValue Array does not contain the string predictable so that there is no duplication then append to the predicted list
                        if !self.predictedValues.contains(String(predictable)){
                            //if it is not already in the array predicted values add it
                            self.predictedValues.append(String(predictable))
                        }
                    }
                }
            }
        }
    }
    
    /// Makes predictions if the input String is splittable
    //predictable is passed in from the looping from before which then continues to loop through the predictable and this will then pass all the values into the function
    func makeMultiPrediction(predictable: String) {
        //This is splittting up the input into ["This", "is"] an array like this
        //Then it is looping through the array of splitted up input
        for splittedInputString in self.input.split(separator: " ") {
            //If the above looped predictable array contains a the just above splitted string OR if the preditcable array is containing the captialized Letter from the above splitted up string
            if predictable.contains(String(splittedInputString)) || predictable.contains(self.capitalizeFirstLetter(smallString: String(splittedInputString))){
                //If then the predicted values are not yet in the array of predicted values Add it to the array
                if !self.predictedValues.contains(predictable) {
                    self.predictedValues.append(predictable)
                }
            }
        }
    }
    
    /// Capitalizes the first letter of a String
    private func capitalizeFirstLetter(smallString: String) -> String {
        return smallString.prefix(1).capitalized + smallString.dropFirst()
    }
}


struct WeatherView2_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView2()
    }
}
    
    
    
    
