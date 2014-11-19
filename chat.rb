require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
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
   puts "----USUARIO YA EXISTE----"
   erb :errorUsuario
  else
    session['usuario'] = usuario
    $lista_usuarios << usuario
    erb :chat
  end
end

get '/salir' do
  usuario_borrar = session['usuario']
  $lista_usuarios.delete(usuario_borrar)
  session.clear

  puts "----------------"
  puts usuario_borrar
  puts "----------------"
  puts $lista_usuarios

  erb :iniciarSesion
end

get '/send' do
  return [404, {}, "Not an ajax request"] unless request.xhr?
  chat << "#{request.ip} : #{params['text']}"
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
