import FirebaseFirestore

extension CollectionReference {
    
    func whereField(_ field: String, isDateInYear value: Date) -> Query {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: value)
        guard
            let today = Calendar.current.date(from: components),
            let passedYear = Calendar.current.date(byAdding: .year, value: 1, to: today),
            let end = Calendar.current.date(byAdding: .day, value: 1, to: today)
        else {
            fatalError("Could not find start date or calculate end date.")
        }
        return whereField(field, isGreaterThan: passedYear).whereField(field, isLessThan: end)
    }
    
    func whereField(_ field: String, isDateInToday value: Date) -> Query {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: value)
        guard
            let start = Calendar.current.date(from: components),
            let end = Calendar.current.date(byAdding: .day, value: 1, to: start)
            else {
                fatalError("Could not find start date or calculate end date.")
        }
        return whereField(field, isGreaterThan: start).whereField(field, isLessThan: end)
    }
}
