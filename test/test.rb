require 'minitest/autorun'
require 'rack/test'
require_relative '../chat.rb'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "Contenido de la web" do

	it "Carga de la web" do
		get '/'
		assert last_response.ok?
	end

	it "Titulo de la web" do
		get '/'
		assert last_response.body.include?("<title>miniChat</title>")
	end

	it "Mostrando imagen de la web" do
		get '/'
		assert last_response.body.include?("images/logo.png")
	end

	it "Campo para la inserción de un usuario" do
		get '/'
		assert last_response.body.include?("Introduce un nombre")
	end

  it "Botón para entrar en el chat" do
    get '/'
    assert last_response.body.include?("Entrar")
  end

  it "Comprobación de usuario sin nombre" do
    post '/entrar'
    assert last_response.body.include?("¡No se puede entrar sin nombre, elige un nombre!")
  end

end
