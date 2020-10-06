//
//  ContentView.swift
//  Todo
//
//  Created by Tatsushi Fukunaga on 2020/10/04.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton: Bool = false
    
    @Environment(\.managedObjectContext) private var managedObjectContext

    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)])
    private var todos: FetchedResults<Item>

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(self.todos, id: \.self) { todo in
                        HStack {
                            Text(todo.name ?? "Unknown")
                            Spacer()
                            Text(todo.priority ?? "Unknown")
                        }
                    }// ForEach
                    .onDelete(perform: deleteTodo)
                }// List
                .navigationBarTitle("Todo", displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(action: {
                                            self.showingAddTodoView.toggle()
                                        }) {
                                            Image(systemName: "plus")
                                        }// AddButton
                                        .sheet(isPresented: $showingAddTodoView) {
                                            AddTodoView().environment(\.managedObjectContext, self.managedObjectContext)
                                        }
                )
                if todos.count == 0 {
                    EmptyList()
                }
            }// ZStack
            .sheet(isPresented: $showingAddTodoView) {
                AddTodoView().environment(\.managedObjectContext, self.managedObjectContext)
            }
            .overlay(
                ZStack {
                    Group {
                        Circle()
                            .fill(Color.blue)
                            .opacity(self.animatingButton ? 0.2 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(Color.blue)
                            .opacity(self.animatingButton ? 0.15 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                    }// Group
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                    Button(action: {
                        self.showingAddTodoView.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    }// Button
                    .onAppear(perform: {
                        self.animatingButton.toggle()
                    })
                }// ZStack
                .padding(.bottom, 15)
                .padding(.trailing, 15)
                , alignment: .bottomTrailing
            )
        }// NavigationView
    }
    
    //Function
    private func deleteTodo(at offsets: IndexSet){
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
