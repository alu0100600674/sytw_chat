require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
#set :port, 3000
#set :environment, :production

@lista_usuario = Array.new

chat = ['Bienvenido..']

get('/') { erb :iniciarSesion }

post '/entrar' do
  erb :chat
end

get '/salir' do
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
