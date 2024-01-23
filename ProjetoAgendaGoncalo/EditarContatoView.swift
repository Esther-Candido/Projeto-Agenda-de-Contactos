//
//  EditarContatoView.swift
//  ProjetoAgendaGoncalo
//
//  Created by Eliseu on 29/09/2023.
//


//https://developer.apple.com/documentation/swiftui/environment    @environment do swift
//https://stackoverflow.com/questions/44324595/difference-between-dispatchqueue-main-async-and-dispatchqueue-main-sync  DispatchQueue.main.async do swift

import SwiftUI

struct EditarContatoView: View {
    
    @State private var URLimagemATUAL: URL? = nil
    
    @Environment(\.presentationMode) var mostrarTelaEditarContato    //acessar o ambiente apresentacao da tela de editarContato, assim ao salvar essa tela sera desativada....
    

    var contato: Contato

    @State private var firstName: String
    @State private var lastName: String
    @State private var email: String
    @State private var phone: String
    @State private var picture: String

    init(contato: Contato) {
        self.contato = contato
        _firstName = State(initialValue: contato.firstName)
        _lastName = State(initialValue: contato.lastName)
        _picture = State(initialValue: contato.picture)
        _email = State(initialValue: contato.email)
        _phone = State(initialValue: contato.phone)
    }

    var body: some View {
        
        
         VStack {
             
             ZStack{
                 
                 LinearGradient(
                    gradient: Gradient(colors: [Color.black,Color.blue.opacity(0.23)]),
                     startPoint: .top,
                     endPoint: .bottom
                 )
                 .edgesIgnoringSafeArea(.all)
                 .frame(height: 200)
                 
                 //plano de fundo com uma imagem sem foto, assim ao atualizar a picture, vai parecer que preencheu este espaço
                 AsyncImage(url: URL(string: "https://encurtador.com.br/fzLY4")) { image in image
                         .resizable()
                         .scaledToFill()  // imagem pra preencher todo espaço
                         .frame(width: 150, height: 150)
                         .clipShape(Circle())
         
                 } placeholder: {
                     ProgressView()  // exibir enquanto a imagem esta carregando
                 }
                 
                 
                 //exibir as imagens da API sao puxadas atraves da URL na variavel picture
                 if let url = URLimagemATUAL {
                     AsyncImage(url: url) { image in
                         image
                             .resizable()
                             .scaledToFill()
                             .frame(width: 150, height: 150)
                             .clipShape(Circle())
                             .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 4))
                     } placeholder: {
                         ProgressView()
                     }
                 }else{//caso tenha uma URL valida, entao mostra a foto da variavel picture..
                   
                     if let url = URL(string: contato.picture), let data = try? Data(contentsOf: url) {

                         Image(uiImage: UIImage(data: data) ?? UIImage())
                             .resizable()
                             .scaledToFill()  // imagem pra preencher todo espaço
                             .frame(width: 150, height: 150)
                             .clipShape(Circle())
                             .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 4))  // borda
                     }
                 }
                 
             }//zstack
     
  
         
 List{
     
                            //sessao que agloba o nome,sobrenome,email,telefone..
                             Section(header: Text("Editar Contato").font(.headline)) {
                                 HStack {
                                 Image(systemName: "photo.fill")
                                     .foregroundColor(.blue)
                                     .imageScale(.large)
                                 VStack(alignment: .leading) {
                                     Text("Foto")
                                         .font(.caption)
                                         .foregroundColor(.gray)
                                     TextField("", text: $picture)
                                     //para atualizar a foto ao colocar uma URl
                                         .onChange(of: picture) {
                                             URLimagemATUAL = URL(string: picture)
                                         }
                                         .font(.caption)
                                     
                                  
                                     
                                 }
                                 Spacer()
                                 }
                                 .padding()
                                 
                                 
                                 //espaco para o "Nome"
                                 HStack {
                                     Image(systemName: "person.fill")
                                         .foregroundColor(.blue)
                                         .imageScale(.large)
                                     VStack(alignment: .leading) {
                                         Text("Nome")
                                             .font(.caption)
                                             .foregroundColor(.gray)
                                         TextField("", text: $firstName)
                                             .font(.caption)
                                       
                                      
                                         
                                     }
                                     Spacer()
                                 }
                                 .padding()

                                 //espaco para o "sobrenome"
                                 HStack {
                                     Image(systemName: "person.crop.circle")
                                         .foregroundColor(.blue)
                                         .imageScale(.large)
                                     VStack(alignment: .leading) {
                                         Text("Sobrenome")
                                             .font(.caption)
                                             .foregroundColor(.gray)
                                         TextField("", text: $lastName)
                                             .font(.caption)

                                     }
                                     Spacer()
                                 }
                                 .padding()

                                 //espaco para o "email"
                                 HStack {
                                     Image(systemName: "envelope.fill")
                                         .foregroundColor(.blue)
                                         .imageScale(.large)
                                     VStack(alignment: .leading) {
                                         Text("Email (Não é permitido alterar)")  //isso ta na regra da Dummy API
                                             .font(.caption)
                                         .foregroundColor(.gray)
                                     Text(email)
                                         .font(.caption)
                                    
                                     
                                     }
                                     Spacer()
                                 }
                                 .padding()
                                 
                                 //espaco para o "telefone"
                                 HStack {
                                     Image(systemName: "phone.fill")
                                         .foregroundColor(.blue)
                                         .imageScale(.large)
                                     VStack(alignment: .leading) {
                                         Text("Telefone")
                                             .font(.caption)
                                             .foregroundColor(.gray)
                                         TextField("", text: $phone)
                                             .font(.caption)
                                         
  
                                     }
                                     Spacer()
                                 }
                                 .padding()
                             }//hstack
                         } //list
         
         

     
            
    
        }//VStack
         .navigationBarItems(trailing:
             VStack{
             Button("Salvar") {
                 APIconfig.compartilhar.editarContato(id: contato.id, firstName: firstName, lastName: lastName, picture: picture, email: email, phone: phone) { resultado in
                     DispatchQueue.main.async {
                         switch resultado {
                         case .success:
                             print("ATUALIZADO COM SUCESSO!")
                             self.mostrarTelaEditarContato.wrappedValue.dismiss()
                         case .failure(let erro):
                             print("ERRO AO ATUALIZAR! - \(erro.localizedDescription)")
                         }
                     }
                 }
             } //fim button
         }) //VStack
        
    
        
    } // fim body
     
} // fim struct
 

