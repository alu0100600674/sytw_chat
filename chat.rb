require 'sinatra'
require 'sinatra/reloader' if development?
#set :port, 3000
#set :environment, :production

enable :sessions
set :session_secret, '*&(^#234a)'

$lista_usuarios = Array.new

chat = ['Bienvenido..']

get '/' do
  erb :iniciarSesion
end

post '/entrar' do
  usuario = params['usuario']

  if($lista_usuarios.include? usuario)
   puts "------------------------------------------------"
   puts "El usuario #{usuario} ya existe."
   puts "Lista de usuario: #{$lista_usuarios}"
   puts "------------------------------------------------"
   erb :errorUsuario
  else
    if(usuario != "")
      session['usuario'] = usuario
      $lista_usuarios << usuario
      puts "------------------------------------------------"
      puts "El usuario #{usuario} ha entrado."
      puts "Lista de usuario: #{$lista_usuarios}"
      puts "------------------------------------------------"
      erb :chat
    else
      puts "------------------------------------------------"
      puts "Debe introducir un nombre de usuario."
      puts "Lista de usuario: #{$lista_usuarios}"
      puts "------------------------------------------------"
      erb :errorUsuarioVacio
    end
  end
end

get '/salir' do
  usuario_borrar = session['usuario']
  $lista_usuarios.delete(usuario_borrar)
  session.clear

  puts "------------------------------------------------"
  puts "El usuario #{usuario_borrar} ha salido."
  puts "Lista de usuario: #{$lista_usuarios}"
  puts "------------------------------------------------"

  #erb :iniciarSesion
  redirect '/'
end

get '/send' do
  return [404, {}, "Not an ajax request"] unless request.xhr?
  # chat << "#{request.ip} : #{params['text']}"
  chat << "#{session['usuario']}: #{params['text']}"
  nil
end

get '/update' do
  return [404, {}, "Not an ajax request"] unless request.xhr?
  @updates = chat[params['last'].to_i..-1] || []

  @last = chat.size
  erb <<-'HTML', :layout => false
      <% @updates.each do |phrase| %>
        <%= phrase %> <br />
      <% end %>
      <span data-last="<%= @last %>"></span>
  HTML
end

get '/updateUsuarios' do
  return [404, {}, "Not an ajax request"] unless request.xhr?
  @updates = $lista_usuarios[params['last'].to_i..-1] || []

  @last = $lista_usuarios.size
  erb <<-'HTML', :layout => false
      <% @updates.each do |phrase| %>
        <%= phrase %> <br />
      <% end %>
      <span data-last="<%= @last %>"></span>
  HTML
end
